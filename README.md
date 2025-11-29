# Salesforce DX Project: Folios

Create a complex relationship structure and populate data using snowfakery and cumulusci.

Scratch orgs have a 200mb storage limit for data, so the data generators only create a relatively small amount of records (approx 10,000 Folios and then children and relationship records).

### Schema

```bash
snowfakery datasets/batcher.recipe.yml \
--output-format png --output-file model.png
```

<img src="https://raw.githubusercontent.com/dcinzona/folios/refs/heads/main/model.png" title="model.png" />

Folio\_\_c is the Master record to control visibility to each child (including junctions). If you can't see the folio, you shouldn't be able to see anything associated to it.

In the image above, in order for me to see the Contact(Bianca) on Case(1), I would need to be able to see folios(1,3,4), but not folio(2).

A contact can be associated to multiple folios and multiple cases, and cases can be associated to multiple folios.

Every Contact and Case has a unique parent folio. The junction records could all be associated to the same parent folio as the case or contact, putting everything in a single "folio cabinet".

Sharing are handled at the folio level.

(At least that's how I want this to work...)

- Generate mapping.yml (not really needed for this) <br/>`cci task run generate_dataset_mapping --org dev --path datasets/mapping.yml`

### Testing recipes

Test creating folios and contacts

- `snowfakery datasets/contacts.recipe.yml`

Test creating folios, contacts, and cases:

- `snowfakery datasets/cases.recipe.yml`

Preview a full dataset:

- Single iteration: `snowfakery datasets/batcher.recipe.yml`
- 1000-ish total folios: <br />`snowfakery datasets/cases.recipe.yml --target-number 1000 Folio__c`

### Data Tasks

- Create data: `cci task run create_data`
- Delete and recreate data: `cci flow run reset_data`
- Delete data: `cci task run delete_data`

### Generate a diagram

- `snowfakery datasets/batcher.recipe.yml --output-format png --output-file model.png`
