# Salesforce DX Project: Folios

Create a complex relationship structure and populate data using snowfakery and cumulusci

### Testing recipes

- `snowfakery datasets/contacts.recipe.yml`
- `snowfakery datasets/cases.recipe.yml`
- `snowfakery datasets/batcher.recipe.yml`

### Data Tasks

- Reset data: `cci flow run reset_data`
- Create data: `cci task run create_data`
- Delete data: `cci task run delete_data`
