defmodule Swap do
  use Decorator.Define, [swap: 1]
  use Swap.Container

  def swap({module, delegate_module}, body, _context) do
    quote do
      swap(unquote(module), unquote(delegate_module))
      result = unquote(body)
      revert(unquote(module))
      result
    end
  end
end
