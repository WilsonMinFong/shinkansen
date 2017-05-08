# Shinkansen

Shinkansen is a Ruby MVC web framework inspired by Ruby on
Rails.  The framework's key components include:

- `Router`: basic routing to Shinkansen controllers
- `ControllerBase`: controller actions, including view rendering
- `ModelBase`: basic Object-Relational Mapping (ORM) functionality

## Router

Add routes for the following CRUD actions: `GET`, `POST`, `PUT`,
and `DELETE`.

## Model

Add Shinkansen model functionality by inheriting from the `ModelBase`
class.

### Functionality

- Find, insert, update, and delete rows in the database.
- Filter database entries by column values.
- Connect models with `belongs_to`, `has_many`, or `has_many_through`
  associations.

## Controller

Add Shinkansen controller functionality by inheriting from the
`ControllerBase` class.

### Functionality

- Redirect to another URL
- Render an ERB view (located in
  `views/controller_name/template_name.html.erb`)
- Add session and flash cookies
- Add middleware to render an exceptions template upon server error

## Future Features

- [ ] Static assets middleware
- [ ] CSRF Protection
- [ ] DB connection for PostgreSQL
- [ ] Gemify the library
- [ ] Database migrations
