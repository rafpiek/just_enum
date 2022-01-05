require_relative '../lib/just_enum'

class ButtonType < JustEnum::Base
  enum %i[primary secondary]
end

class Color < JustEnum::Base
  enum %i[success danger], mirror: true
end

class Label < JustEnum::Base
  enum save: "Zapisz", cancel: "Anuluj"
end

class ButtonPrimary
  extend JustEnum::Enum
  enumerate :type, ButtonType, ButtonType.primary
  enumerate :color, Color, Color.success
  enumerate :label, Label, Label.save
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
      expect(button_primary._label).to eq 'Zapisz'
      expect(button_primary.label_save?).to be_truthy
      expect(button_primary.label_cancel?).to be_falsey
      expect(button_primary.str_label).to eq 'Zapisz'
    end
  end

  describe 'mirroring keys' do
    let(:options) { { success: 'success', danger: 'danger' } }

    it 'defines enum options' do
      expect(Color.options).to eq options
    end

    it 'mirrors keys as strings' do
      expect(Color.success).to eq 'success'
      expect(Color.danger).to eq 'danger'
    end
  end

  describe Label do
    let(:options) { { save: "Zapisz", cancel: "Anuluj" } }

    it 'defines enum options' do
      expect(Label.options).to eq options
    end

    it 'defines options readers' do
      options.each_pair do |key, value|
        expect(Label.send(key)).to eq value
      end
    end
  end

  describe '.mirrored?' do
    it { expect(ButtonType.mirrored?).to be_falsey }
    it { expect(Color.mirrored?).to be_truthy }
    it { expect(Label.mirrored?).to be_falsey }
  end
end
