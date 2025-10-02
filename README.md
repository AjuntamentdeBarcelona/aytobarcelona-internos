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

## OAuth integration

The [omniauth-keycloak](https://github.com/ccrockett/omniauth-keycloak) gem allows to integrate a Keycloak OpenID single sign on strategy.

### Constraints (validations)

When the external system authenticates the user it invokes the `Devise::OmniauthCallbacksController#keycloakopenid` callback. This callback is overridden to have a `before_action :verify_user_type, only: :keycloakopenid`.

This verification checks that the user belongs to a `valid_cn?` (for admins) **or** belongs to a `valid_type?` (currently `['T1', 'T2', 'T3', 'T11']`).

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
