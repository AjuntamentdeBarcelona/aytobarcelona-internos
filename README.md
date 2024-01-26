# aytobarcelona-internos

[![[CI] Lint](https://github.com/AjuntamentdeBarcelona/aytobarcelona-internos/actions/workflows/lint.yml/badge.svg)](https://github.com/AjuntamentdeBarcelona/aytobarcelona-internos/actions/workflows/lint.yml)
[![[CI] Test](https://github.com/AjuntamentdeBarcelona/aytobarcelona-internos/actions/workflows/test.yml/badge.svg)](https://github.com/AjuntamentdeBarcelona/aytobarcelona-internos/actions/workflows/test.yml)

Free Open-Source participatory democracy, citizen participation and open government for cities and organizations

This is the open-source repository for aytobarcelona-internos, based on [Decidim](https://github.com/decidim/decidim).

## Setting up the application

You will need to do some steps before having the app working properly once you've deployed it:

1. Open a Rails console in the server: `bundle exec rails console`
2. Create a System Admin user:

```ruby
user = Decidim::System::Admin.new(email: <email>, password: <password>, password_confirmation: <password>)
user.save!
```

3. Visit `<your app url>/system` and login with your system admin credentials
4. Create a new organization. Check the locales you want to use for that organization, and select a default locale.
5. Set the correct default host for the organization, otherwise the app will not work properly. Note that you need to include any subdomain you might be using.
6. Fill the rest of the form and submit it.

You're good to go!

## TODO

Until Decidim v0.22 is released an initializer to configure the SAML integration is kept in `config/initializers/omniauth.rb`.
When upgrading to v0.22 which includes the fix https://github.com/decidim/decidim/pull/6042 the initializer should be removed and the configuration in `config/secrets.yml` should be reviewed.

## SAML integration

The [ruby-saml](https://github.com/onelogin/ruby-saml) gem allows to integrate a SAML single sign on strategy.
It uses the IDP endpoint url and it generates a local route to the metadata endpoint.
This integration does not replace the previous oauth one. The oauth authentication can still be used, but is disabled in favor of SAML.
You can still use the previous oauth authentication strategy just enabling it in the settings, and disabling the SAML one.

- The IDP endpoint url is provided by the SAML provider and set in the config files
- The local metadata url is: `/users/auth/saml/metadata`

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
                    idp_cert: ENV["SAML_IDP_CERT"],
                    idp_sso_target_url: ENV["SAML_IDP_SSO_TARGET_URL"],
                    sp_entity_id: ENV["SAML_SP_ENTITY_ID"],
                    strategy_class: ::OmniAuth::Strategies::SAML,
                    attribute_statements: {
                      email: ['mail'],
                      name: ['givenName', 'nom']
                    },
                    certificate: ENV["SAML_CERTIFICATE"],
                    private_key: ENV["SAML_PRIVATE_KEY"],
                    security: {
                      authn_requests_signed: true,
                      signature_method: XMLSecurity::Document::RSA_SHA256
                    }
  end
```

- `idp_cert`: is the certificate provided by the IDP provider
- `idp_sso_target_url`: is the url provided by the IDP
- `sp_entity_id`: is just a identifier to set in the saml response:

  ```html
    <md:EntityDescriptor xmlns:md="..." xmlns:saml="..." ID="..." entityID="https://decidim.ajuntament.bcn/">
  ```

- `attribute_statements`: Custom attribute mappings
- `certificate`: Certificate used to sign request to the SAML server
- `private_key`: Used to sign request to the SAML server

This configuration is set in the `config/settings.yml` file:

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

## Load IMIPRE users

To load the users from IMIPRE from a CSV you need to:

1. Include the CSV file in the tmp folder with the name `employees.csv`
2. Execute `bundle exec rake employees:load`

When authenticating with OAUTH it checks that the user is active and has the type T1.

Example of CSV file:

```csv
Matricula;Cognoms;Nom;mail;Estat;Tipus d'Empleat
DXXXXXX;Sanchez Inclan ;Manuel;msinclan@bcn.cat;ACTIVE;T1
```

## Remove survey answer from a user

Get the user:

```ruby
u = Decidim::User.where(email: Employee.where(code: 'B611460').first.email).first
```

Get the name of the surveys:

```ruby
Decidim::Surveys::Survey.all.map(&:component)
```

Get the id of the component that corresponds to the survey and get the survey:

```ruby
s = Decidim::Surveys::Survey.where(decidim_component_id: 5).last
```

Get the questionnaire of the survey:

```ruby
q = Decidim::Forms::Questionnaire.includes(:questionnaire_for).where(questionnaire_for: s)
```

Get the answers of the user:

```ruby
a = Decidim::Forms::Answer.joins(:questionnaire).where(questionnaire: q).where(decidim_user_id: u.id)
```

Remove the answers:

```ruby
a.destroy_all
```
