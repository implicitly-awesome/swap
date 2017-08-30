defmodule SwapTest do
  use ExUnit.Case, async: true
  use Swap.Container

  defmodule Dependency do
    def call, do: "dependency"
  end  

  defmodule TestDep do
    def call, do: "this is test dependency"
  end

  defmodule Test do
    use Swap

    @decorate swap({Dependency, TestDep})
    def call, do: Dependency.call()

    def call2, do: Dependency.call()
  end

  test "swaps a dependency for a single function" do
    assert Test.call() == TestDep.call()
    assert Test.call2() == Dependency.call()
  end

  test "swaps a dependency and reverts it" do
    swap Dependency, TestDep
    assert Dependency.call() == TestDep.call()
    revert Dependency
  end

  test "swaps a dependency for a block of code" do
    swap Dependency, TestDep do
      assert Dependency.call() == TestDep.call()
    end

    assert Dependency.call() == Dependency.call()
  end
end
