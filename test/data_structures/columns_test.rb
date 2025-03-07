require 'test_helper'

class ColumnsTest < ActiveSupport::TestCase
  def setup
    @columns = ActiveScaffold::DataStructures::Columns.new(ModelStub, :a, :b)
  end

  def test_initialization
    assert_equal ModelStub, @columns.active_record_class

    assert @columns.include?('a'), 'checking via string'
    assert @columns.include?(:b), 'checking via symbol'
    assert_not @columns.include?(:c)
  end

  def test_add
    assert_not @columns.include?(:c)
    @columns.add 'c'
    assert @columns.include?('c')

    # test the alias
    assert_not @columns.include?(:d)
    @columns << :d
    assert @columns.include?(:d)

    # try adding an array of columns
    assert_not @columns.include?(:f)
    @columns.add %i[f g]
    assert @columns.include?(:f)
    assert @columns.include?(:g)
  end

  def test_finders
    # test some basic assumptions before testing the finders
    assert @columns.include?(:a)
    assert @columns[:a].is_a?(ActiveScaffold::DataStructures::Column)

    # test the single finders
    assert @columns.find_by_name(:a).name == :a
    assert @columns[:b].name == :b

    # test the collection finders
    found = @columns.find_by_names(:a, :b)
    assert(found.any? { |c| c.name == :a })
    assert(found.any? { |c| c.name == :b })
  end

  def test_each
    names = %i[a b]
    @columns.each do |column|
      assert names.include?(column.name)
    end
  end

  def test_block_config
    assert_not @columns.include?(:d)
    assert_not @columns.include?(:c)

    @columns.configure do |config|
      # test that we can use the config object
      config << :d
      # but test that we don't have to
      add 'c'
    end

    assert @columns.include?(:d)
    assert @columns.include?(:c)
  end
end
