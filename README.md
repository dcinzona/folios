# Salesforce DX Project: Folios

Create a complex relationship structure and populate data using snowfakery and cumulusci

### Schema

- `cci task run generate_dataset_mapping --org dev --path datasets/mapping.yml`

### Testing recipes

Test creating folios and contacts

- `snowfakery datasets/contacts.recipe.yml`

Test creating folios, contacts, and cases:

- `snowfakery datasets/cases.recipe.yml`

Another way to create a full dataset:

- `snowfakery datasets/batcher.recipe.yml`

### Data Tasks

- Reset data: `cci flow run reset_data`
- Create data: `cci task run create_data`
- Delete data: `cci task run delete_data`

### Generate a diagram

- `snowfakery datasets/batcher.recipe.yml --output-format png --output-file model.png`
