defmodule Swap.ContainerTest do
  use ExUnit.Case, async: true

  defmodule Dependency do
    def call, do: "dependency"
  end  

  defmodule TestDep do
    def call, do: "this is test dependency"
  end

  defmodule DevDep do
    def call, do: "this is dev dependency"
  end

  test "swaps a simple dependency" do
    defmodule Container1 do
      use Swap.Container

      swap Dep1, TestDep
    end

    assert Dep1.call() == TestDep.call()
  end

  test "swaps a dependency for an appropriate environment" do
    defmodule Container2 do
      use Swap.Container

      swap Dep2, TestDep, env: :test
    end

    assert Dep2.call() == TestDep.call()
  end

  test "swaps a dependency for an appropriate environment (change it on the fly)" do
    Mix.env(:dev)

    defmodule Container4 do
      use Swap.Container

      swap Dep4, DevDep, env: :dev
    end

    Mix.env(:test)

    assert Dep4.call() == DevDep.call()
  end

  test "doesnt swap a dependency for an unappropriate environment" do
    defmodule Container3 do
      use Swap.Container

      swap Dep3, DevDep, env: :dev
    end

    assert_raise UndefinedFunctionError, fn -> Dep3.call() end
  end

  test "swaps a dependency for an appropriate environment (multiple swaps)" do
    defmodule Container5 do
      use Swap.Container

      swap Dep5, TestDep, env: :test
      swap Dep5, DevDep, env: :dev
    end

    assert Dep5.call() == TestDep.call()
  end

  test "swaps a dependency for an appropriate environment (multiple swaps, change it on the fly)" do
    Mix.env(:dev)

    defmodule Container6 do
      use Swap.Container

      swap Dep6, TestDep, env: :test
      swap Dep6, DevDep, env: :dev
    end

    Mix.env(:test)

    assert Dep6.call() == DevDep.call()
  end

  test "swaps a dependency for an appropriate environment (multiple envs)" do
    defmodule Container7 do
      use Swap.Container

      swap Dep7, TestDep, env: [:dev, :test]
    end

    assert Dep7.call() == TestDep.call()

    Mix.env(:dev)
    assert Dep7.call() == TestDep.call()
    Mix.env(:test)
  end
end
