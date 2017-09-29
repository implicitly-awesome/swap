defmodule SwapWholeTest do
  use ExUnit.Case, async: true
  use Swap
  use Swap.Container

  defmodule NewDep do
    def call, do: "NewDep"
  end

  defmodule NewDep2 do
    def call, do: "NewDep2"
  end

  setup do
    swap Test.Dependency, NewDep

    on_exit(fn() -> revert Test.Dependency end)
    :ok
  end

  test "swaps a dependency for the whole test" do
    assert Test.TestModule.call() == NewDep.call()
  end

  describe "when swaps in a describe section" do
    setup do
      swap Test.Dependency, NewDep2

      on_exit(fn() -> revert Test.Dependency end)
      :ok
    end

    test "it swaps" do
      assert Test.TestModule.call() == NewDep2.call()
    end
  end

  @decorate swap({Test.Dependency, NewDep2})
  test "swaps a dependency for the whole test via decorator" do
    assert Test.TestModule.call() == NewDep2.call()
  end

  test "swaps a dependency for a block" do
    swap Test.Dependency, NewDep do
      assert Test.TestModule.call() == NewDep.call()
    end

    assert Test.TestModule.call() == Test.Dependency.call()
  end

  test "and then everything is as before" do
    assert Test.TestModule.call() == Test.Dependency.call()
  end
end
