# MegaMek / MekHQ Local API Reliability Handoff - 2026-06-26

Status: handoff-ready bug report from MEK-RPG live play.

Audience: MegaMek / MekHQ workspace team maintaining the local read-only and guarded-command API at `http://127.0.0.1:32180`.

Source workspace: `C:\Users\waltr\Documents\mek-rpg`

Active play context: MEK-RPG campaign `campaigns/the-learning-ropes/`, linked to MekHQ campaign `The Learning Ropes`.

## Summary

During live MEK-RPG play on 2026-06-26, the MekHQ local API was unreliable enough that play had to pause. The API sometimes returned `GET /campaign/summary`, but later timed out on the same endpoint. Full and narrowed `GET /campaign/state` reads repeatedly timed out, and `GET /campaign/commands` also timed out.

This blocked the GM from confirming current pending operations, force assignments, and whether Michelle "Double-M" Moreno was already committed to one of the pending operations. The player confirmed the current pending operations are a tank-base defense and an insurgency, and noted that `/campaign/summary` should reveal Double-M's existing commitment when the API responds.

## Observed Failures

### 1. Summary Endpoint Timed Out Intermittently

- Endpoint: `GET /campaign/summary`
- Earlier result: succeeded once and returned campaign identity, date, location, read-only proof, and summary metadata.
- Later result: timed out with both 15-second and 60-second client timeouts.
- Impact: the GM could not verify Double-M's current deployment commitment from the lightweight endpoint.
- Expected behavior: `/campaign/summary` should remain fast and bounded even when deeper campaign state is expensive.

### 2. State Endpoint Timed Out For Full And Narrow Reads

- Endpoint: `GET /campaign/state`
- Attempted sections:
  - full live state with `bridge_metadata,campaign,finances,personnel,units,contracts,scenarios,repairs_and_logistics,markets,reports,unsupported`
  - narrowed `bridge_metadata,campaign,contracts,scenarios,reports`
  - narrowed `bridge_metadata,units,repairs_and_logistics`
  - narrowed `bridge_metadata,personnel`
  - narrowed `bridge_metadata,campaign,scenarios,units,personnel,reports`
- Result: timed out repeatedly, including 45-second and 60-second attempts.
- Impact: the GM could not confirm scenario details, unit assignments, repair state, personnel state, or reports.
- Expected behavior: section filtering should avoid traversing slow full-state structures, or the API should provide smaller purpose-built endpoints.

### 3. Command Readiness Endpoint Timed Out

- Endpoint: `GET /campaign/commands`
- Result: timed out with 10-second and 20-second client timeouts.
- Impact: MEK-RPG could not discover safe command readiness or supported selectors.
- Expected behavior: read-only command readiness should be fast, bounded, and safe to call during play.

### 4. Current Deployment Commitment Was Not Reliably Available

- Needed data: which pending operation Michelle "Double-M" Moreno is already committed to.
- Player expectation: `/campaign/summary` should expose this when it responds.
- Actual result: the endpoint timed out during the verification pass, and the larger state endpoint also timed out.
- Impact: the GM initially framed the wrong pending operations from stale notes, then could not verify the corrected assignment from the API.
- Expected behavior: a lightweight summary or deployment endpoint should expose pending scenario names, ids, dates, and personnel/unit commitments for the selected or viewpoint character.

### 5. Stale Local Notes Became A Risky Fallback

- MEK-RPG local campaign notes still contained older pending operation labels from prior play.
- The API timeout prevented live correction at the moment of scene framing.
- Player corrected the scene: current pending operations are tank-base defense and insurgency, not the stale labels.
- Impact: API unavailability directly increased stale-memory risk in live play.
- Expected behavior: the API should be reliable enough that live MekHQ-owned facts do not need to be guessed from imported notes.

## Existing API Gaps Still Relevant

These were already recorded before this reliability pause and remain useful producer-side follow-up items:

- Dirty or unsaved campaign state is not source-confirmed by the V1 endpoint.
- Stable repair/acquisition work ids are not exposed.
- Repair execution, repair assignment, shopping-list purchase, and shopping-list priority commands are not exposed.
- Market offer selector availability is unclear in stale bridge notes and should come from current command readiness.

## Reproduction Commands Used From MEK-RPG

```powershell
Invoke-RestMethod -Method Get -Uri 'http://127.0.0.1:32180/campaign/summary' -TimeoutSec 15
Invoke-RestMethod -Method Get -Uri 'http://127.0.0.1:32180/campaign/summary' -TimeoutSec 60
Invoke-RestMethod -Method Get -Uri 'http://127.0.0.1:32180/campaign/commands' -TimeoutSec 20
Invoke-RestMethod -Method Get -Uri 'http://127.0.0.1:32180/campaign/state?sections=bridge_metadata,campaign,contracts,scenarios,reports' -TimeoutSec 45
Invoke-RestMethod -Method Get -Uri 'http://127.0.0.1:32180/campaign/state?sections=bridge_metadata,units,repairs_and_logistics' -TimeoutSec 45
Invoke-RestMethod -Method Get -Uri 'http://127.0.0.1:32180/campaign/state?sections=bridge_metadata,personnel' -TimeoutSec 45
Invoke-RestMethod -Method Get -Uri 'http://127.0.0.1:32180/campaign/state?sections=bridge_metadata,campaign,scenarios,units,personnel,reports' -TimeoutSec 60
```

## Suggested Fix Shape

1. Keep `GET /campaign/summary` bounded and consistently fast.
2. Add or optimize purpose-built lightweight endpoints for:
   - pending scenarios
   - selected/viewpoint person deployment commitment
   - unit/personnel assignment summary
   - repair pressure summary
   - current reports
   - command readiness
3. Make `sections=` filtering lazy or bounded so asking for `scenarios` does not force expensive unrelated reads.
4. Add response timing instrumentation or server logs around slow collectors so the MegaMek team can identify which collector stalls.
5. Return partial data with warnings when optional collectors are slow, instead of timing out the entire request.

## MEK-RPG Impact

MEK-RPG play is paused until the API can reliably answer at least:

- loaded campaign identity and date
- current pending operation names, ids, and dates
- Double-M's current unit/personnel commitment
- basic unit and repair pressure
- command readiness or an explicit "not available" response

Without those reads, the GM risks using stale local notes for MekHQ-owned facts.

## Related Local Tracking

- `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`
- `campaigns/the-learning-ropes/mekhq-api-gaps.md`
- Epic issue: `#113`
- Current task: issue `#117`
