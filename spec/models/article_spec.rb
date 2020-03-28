RSpec.describe Article, type: :model do
  describe "Articles has db columns" do
    it { is_expected.to have_db_column :id }
    it { is_expected.to have_db_column :title }
    it { is_expected.to have_db_column :lead }
    it { is_expected.to have_db_column :content }
    it { is_expected.to have_db_column :category }
    it { is_expected.to have_db_column :premium }
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :lead }
    it { is_expected.to validate_presence_of :content }
    it { is_expected.to validate_presence_of :category }
    it { is_expected.to validate_presence_of :premium }
  end

  describe "Factory" do
    it "Should have valid factory" do
      expect(create(:article)).to be_valid
    end
  end
end
