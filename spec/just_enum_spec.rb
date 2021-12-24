require_relative '../lib/just_enum'

class ButtonType < JustEnum::Base
  enum %i[primary secondary]
end

class Color < JustEnum::Base
  enum %i[success danger], mirror: true
end

class Labels < JustEnum::Base
  enum save: "Zapisz", cancel: "Anuluj"
end

class ButtonPrimary
  extend JustEnum::Enum
  enumerate :type, ButtonType, ButtonType.primary
  enumerate :color, Color, Color.success
  enumerate :label, Labels, Labels.save
end

RSpec.describe JustEnum do
  it "has a version number" do
    expect(JustEnum::VERSION).not_to be nil
  end

  it 'is defined' do
    expect(described_class).not_to eq nil
  end

  describe ButtonType do
    let(:options) { %i[primary secondary] }

    it 'defines enum options' do
      expect(ButtonType.options).to eq options
    end

    it 'defines options readers' do
      options.each_with_index do |option, index|
        expect(ButtonType.send(option)).to eq index
      end
    end
  end

  describe ButtonPrimary do
    let(:button_primary) { ButtonPrimary.new }

    it 'use ButtonType enum' do
      expect(button_primary._type).to eq ButtonType.primary
      expect(button_primary.button_type_primary?).to be_truthy
      expect(button_primary.button_type_secondary?).to be_falsey
      expect(button_primary.str_type).to eq "primary"
      expect(button_primary.color_success?).to be_truthy
      expect(button_primary._color).to eq Color.success
      expect(button_primary.color_danger?).to be_falsey
      expect(button_primary.str_color).to eq "success"
    end

  end

  describe Labels do
    let(:options) { { save: "Zapisz", cancel: "Anuluj" } }

    it 'defines enum options' do
      expect(Labels.options).to eq options
    end

    it 'defines options readers' do
      options.each_pair do |key, value|
        expect(Labels.send(key)).to eq value
      end
    end
  end
end
