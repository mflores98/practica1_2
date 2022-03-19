Feature: /empleados PUT

    Crear solicitud de crédito
 
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
        
        When I PUT to `apigeeDomain`/`apigeeOauthEndpoint`

        Then response code should be 200
        And response body should be valid json
        And I store the value of body path $.access_token as access token

    Scenario: /empleados 201 created.

        Given I set Content-Type header to application/json
        And I set bearer token
        And I have valid client TLS configuration
        And I set body to {"producto": "BANCA DIGITAL","Empleado": {"nombre": "Germain Castelan","correoElectronico": "miCorreo@info.com","numeroTelefono": "5540302010","domicilio": {"calle": "Cafetales","numero": "SN","codigoPostal": "04918","ciudad": "Ciudad de México"}}}
        When I PUT to `apigeeDomain`/banca-digital/empleados/`deploymentSuffix`
    
        Then response code should be 201
        And response body should be valid json
        And response body path $.mensaje should be ^.*$
        And response body path $.folio should be ^.*$
        And response body path $.resultado.idSolicitud should be ^.*$

    Scenario: /empleados 400 bad request.

        Given I set Content-Type header to application/json
        And I set bearer token
        And I have valid client TLS configuration
        And I set body to {"producto": "BANCA DIGITAL","Empleado": {"nombre": null,"correoElectronico": "miCorreo@info.com","numeroTelefono": "5544332211","domicilio": {"calle": "Cafetales","numero": "SN","codigoPostal": "04918","ciudad": "Ciudad de México"}}}
        When I PUT to `apigeeDomain`/banca-digital/empleados/`deploymentSuffix`

        Then response code should be 400
        And response body should be valid json
        And response body path $.codigo should be ^400\.Banca-Digital-empleados\.\d{4}$
        And response body path $.mensaje should be ^.*$
        And response body path $.folio should be ^.*$
        And response body path $.info should be ^https:\/\/baz-developer\.bancoazteca\.com\.mx\/\w{4,6}#400\.Banca-Digital-empleados\.\d{0,}|[A-Z]{0,}\d{0,}$
        And response body path $.detalles[*] should be ^.*$

    Scenario: /empleados 500 internal server error.

        Given I set Content-Type header to application/json
        And I set bearer token
        And I have valid client TLS configuration
        And I set body to {"producto": null,"Empleado": {"nombre": null,"correoElectronico": null,"numeroTelefono": "5544332211","domicilio": {"calle": "Cafetales","numero": "SN","codigoPostal": "04918","ciudad": "Ciudad de México"}}}
        When I PUT to `apigeeDomain`/banca-digital/empleados/`deploymentSuffix`

        Then response code should be 500
        And response body should be valid json
        And response body path $.codigo should be ^500\.Banca-Digital-empleados\.\d{4}$
        And response body path $.mensaje should be ^.*$
        And response body path $.folio should be ^.*$
        And response body path $.info should be ^https:\/\/baz-developer\.bancoazteca\.com\.mx\/\w{4,6}#500\.Banca-Digital-empleados\.\d{0,}|[A-Z]{0,}\d{0,}$
        And response body path $.detalles[*] should be ^.*$
