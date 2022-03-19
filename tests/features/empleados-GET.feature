Feature: /empleados GET

    Consultar los empleados registrados en Banca Digital.
 
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

    Scenario: /empleados 200 ok.
    
        Given I set bearer token
        And I have valid client TLS configuration
      
        When I GET `apigeeDomain`/banca-digital/empleados/`deploymentSuffix`
    
        Then response code should be 200
        And response body should be valid json

        And response body path $.mensaje should be ^.*$
        And response body path $.folio should be ^.*$
        And response body path $.resultado.empleados[*].id should be ^.*$
        And response body path $.resultado.empleados[*].nombre should be ^.*$
        And response body path $.resultado.empleados[*].correoElectronico should be ^.*$
        And response body path $.resultado.empleados[*].numeroTelefono should be ^.*$
        And response body path $.resultado.empleados[*].domicilio.calle should be ^.*$
        And response body path $.resultado.empleados[*].domicilio.numero should be ^.*$
        And response body path $.resultado.empleados[*].domicilio.codigoPostal should be ^.*$
        And response body path $.resultado.empleados[*].domicilio.ciudad should be ^.*$
    
#    Scenario: /empleados 400 bad request.
#
#        Given I set bearer token
#        And I have valid client TLS configuration
#      
#        When I GET `apigeeDomain`/banca-digital/empleados/`deploymentSuffix`
#
#        Then response code should be 400
#        And response body should be valid json
#
#        And response body path $.codigo should be ^400\.Banca-Digital-empleados\.\d{4}$
#        And response body path $.mensaje should be ^.*$
#        And response body path $.folio should be ^.*$
#        And response body path $.info should be ^https:\/\/baz-developer\.bancoazteca\.com\.mx\/\w{4,6}#400\.Banca-Digital-empleados\.\d{0,}|[A-Z]{0,}\d{0,}$
#        And response body path $.detalles[*] should be ^.*$
#
#    Scenario: /empleados 404 not found.
#
#        Given I set bearer token
#        And I have valid client TLS configuration
#      
#        When I GET `apigeeDomain`/banca-digital/empleados/`deploymentSuffix`
#
#        Then response code should be 404
#        And response body should be valid json
#
#        And response body path $.codigo should be ^404\.Banca-Digital-empleados\.\d{4}$
#        And response body path $.mensaje should be ^.*$
#        And response body path $.folio should be ^.*$
#        And response body path $.info should be ^https:\/\/baz-developer\.bancoazteca\.com\.mx\/\w{4,6}#404\.Banca-Digital-empleados\.\d{0,}|[A-Z]{0,}\d{0,}$
#        And response body path $.detalles[*] should be ^.*$
#
#    Scenario: /empleados 500 internal server error.
#
#        Given I set bearer token
#        And I have valid client TLS configuration
#      
#        When I GET `apigeeDomain`/banca-digital/empleados/`deploymentSuffix`
#
#        Then response code should be 500
#        And response body should be valid json
#
#        And response body path $.codigo should be ^500\.Banca-Digital-empleados\.\d{4}$
#        And response body path $.mensaje should be ^.*$
#        And response body path $.folio should be ^.*$
#        And response body path $.info should be ^https:\/\/baz-developer\.bancoazteca\.com\.mx\/\w{4,6}#500\.Banca-Digital-empleados\.\d{0,}|[A-Z]{0,}\d{0,}$
#        And response body path $.detalles[*] should be ^.*$
