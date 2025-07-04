defmodule DonDominio.ResponseTest do
  use ExUnit.Case

  describe "domain normalize" do
    test "create" do
      response =
        Jason.decode!("""
        {
          "success": true,
          "errorCode": 0,
          "errorCodeMsg": "",
          "action": "domain\/create",
          "version": "1.0.26",
          "responseData": {
            "billing": {
              "total": 12.04,
              "currency": "EUR"
            },
            "domains": [
              {
                "name": "myexample.com",
                "status": "register-init",
                "tld": "com",
                "tsExpir": "",
                "domainID": 45762358,
                "period": 1
              }
            ]
          }
        }
        """)

      expected = %DonDominio.Response{
        success: true,
        errorCode: 0,
        errorMsg: "Success",
        action: "domain/create",
        version: "1.0.26",
        responseData: %{
          billing: %DonDominio.Domain.Billing{
            total: Decimal.new("12.04"),
            currency: "EUR"
          },
          domains: [
            %DonDominio.Domain.Create{
              name: "myexample.com",
              status: :"register-init",
              tld: "com",
              domainID: 45_762_358,
              period: 1
            }
          ]
        }
      }

      assert expected == DonDominio.Response.normalize(response)
    end

    test "transfer" do
      response =
        Jason.decode!("""
        {
          "success": true,
          "errorCode": 0,
          "errorCodeMsg": "",
          "action": "domain\/transfer",
          "version": "1.0.26",
          "responseData": {
            "billing": {
              "total": 12.04,
              "currency": "EUR"
            },
            "domains": [
              {
                "name": "myexample.com",
                "status": "register-init",
                "tld": "com",
                "tsExpir": "",
                "domainID": 45762358,
                "period": 1
              }
            ]
          }
        }
        """)

      expected = %DonDominio.Response{
        success: true,
        errorCode: 0,
        errorMsg: "Success",
        action: "domain/transfer",
        version: "1.0.26",
        responseData: %{
          billing: %DonDominio.Domain.Billing{
            total: Decimal.new("12.04"),
            currency: "EUR"
          },
          domains: [
            %DonDominio.Domain.Create{
              name: "myexample.com",
              status: :"register-init",
              tld: "com",
              domainID: 45_762_358,
              period: 1
            }
          ]
        }
      }

      assert expected == DonDominio.Response.normalize(response)
    end

    test "transfer restart" do
      response =
        Jason.decode!("""
        {
          "success": true,
          "errorCode": 0,
          "errorCodeMsg": "",
          "action": "domain\/transferrestart",
          "version": "1.0.26",
          "messages": [
            "Operation done correctly."
          ],
          "responseData": {
            "name": "example-domain.tv",
            "status": "active",
            "tld": "tv",
            "tsExpir": "2015-05-14",
            "domainID": 60523498
          }
        }
        """)

      expected = %DonDominio.Response{
        success: true,
        errorCode: 0,
        errorMsg: "Success",
        action: "domain/transferrestart",
        version: "1.0.26",
        messages: ["Operation done correctly."],
        responseData: %DonDominio.Domain.Status{
          name: "example-domain.tv",
          status: :active,
          tld: "tv",
          tsExpir: ~D[2015-05-14],
          domainID: 60_523_498
        }
      }

      assert expected == DonDominio.Response.normalize(response)
    end

    test "info status type" do
      response =
        Jason.decode!("""
        {
          "success": true,
          "errorCode": 0,
          "errorCodeMsg": "",
          "action": "domain\/getinfo",
          "version": "1.0.26",
          "responseData": {
            "name": "example-domain.tv",
            "status": "active",
            "tld": "tv",
            "tsExpir": "2015-05-14",
            "domainID": 340598,
            "tsCreate": "2005-05-14",
            "renewable": true,
            "renewalMode": "autorenew",
            "modifyBlock": false,
            "transferBlock": true,
            "whoisPrivacy": true,
            "authcodeCheck": true,
            "serviceAssociated": false,
            "ownerverification": "verified"
          }
        }
        """)

      expected = %DonDominio.Response{
        success: true,
        errorCode: 0,
        errorMsg: "Success",
        action: "domain/getinfo",
        version: "1.0.26",
        responseData: %DonDominio.Domain.Info{
          authcodeCheck: true,
          domainID: 340_598,
          modifyBlock: false,
          name: "example-domain.tv",
          ownerverification: "verified",
          renewable: true,
          renewalMode: :autorenew,
          serviceAssociated: false,
          status: :active,
          tld: "tv",
          transferBlock: true,
          tsCreate: ~D[2005-05-14],
          tsExpir: ~D[2015-05-14],
          whoisPrivacy: true
        }
      }

      assert expected == DonDominio.Response.normalize(response)
    end

    test "info contact type" do
      response =
        Jason.decode!("""
        {
          "success": true,
          "errorCode": 0,
          "errorCodeMsg": "",
          "action": "domain\/getinfo",
          "version": "1.0.26",
          "responseData": {
            "name": "example-domain.tv",
            "status": "active",
            "tld": "tv",
            "tsExpir": "2015-05-14",
            "domainID": 340598,
            "contactOwner": {
              "contactID": "JXD-2355464",
              "contactType": "organization",
              "firstName": "John",
              "lastName": "Ballack",
              "orgName": "Gotham S.L",
              "identNumber": "B336789224",
              "email": "john@test.com",
              "phone": "+34.90234232",
              "address": "Calle García, 25",
              "postalCode": "87500",
              "city": "Gotham City",
              "state": "Madrid",
              "country": "ES",
              "verificationstatus": "verified",
              "daaccepted": true
            }
          }
        }
        """)

      expected = %DonDominio.Response{
        success: true,
        errorCode: 0,
        errorMsg: "Success",
        action: "domain/getinfo",
        version: "1.0.26",
        responseData: %DonDominio.Domain.Info{
          name: "example-domain.tv",
          status: :active,
          tld: "tv",
          tsExpir: ~D[2015-05-14],
          domainID: 340_598,
          contactOwner: %{
            "contactID" => "JXD-2355464",
            "contactType" => "organization",
            "firstName" => "John",
            "lastName" => "Ballack",
            "orgName" => "Gotham S.L",
            "identNumber" => "B336789224",
            "email" => "john@test.com",
            "phone" => "+34.90234232",
            "address" => "Calle García, 25",
            "postalCode" => "87500",
            "city" => "Gotham City",
            "state" => "Madrid",
            "country" => "ES",
            "verificationstatus" => "verified",
            "daaccepted" => true
          }
        }
      }

      assert expected == DonDominio.Response.normalize(response)
    end

    test "info nameservers type" do
      response =
        Jason.decode!("""
        {
          "success": true,
          "errorCode": 0,
          "errorCodeMsg": "",
          "action": "domain\/getinfo",
          "version": "1.0.26",
          "responseData": {
            "name": "example-domain.tv",
            "status": "active",
            "tld": "tv",
            "tsExpir": "2015-05-14",
            "domainID": 340598,
            "defaultNS": false,
            "nameservers": [
              {
                "order": 1,
                "name": "ns1.example.com",
                "ipv4": "13.19.246.4"
              },
              {
                "order": 2,
                "name": "ns2.example.com",
                "ipv4": "13.19.246.5"
              }
            ]
          }
        }
        """)

      expected = %DonDominio.Response{
        success: true,
        errorCode: 0,
        errorMsg: "Success",
        action: "domain/getinfo",
        version: "1.0.26",
        responseData: %DonDominio.Domain.Info{
          name: "example-domain.tv",
          status: :active,
          tld: "tv",
          tsExpir: ~D[2015-05-14],
          domainID: 340_598,
          defaultNS: false,
          nameservers: [
            %DonDominio.Domain.Info.Nameservers{
              order: 1,
              name: "ns1.example.com",
              ipv4: "13.19.246.4"
            },
            %DonDominio.Domain.Info.Nameservers{
              order: 2,
              name: "ns2.example.com",
              ipv4: "13.19.246.5"
            }
          ]
        }
      }

      assert expected == DonDominio.Response.normalize(response)
    end

    test "info authcode type" do
      response =
        Jason.decode!("""
        {
          "success": true,
          "errorCode": 0,
          "errorCodeMsg": "",
          "action": "domain\/getinfo",
          "version": "1.0.26",
          "responseData": {
            "name": "example-domain.tv",
            "status": "active",
            "tld": "tv",
            "tsExpir": "2015-05-14",
            "domainID": 340598,
            "authcode": "9523as&'asd1wAd"
          }
        }
        """)

      expected = %DonDominio.Response{
        success: true,
        errorCode: 0,
        errorMsg: "Success",
        action: "domain/getinfo",
        version: "1.0.26",
        responseData: %DonDominio.Domain.Info{
          name: "example-domain.tv",
          status: :active,
          tld: "tv",
          tsExpir: ~D[2015-05-14],
          domainID: 340_598,
          authcode: "9523as&'asd1wAd"
        }
      }

      assert expected == DonDominio.Response.normalize(response)
    end

    test "renew" do
      response =
        Jason.decode!("""
        {
          "success": true,
          "errorCode": 0,
          "errorCodeMsg": "",
          "action": "domain\/renew",
          "version": "1.0.26",
          "responseData": {
            "billing": {
              "total": 53.25,
              "currency": "EUR"
            },
            "domains": [
              {
                "name": "example-domain.tel",
                "status": "renewed",
                "tld": "tel",
                "domainID": 153508,
                "tsExpir": "2015-05-17",
                "renewPeriod": "4"
              }
            ]
          }
        }
        """)

      expected = %DonDominio.Response{
        success: true,
        errorCode: 0,
        errorMsg: "Success",
        action: "domain/renew",
        version: "1.0.26",
        responseData: %{
          billing: %DonDominio.Domain.Billing{
            total: Decimal.new("53.25"),
            currency: "EUR"
          },
          domains: [
            %DonDominio.Domain.Renew{
              name: "example-domain.tel",
              status: :renewed,
              tld: "tel",
              tsExpir: ~D[2015-05-17],
              domainID: 153_508,
              renewPeriod: 4
            }
          ]
        }
      }

      assert expected == DonDominio.Response.normalize(response)
    end
  end
end
