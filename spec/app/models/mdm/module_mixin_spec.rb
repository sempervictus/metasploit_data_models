require 'spec_helper'

describe Mdm::ModuleMixin do
  context 'associations' do
    it { should belong_to(:module_detail).class_name('Mdm::ModuleDetail') }
  end

  context 'database' do
    context 'columns' do
      it { should have_db_column(:module_detail_id).of_type(:integer) }
      it { should have_db_column(:name).of_type(:text) }
    end

    context 'indices' do
      it { should have_db_index(:module_detail_id) }
    end
  end

  context 'factories' do
    context 'mdm_module_mixin' do
      subject(:mdm_module_mixin) do
        FactoryGirl.build :mdm_module_mixin
      end

      it { should be_valid }
    end
  end

  context 'mass assignment security' do
    it { should_not allow_mass_assignment_of(:module_detail_id) }
    it { should allow_mass_assignment_of(:name) }
  end

  context 'validations' do
    it { should validate_presence_of(:module_detail) }
    it { should validate_presence_of(:name) }
  end
end