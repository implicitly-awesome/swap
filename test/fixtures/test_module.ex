defmodule Test.TestModule do
  def call, do: Test.Dependency.call()
end
