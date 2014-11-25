defmodule BankAccount do
  @opaque account :: pid

  @spec open_bank() :: account
  def open_bank() do
    {:ok, account} = Agent.start(fn -> 0 end)
    account
  end

  @spec close_bank(account) :: none
  def close_bank(account) do
    Agent.stop(account)
  end

  @spec balance(account) :: integer
  def balance(account) do
    Agent.get(account, fn balance -> balance end)
  end
 
  @spec update(account, integer) :: any
  def update(account, amount) do
    Agent.update(account, fn balance -> balance + amount end)
  end

end
