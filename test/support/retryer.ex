defmodule PhoenixTrello.Retryer do
  import Hound.Helpers.Element
  @retry_time 500

  def element_visible?(element, retries \\ 5) do
    if retries > 0 do
      case element_displayed?(element) do
        true -> true
        false ->
          :timer.sleep(@retry_time)
          element_visible?(element, retries - 1)
      end
    else
      element_displayed?(element)
    end
  end
end
