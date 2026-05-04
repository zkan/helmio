# AGENTS.md

## Commands

- `bin/dev` - Start development server
- `bin/rails test` - Run tests
- `bin/rubocop` - Lint Ruby
- `bin/ci` - Full CI pipeline (rubocop, bundler-audit, brakeman, test, seed)

## Architecture

- Rails 8.1.3 with SQLite
- Avo admin panel mounted at `/avo`
- Root route: `dashboard#index`

## Database

- Models: `Site`, `Crew`, `RateCard`, `RateCardItem`, `CrewSite`, `CrewRateCardItem`
- Migrations in `db/migrate/`
- Run `bin/rails db:migrate` after adding migrations

## Testing

- Use fixtures from `test/fixtures/*.yml`
- Run single test: `bin/rails test test/controllers/dashboard_controller_test.rb`