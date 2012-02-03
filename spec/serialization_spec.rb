require 'spec_helper.rb'
require 'active_record'

describe Rails3AMF::Serialization do
  before :all do

    class ModelWithoutDatabase
      extend ActiveModel::Naming
      include ActiveModel::AttributeMethods
      include ActiveModel::Serialization

      include ActiveRecord::Reflection
      include ActiveRecord::Serialization
      include ActiveRecord::Associations

      attr_accessor :attributes

      def initialize(attributes = {})
        @attributes = attributes
      end

      def read_attribute(attr_name)
        @attributes[attr_name.to_sym]
      end

      def read_attribute_for_validation(key)
        @attributes[key]
      end

      def persisted?
        false
      end

      def self.pluralize_table_names
        true
      end

      def self.inheritance_column
        "type"
      end
    end

    class User < ModelWithoutDatabase
      attr_accessor :id, :username, :password
      define_attribute_methods %w(id username password)
      has_many :courses
    end

    class Course < ModelWithoutDatabase
      attr_accessor :id, :name
      define_attribute_methods %w(id name)
    end

    class AMTest
      include ActiveModel::Serialization
      attr_accessor :id, :username, :password
      def attributes
        @attributes ||= {'username' => 'nil', 'password' => 'nil'}
      end
    end

    class Rails3AMF::IntermediateModel
      attr_accessor :model, :props
    end
  end

  before :each do
    # ActiveModel Object
    @model = AMTest.new
    @model.username = "user"
    @model.password = "pass"

    # ActiveRecord Object
    @user = User.new :username => "user", :password => "pass"
    User.stub!(:reflect_on_association).and_return(mock("association", :macro => :has_many))
    @user.stub!(:courses).and_return([Course.new(:name => "science")])

    # Resets
    Rails3AMF::IntermediateModel::TRAIT_CACHE.clear
    @config = Rails3AMF::Configuration.new
  end

  it "should serialize to intermediate form" do
    intermediate = @model.to_amf
    intermediate.should be_a(Rails3AMF::IntermediateModel)
    intermediate.model.should == @model
    intermediate.props.should == {"username" => "user", "password" => "pass"}
  end

  it "should encode to amf properly if not yet in intermediate form" do
    @model.should_receive(:to_amf).and_return(mock(Rails3AMF::IntermediateModel, :encode_amf => "success"))
    result = @model.encode_amf(mock("Serializer", :version => 3))
    result.should == "success"
  end

  it "should support relations in serialization" do
    intermediate = @user.to_amf :include => "courses"
    courses = intermediate.props["courses"]
    courses.length.should == 1
    courses[0].should be_a(Rails3AMF::IntermediateModel)
  end

  it "should automap classes when enabled" do
    @config.auto_class_mapping = true

    result = @model.encode_amf(mock("Serializer", :version => 3, :write_object => nil))
    traits = Rails3AMF::IntermediateModel::TRAIT_CACHE[@model.class]
    traits[:class_name].should == "AMTest"

    RocketAMF::ClassMapper.reset
    Rails3AMF::Configuration.reset
  end

  it "should not re-map defined classes" do
    @config.auto_class_mapping = true
    RocketAMF::ClassMapper.define {|m| m.map :as => "Changed", :ruby => "AMTest"}

    result = @model.encode_amf(mock("Serializer", :version => 3, :write_object => nil))
    traits = Rails3AMF::IntermediateModel::TRAIT_CACHE[@model.class]
    traits[:class_name].should == "Changed"

    RocketAMF::ClassMapper.reset
    Rails3AMF::Configuration.reset
  end

  it "should encode to AMF0 properly" do
    RocketAMF::ClassMapper.define {|m| m.map :as => "User", :ruby => "User"}

    output = RocketAMF.serialize(@user.to_amf(:include => "courses"), 0)

    fixture = File.open(File.dirname(__FILE__) + '/fixtures/amf0-ar-new.dat').read
    fixture.force_encoding("ASCII-8BIT") if fixture.respond_to?(:force_encoding)
    output.should == fixture

    RocketAMF::ClassMapper.reset
  end

  it "should encode to AMF3 properly and cache traits" do
    RocketAMF::ClassMapper.define {|m| m.map :as => "User", :ruby => "User"}

    output = RocketAMF.serialize(@user.to_amf(:include => "courses"), 3)

    fixture = File.open(File.dirname(__FILE__) + '/fixtures/amf3-ar-new.dat').read
    fixture.force_encoding("ASCII-8BIT") if fixture.respond_to?(:force_encoding)
    output.should == fixture
    Rails3AMF::IntermediateModel::TRAIT_CACHE.length.should == 2

    RocketAMF::ClassMapper.reset
  end
end