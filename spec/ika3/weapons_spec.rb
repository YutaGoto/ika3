RSpec.describe Ika3::Weapon do
  let(:weapon) do
    weapon = Ika3::Weapon[
      name: weapon_name,
      sub: sub_name,
      special: special_name,
    ]
    weapon.io = mock_io
    weapon
  end

  let(:mock_io) {StringIO.new}
  let(:weapon_name) {'わかばシューター'}
  let(:sub_name) {'スプラボム'}
  let(:special_name) {'グレートバリア'}
  let(:key_name) {:splattershot_jr}

  describe "#name" do
    it "get weapon name" do
      expect(weapon.name).to eq weapon_name
    end
  end

  describe "#sub" do
    it "get sub weapon name" do
      expect(weapon.sub).to eq sub_name
    end
  end

  describe "#special" do
    it "get special name" do
      expect(weapon.special).to eq special_name
    end
  end

  describe "#find_by_name" do
    it "get weapon info from name" do
      expect(Ika3::Weapon.find_by_name(weapon_name)).to eq weapon
    end
  end

  describe "#filter_by_sub" do
    it "get weapon info list from sub weapon" do
      expect(Ika3::Weapon.filter_by_sub(sub_name)).to include weapon
    end
  end
end
