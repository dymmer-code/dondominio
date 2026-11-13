defmodule DonDominio.ZoneTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureLog

  alias DonDominio.Account.Zone
  alias DonDominio.Response

  defp zone(tld, requirements) do
    %{
      "tld" => tld,
      "tldtop" => tld,
      "authcodereq" => true,
      "requirements" => requirements,
      "create" => %{"price" => 10.0, "currency" => "EUR"},
      "renew" => %{"price" => 10.0, "currency" => "EUR"},
      "transfer" => %{"price" => 10.0, "currency" => "EUR"}
    }
  end

  describe "requirements" do
    test "a list of texts stays as it is" do
      assert %Zone{requirements: ["a", "b"]} = Zone.normalize(zone("es", ["a", "b"]))
    end

    test "one HTML text, as the API sends for .aero, becomes a list with it" do
      html =
        "<p>In order to register .aero domain names it is necessary to provide an Aero ID</p>\n"

      assert %Zone{tld: "aero", requirements: [^html]} = Zone.normalize(zone("aero", html))
    end

    test "an empty text is an empty list, and a missing field stays missing" do
      assert %Zone{requirements: []} = Zone.normalize(zone("com", "  "))

      assert %Zone{requirements: nil} =
               Zone.normalize(Map.delete(zone("com", nil), "requirements"))

      assert %Zone{requirements: nil} = Zone.normalize(zone("com", nil))
    end
  end

  describe "account/zones" do
    defp response(zones) do
      %{
        "success" => true,
        "errorCode" => 0,
        "errorCodeMsg" => "Success",
        "action" => "account/zones",
        "messages" => [],
        "responseData" => %{
          "queryInfo" => %{
            "page" => 1,
            "pageLength" => 1000,
            "results" => length(zones),
            "total" => length(zones)
          },
          "zones" => zones
        }
      }
    end

    test "a TLD with the requirements as a text no longer prevents the others from loading" do
      %Response{success: true, responseData: %{zones: zones}} =
        Response.normalize(
          response([zone("es", ["x"]), zone("aero", "<p>Aero ID</p>"), zone("com", [])])
        )

      assert Enum.map(zones, & &1.tld) == ["es", "aero", "com"]
    end

    test "a TLD that cannot be read at all is skipped and logged, and the rest stay" do
      log =
        capture_log(fn ->
          %Response{responseData: %{zones: zones}} =
            Response.normalize(
              response([zone("es", []), zone("odd", %{"unexpected" => "shape"}), zone("com", [])])
            )

          assert Enum.map(zones, & &1.tld) == ["es", "com"]
        end)

      assert log =~ ~s(zone "odd" skipped)
    end
  end
end
