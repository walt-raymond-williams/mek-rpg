# Playtest Notes

Use this file for campaign-specific workflow bugs, state-save problems, or usability notes.

## Notes

- Issue `#97` live API refresh exposed a viewpoint-selection bug: the first MekHQ personnel record, Michelle "Double-M" Moreno, was KIA but still appeared as the current live viewpoint in generated `current-state.md`. Fixed in `scripts/sync-mekhq-live-campaign.py` by preferring active/available personnel for default viewpoint selection and writing explicit playability guards into generated `current-state.md` and `pcs.md`.
