# internos

Free Open-Source participatory democracy, citizen participation and open government for cities and organizations

This is the open-source repository for borrame, based on [Decidim](https://github.com/decidim/decidim).

## Setting up the application

You will need to do some steps before having the app working properly once you've deployed it:

1. Open a Rails console in the server: `bundle exec rails console`
1. Create a System Admin user:

  ```ruby
  user = Decidim::System::Admin.new(email: <email>, password: <password>, password_confirmation: <password>)
  user.save!
  ```

1. Visit `<your app url>/system` and login with your system admin credentials
1. Create a new organization. Check the locales you want to use for that organization, and select a default locale.
1. Set the correct default host for the organization, otherwise the app will not work properly. Note that you need to include any subdomain you might be using.
1. Fill the rest of the form and submit it.

You're good to go!

## TODO

Until Decidim v0.22 is released an initializer to configure the SAML integration is kept in `config/initializers/omniauth.rb`.
When upgrading to v0.22 which includes the fix https://github.com/decidim/decidim/pull/6042 the initializer should be removed and the configuration in `config/secrets.yml` should be reviewed.

## Configuration

There are some tasks to secure secret keys via `chamber` gem for the different environments in `lib/tasks/chamber.rake`, specially `chamber:secure_all` should be taken into account.

Also be aware of the Capistrano related `lib/capistrano/tasks/stage_files.rake` task which overrides secrets when deploying.

So to change a key value for a given environment the steps to follow are:

- change the key in the path for the corresponding environment or environments: `script/deploy/#{environment}/config/settings/*.yml`
- execute `bundle exec rake chamber:secure_all`
- commit the cyphered keys
- proceed with the usual deploy

## SAML integration

The [ruby-saml](https://github.com/onelogin/ruby-saml) gem allows to integrate a SAML single sign on strategy.
It uses the IDP endpoint url and it generates a local route to the metadata endpoint.
This integration does not replace the previous oauth one. The oauth authentication can still be used, but is disabled in favor of SAML.
You can still use the previous oauth authentication strategy just enabling it in the settings, and disabling the SAML one.

- the IDP endpoint url is provided by the SAML provider and set in the config files
- the local metadata url is: /users/auth/saml/metadata

Mapped attributes:

- The saml response contains the different user attributes, and they are mapped automatically with the [omniauth-saml](https://github.com/omniauth/omniauth-saml) gem.
- Custom attributes are mapped in the config/initializers/omniauth.rb file:

```ruby
                    attribute_statements: {
                      email: ['mail'],
                      name: ['givenName', 'nom']
                    },
```

SAML configuration:

The SAML integration is fully defined in the config/initializers/omniauth.rb file:

```ruby
  Devise.setup do |config|
    config.omniauth :saml,
                    idp_cert: Chamber.env.saml.idp_cert,
                    idp_sso_target_url: Chamber.env.saml.idp_sso_target_url,
                    sp_entity_id: Chamber.env.saml.sp_entity_id,
                    strategy_class: ::OmniAuth::Strategies::SAML,
                    attribute_statements: {
                      email: ['mail'],
                      name: ['givenName', 'nom']
                    },
                    certificate: Chamber.env.saml.certificate,
                    private_key: Chamber.env.saml.private_key,
                    security: {
                      authn_requests_signed: true,
                      signature_method: XMLSecurity::Document::RSA_SHA256
                    }
  end
```

- idp_cert: is the certificate provided by the IDP provider
- idp_sso_target_url: is the url provided by the IDP
- sp_entity_id: is just a identifier to set in the saml response:

  ```html
    <md:EntityDescriptor xmlns:md="..." xmlns:saml="..." ID="..." entityID="https://decidim.ajuntament.bcn/">
  ```

- attribute_statements: Custom attribute mappings
- certificate: Certificate used to sign request to the SAML server
- private_key: Used to sign request to the SAML server

This configuration is set in the config/settings.yml file:

```ruby
  saml:
    idp_sso_target_url: <%= ENV['IDP_SSO_TARGET_URL'] %>
    idp_cert: <%= ENV['IDP_CERT'] %>
    certificate: <%= ENV['CERTIFICATE'] %>
    private_key: <%= ENV['PRIVATE_KEY'] %>
    sp_entity_id: <%= ENV['SP_ENTITY_ID'] %>
    user_types: ['T1', 'T2', 'T3', 'T11']
    cn: 'ACCES'
```

### SAML constraints (validations)

When the external SAML system authenticates the user it invokes the `Devise::OmniauthCallbacksController#saml` callback. This callback is overriden to have a `before_action :verify_user_type, only: :saml`.

This verification checks that the user belongs to a `valid_cn?` (for admins) **or** belongs to a `valid_type?` (currently `['T1', 'T2', 'T3', 'T11']`).

## Carga de usuarios de IMIPRE

Para cargar la csv hay que:

1. meterla dentro de la carpeta tmp con el nombre employees.csv
1. ejecutar bundle exec rake employees:load

Al autenticar con OAUTH comprueba que los campos del csv tengan el estado activo y el tipo T1

Ejemplo de csv:

```
Matricula;Cognoms;Nom;mail;Estat;Tipus d'Empleat
DXXXXXX;Sanchez Inclan ;Manuel;msinclan@bcn.cat;ACTIVE;T1
```

## Borrado de respuesta a una encuesta de un usuario

Para obtener el usuario:

```ruby
u = Decidim::User.where(email: Employee.where(code: 'B611460').first.email).first
```

Para poder ver el nombre de las encuestas que hay:

```ruby
Decidim::Surveys::Survey.all.map(&:component)
```

te quedas con el id del component que se corresponda con la encuesta y obtienes la encuesta

```ruby
s = Decidim::Surveys::Survey.where(decidim_component_id: 5).last
```

Obtienes el cuestionario de la encuesta:

```ruby
q = Decidim::Forms::Questionnaire.includes(:questionnaire_for).where(questionnaire_for: s)
```

Y obtienes las respuestas al cuestionario del usuario

```ruby
a = Decidim::Forms::Answer.joins(:questionnaire).where(questionnaire: q).where(decidim_user_id: u.id)
```

finalmente se borran las respuestas:

```ruby
a.destroy_all
```