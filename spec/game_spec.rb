require "game"

describe Game do 
  let(:game) { Game.new }

  context "adding frames" do 
    it "can create a Frame" do
      game.create_frame
      expect(game.frames.length).to eq 1
    end

    it "increments the Frame number" do
      game.create_frame
      expect(Frame).to receive(:new).with(2)
      game.create_frame
    end

    it "adds an entry in the scores hash" do
      game.create_frame
      expect(game.scores[:frame_1]).to eq 0
    end
  end

  context "#input_roll" do
    it "creates a frame to record the roll" do
      game.input_roll(4)
      expect(game.frames.length).to eq 1
    end

    it "creates another frame when the first is completed" do
      game.input_roll(10)
      game.input_roll(8)
      expect(game.frames.length).to eq 2
    end

    it "raises error for score inputs after 10th frame is completed" do
      allow(game.frames).to receive(:length).and_return(10)
      allow(game.frames[-1]).to receive(:completed?).and_return true
      expect { game.input_roll(4) }.to raise_error "Game is finished"
    end
  end

  context "calculating scores" do

    it "sums scores for first frame (no strike/spare)" do
      game.input_roll(4)
      game.input_roll(3)
      expect(game.scores[:frame_1]).to eq 7
    end

    it "sums scores for second frame (no strike/spare)" do
      game.input_roll(4)
      game.input_roll(3)
      game.input_roll(2)
      game.input_roll(3)
      expect(game.scores[:frame_2]).to eq 5
    end

    it "saves how many extra rolls are owed to a completed frame" do
      game.input_roll(10)
      game.input_roll(3)
      expect(game.owed_rolls[:frame_1]).to eq 1
    end

    it "adds next roll if there was a spare" do
      game.input_roll(4)
      game.input_roll(6)
      expect(game.scores[:frame_1]).to eq 10

      game.input_roll(8)
      expect(game.scores[:frame_1]).to eq 18
      expect(game.scores[:frame_2]).to eq 8

      game.input_roll(1)
      expect(game.scores[:frame_1]).to eq 18
    end

    it "adds next two rolls if there was a strike" do
      game.input_roll(10)
      game.input_roll(4)
      game.input_roll(3)
      expect(game.scores[:frame_1]).to eq 17
    end
 
  end

end
