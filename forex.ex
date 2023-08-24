defmodule Febrd.Forex do



    @moduledoc """
    Contains functions related to the Forex functions from Alpha Vantage
    """

    import Febrd.Helper

    @module_id "FX"

    @doc """
    Uses Alpha Vantage's CURRENCY_EXCHANGE_RATE function.
    Returns the realtime exchange rate for any pair of digital currency (e.g. Bitcoin)
    or physical currency (e.g. USD)

    Args:

    * `from_currency` - The currency to get the exchange rate for. e.g. "USD" or "BTC"
    * `to_currency` - The destination currency for the exchange rate. e.g. "USD" or "BTC"
    * `opts` - A list of extra options to pass to the function.

    Allowed options:

    * `datatype` - `:map | :json | :csv` specifies the return format. Defaults to :map

    ## Examples:

        iex> Vantagex.Forex.exchange_rate("USD", "COP")
        %{
          "Realtime Currency Exchange Rate" => %{
            "1. From_Currency Code" => "USD",
            "2. From_Currency Name" => "United States Dollar",
            "3. To_Currency Code" => "COP",
            "4. To_Currency Name" => "Colombian Peso",
            "5. Exchange Rate" => "3130.00000000",
            "6. Last Refreshed" => "2019-02-16 22:33:37",
            "7. Time Zone" => "UTC"
          }
        }

        iex> Vantagex.Forex.exchange_rate("USD", "COP", datatype: :json)
        "{\\n    \"Realtime Currency Exchange Rate\": {\\n        \"1. From_Currency Code\": \"USD\",\\n        \"2. From_Currency Name\": \"United States Dollar\",\\n        \"3. To_Currency Code\": \"COP\",\\n        \"4. To_Currency Name\": \"Colombian Peso\",\\n        \"5. Exchange Rate\": \"3130.00000000\",\\n        \"6. Last Refreshed\": \"2019-02-16 22:34:00\",\\n        \"7. Time Zone\": \"UTC\"\\n    }\\n}"
    """
    @spec exchange_rate(String.t(), String.t(), Keyword.t()) :: Map.t() | String.t()
    def exchange_rate(from_currency, to_currency, opts \\ []) do
      params = %{
        from_currency: from_currency,
        to_currency: to_currency,
        datatype: Keyword.get(opts, :datatype)
      } |> clean_params()

      resolve_request(:currency_exchange_rate, params)
    end

    @doc """
    Uses Alpha Vantage `FX_INTRADAY` function.
    Returns intraday time series of the FX currency pair specified

    Args:

    * `from_symbol` - three letter string representing the currency. e.g. `"EUR"`
    * `to_symbol` - three letter string representing the currency. e.g. `"USD"`
    * `interval` - an integer representing the time interval between data points of the time series. e.g. `5`
    * `opts` - A list of extra options to pass to the function.

    Allowed options:

    * `outputsize` - `:compact | :full` when set to compact returns the latest 100
    datapoints; when set to full returns the full length intraday time series. Defaults to compact
    * `datatype` - `:map | :json | :csv` specifies the return format. Defaults to :map

    ## Examples

        iex> Vantagex.Forex.intraday("USD", "COP", 5)
        %{
          "Meta Data" => %{
            "1. Information" => "FX Intraday (5min) Time Series",
            "2. From Symbol" => "USD",
            "3. To Symbol" => "COP",
            "4. Last Refreshed" => "2019-02-17 22:40:00",
            "5. Interval" => "5min",
            "6. Output Size" => "Compact",
            "7. Time Zone" => "UTC"
          },
          "Time Series FX (5min)" => %{
            "2019-02-17 17:45:00" => %{
              "1. open" => "3130.0000",
              "2. high" => "3130.0000",
              "3. low" => "3130.0000",
              "4. close" => "3130.0000"
            },
            ...
          }
        }
    """
    @spec intraday(String.t(), String.t(), integer(), Keyword.t()) :: Map.t() | String.t()
    def intraday(from_symbol, to_symbol, interval, opts \\ []) do
      params = %{
        from_symbol: from_symbol,
        to_symbol: to_symbol,
        interval: "#{interval}min",
        outputsize: Keyword.get(opts, :outputsize),
        datatype: Keyword.get(opts, :datatype)
      } |> clean_params()

      resolve_request(:intraday, params, @module_id)
    end

    @doc """
    Uses Alpha Vantage's `FX_DAILY` function.
    Returns the daily time series of the FX currency pair specified.

    Args:

    * `from_symbol` - three letter string representing the currency. e.g. `"EUR"`
    * `to_symbol` - three letter string representing the currency. e.g. `"USD"`
    * `opts` - A list of extra options to pass to the function.

    Allowed options:

    * `outputsize` - `:compact | :full` when set to compact returns the latest 100
    datapoints; when set to full returns the full length intraday time series. Defaults to compact
    * `datatype` - `:map | :json | :csv` specifies the return format. Defaults to :map

    ## Examples

        iex> Vantagex.Forex.daily("USD", "COP")
        %{
          "Meta Data" => %{
            "1. Information" => "Forex Daily Prices (open, high, low, close)",
            "2. From Symbol" => "USD",
            "3. To Symbol" => "COP",
            "4. Output Size" => "Compact",
            "5. Last Refreshed" => "2019-02-19 06:40:00",
            "6. Time Zone" => "GMT+8"
          },
          "Time Series FX (Daily)" => %{
            "2018-11-12" => %{
              "1. open" => "3178.5000",
              "2. high" => "3178.5000",
              "3. low" => "3170.3000",
              "4. close" => "3174.3000"
            },
            "2018-12-06" => %{
              "1. open" => "3159.0000",
              "2. high" => "3191.8000",
              "3. low" => "3154.3000",
              "4. close" => "3184.2000"
            },
            ...
          }
        }
    """
    @spec daily(String.t(), String.t(), Keyword.t()) :: String.t() | Map.t()
    def daily(from_symbol, to_symbol, opts \\ []) do
      params = %{
        from_symbol: from_symbol,
        to_symbol: to_symbol,
        outputsize: Keyword.get(opts, :outputsize),
        datatype: Keyword.get(opts, :datatype)
      } |> clean_params()

      resolve_request(:daily, params, @module_id)
    end

    @doc """
    Uses Alpha Vantage's `FX_WEEKLY` function
    Returns the weekly time series of the FX currency pair specified.

    Args:

    * `from_symbol` - three letter string representing the currency. e.g. `"EUR"`
    * `to_symbol` - three letter string representing the currency. e.g. `"USD"`
    * `opts` - A list of extra options to pass to the function.

    Allowed options:

    * `outputsize` - `:compact | :full` when set to compact returns the latest 100
    datapoints; when set to full returns the full length intraday time series. Defaults to compact
    * `datatype` - `:map | :json | :csv` specifies the return format. Defaults to :map

    ## Examples

        iex> Vantagex.Forex.weekly("USD", "EUR")
        %{
          "Meta Data" => %{
            "1. Information" => "Forex Weekly Prices (open, high, low, close)",
            "2. From Symbol" => "USD",
            "3. To Symbol" => "EUR",
            "4. Last Refreshed" => "2019-02-19 07:05:00",
            "5. Time Zone" => "GMT+8"
          },
          "Time Series FX (Weekly)" => %{
            "2018-09-02" => %{
              "1. open" => "0.8597",
              "2. high" => "0.8630",
              "3. low" => "0.8522",
              "4. close" => "0.8620"
            },
            "2016-09-18" => %{
              "1. open" => "0.8897",
              "2. high" => "0.8967",
              "3. low" => "0.8867",
              "4. close" => "0.8959"
            },
            ...
          }
        }
    """
    @spec weekly(String.t(), String.t(), Keyword.t()) :: String.t() | Map.t()
    def weekly(from_symbol, to_symbol, opts \\ []) do
      params = %{
        from_symbol: from_symbol,
        to_symbol: to_symbol,
        outputsize: Keyword.get(opts, :outputsize),
        datatype: Keyword.get(opts, :datatype)
      } |> clean_params()

      resolve_request(:weekly, params, @module_id)
    end

    @doc """
    Uses Alpha Vantage's `FX_MONTHLY` function
    Returns the monthly time series of the FX currency pair specified.

    Args:

    * `from_symbol` - three letter string representing the currency. e.g. `"EUR"`
    * `to_symbol` - three letter string representing the currency. e.g. `"USD"`
    * `opts` - A list of extra options to pass to the function.

    Allowed options:

    * `outputsize` - `:compact | :full` when set to compact returns the latest 100
    datapoints; when set to full returns the full length intraday time series. Defaults to compact
    * `datatype` - `:map | :json | :csv` specifies the return format. Defaults to :map

    ## Examples

        iex> Vantagex.Forex.monthly("EUR", "USD")
        %{
          "Meta Data" => %{
            "1. Information" => "Forex Monthly Prices (open, high, low, close)",
            "2. From Symbol" => "EUR",
            "3. To Symbol" => "USD",
            "4. Last Refreshed" => "2019-02-19 07:10:00",
            "5. Time Zone" => "GMT+8"
          },
          "Time Series FX (Monthly)" => %{
            "2011-06-30" => %{
              "1. open" => "1.4412",
              "2. high" => "1.4696",
              "3. low" => "1.4070",
              "4. close" => "1.4491"
            },
            "2010-06-30" => %{
              "1. open" => "1.2306",
              "2. high" => "1.2467",
              "3. low" => "1.1874",
              "4. close" => "1.2234"
            },
            ...
          }
        }
    """
    @spec monthly(String.t(), String.t(), Keyword.t()) :: String.t() | Map.t()
    def monthly(from_symbol, to_symbol, opts \\ []) do
      params = %{
        from_symbol: from_symbol,
        to_symbol: to_symbol,
        outputsize: Keyword.get(opts, :outputsize),
        datatype: Keyword.get(opts, :datatype)
      } |> clean_params()

      resolve_request(:monthly, params, @module_id)
    end




end
