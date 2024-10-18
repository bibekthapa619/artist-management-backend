require 'rails_helper'

RSpec.describe User, type: :model do
  subject { 
    described_class.new(
      first_name: "John", 
      last_name: "Doe", 
      email: "john.doe@example.com", 
      password: "password123", 
      gender: :m, 
      role: :artist_manager, 
      phone: "1234567890",
      dob: "1990-01-01"
    ) 
  }

  describe "Validations" do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should allow_value("email@example.com").for(:email) }
    it { should_not allow_value("invalid_email").for(:email) }
    it { should validate_length_of(:password).is_at_least(8) }

    it "validates phone format" do
      should allow_value("1234567890").for(:phone)
      should_not allow_value("123456").for(:phone)
      should_not allow_value("abcdefghij").for(:phone)
    end

    it "validates uniqueness of email" do
      duplicate_user = described_class.create(
        first_name: "Jane", 
        last_name: "Doe", 
        email: subject.email, 
        password: "password123",
        role: :super_admin
      )
      expect(subject).not_to be_valid
      expect(subject.errors[:email]).to include("has already been taken")
    end

    it "validates uniqueness of phone" do
      duplicate_user = described_class.create(
        first_name: "Jane", 
        last_name: "Doe", 
        email: "unique@email.com",
        phone: subject.phone, 
        password: "password123",
        role: :super_admin
      )
      expect(subject).not_to be_valid
      expect(subject.errors[:phone]).to include("has already been taken")
    end

    it "validates date of birth is not in the future" do
      subject.dob = Date.tomorrow
      expect(subject).not_to be_valid
      expect(subject.errors[:dob]).to include("can't be in future")
    end

    it "validates gender enum" do
      should allow_value(:m).for(:gender)
      should allow_value(:f).for(:gender)
      should allow_value(:o).for(:gender)
      
      # Invalid value
      expect { subject.gender = "invalid" }.to raise_error(ArgumentError, "'invalid' is not a valid gender")
    end

    it "validates role enum" do
      should allow_value(:super_admin).for(:role)
      should allow_value(:artist_manager).for(:role)
      should allow_value(:artist).for(:role)
      
      # Invalid value
      expect { subject.role = "invalid" }.to raise_error(ArgumentError, "'invalid' is not a valid role")
    end
  end

end
