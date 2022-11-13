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

  describe "#name" do
    it "get weapon name" do
      expect(weapon.name).to eq weapon_name
    end
  end
end
