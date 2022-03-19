Feature: /empleados/{correoElectronico} GET

  Consultar información referente a una solicitud de crédito

  Scenario: Negocio un consumer key y secret key de la app de prueba

    Given I have basic authentication credentials `apigeeUsername` and `apigeePassword`
    And I have valid client TLS configuration

    When I GET `apigeeHost`/v1/organizations/`apigeeOrg`/developers/`apigeeDeveloper`/apps/`apigeeApp`

    Then response code should be 200
    And response body should be valid json
    And I store the value of body path $.credentials[0].consumerKey as globalConsumerKey in global scope
    And I store the value of body path $.credentials[0].consumerSecret as globalConsumerSecret in global scope

  Scenario: Negocia un access token con el Authorization server

    Given I set form parameters to
      | parameter | value |
      | grant_type | client_credentials |
    And I have basic authentication credentials `globalConsumerKey` and `globalConsumerSecret`
    And I have valid client TLS configuration

    When I POST to `apigeeDomain`/`apigeeOauthEndpoint`

    Then response code should be 200
    And response body should be valid json
    And I store the value of body path $.access_token as access token

  Scenario Outline: /empleados/{correoElectronico} 200 ok.

    Given I set bearer token
    And I have valid client TLS configuration

    When I GET `apigeeDomain`/banca-digital/empleados/`deploymentSuffix`/<correoElectronico>

    Then response code should be 200
    And response body should be valid json

    And response body path $.mensaje should be ^.*$
    And response body path $.folio should be ^.*$
    And response body path $.resultado.id should be ^.*$
    And response body path $.resultado.nombre should be ^.*$
    And response body path $.resultado.correoElectronico should be ^.*$
    And response body path $.resultado.numeroTelefono should be ^.*$
    And response body path $.resultado.domicilio.calle should be ^.*$
    And response body path $.resultado.domicilio.numero should be ^.*$
    And response body path $.resultado.domicilio.codigoPostal should be ^.*$
    And response body path $.resultado.domicilio.ciudad should be ^.*$

    Examples:
      | correoElectronico |
      | 1         |

  Scenario Outline: /empleados/{correoElectronico} 400 bad request.

    Given I set bearer token
    And I have valid client TLS configuration

    When I GET `apigeeDomain`/banca-digital/empleados/`deploymentSuffix`/<correoElectronico>

    Then response code should be 400
    And response body should be valid json

    And response body path $.codigo should be ^400\.Banca-Digital-empleados\.\d{4}$
    And response body path $.mensaje should be ^.*$
    And response body path $.folio should be ^.*$
    And response body path $.info should be ^https:\/\/baz-developer\.bancoazteca\.com\.mx\/\w{4,6}#400\.Banca-Digital-empleados\.\d{0,}|[A-Z]{0,}\d{0,}$
    And response body path $.detalles[*] should be ^.*$

    Examples:
      | correoElectronico |
      | abcde     |

  Scenario Outline: /empleados/{correoElectronico} 404 not found.

    Given I set bearer token
    And I have valid client TLS configuration

    When I GET `apigeeDomain`/banca-digital/empleados/`deploymentSuffix`/<correoElectronico>

    Then response code should be 404
    And response body should be valid json

    And response body path $.codigo should be ^404\.Banca-Digital-empleados\.\d{4}$
    And response body path $.mensaje should be ^.*$
    And response body path $.folio should be ^.*$
    And response body path $.info should be ^https:\/\/baz-developer\.bancoazteca\.com\.mx\/\w{4,6}#404\.Banca-Digital-empleados\.\d{0,}|[A-Z]{0,}\d{0,}$
    And response body path $.detalles[*] should be ^.*$

    Examples:
      | correoElectronico |
      | 1234      |

  Scenario Outline: /empleados/{correoElectronico} 500 internal server error.

    Given I set bearer token
    And I have valid client TLS configuration

    When I GET `apigeeDomain`/banca-digital/empleados/`deploymentSuffix`/<correoElectronico>

    Then response code should be 500
    And response body should be valid json

    And response body path $.codigo should be ^500\.Banca-Digital-empleados\.\d{4}$
    And response body path $.mensaje should be ^.*$
    And response body path $.folio should be ^.*$
    And response body path $.info should be ^https:\/\/baz-developer\.bancoazteca\.com\.mx\/\w{4,6}#500\.Banca-Digital-empleados\.\d{0,}|[A-Z]{0,}\d{0,}$
    And response body path $.detalles[*] should be ^.*$

    Examples:
      | correoElectronico |
      | null      |
