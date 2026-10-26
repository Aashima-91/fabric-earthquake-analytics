# Data Factory pipeline

Pipeline name: `Earthquake_Data_Pipeline`. Three notebook activities chained with **On success** links, so Gold never runs before Silver is ready.

```
Bronze Notebook ──success──▶ Silver Notebook ──success──▶ Gold Notebook ──▶ Power BI report
```

| Activity | Notebook | Parameters |
|---|---|---|
| Bronze Notebook | `01_Bronze_Earthquake` | `start_date`, `end_date` |
| Silver Notebook | `02_Silver_Earthquake` | `start_date`, `end_date` |
| Gold Notebook | `03_Gold_Earthquake` | `start_date` |

![Successful pipeline run](images/pipeline-run.png)

## Dynamic date parameters (UTC)

```
start_date  @formatDateTime(addDays(utcNow(), -1), 'yyyy-MM-dd')
end_date    @formatDateTime(utcNow(), 'yyyy-MM-dd')
```

Each run processes the previous UTC day. Example: on 18 Sep 2026 UTC, `start_date` = 2026-09-17 and `end_date` = 2026-09-18.

## Schedule

Daily recurring trigger, set to a time **after midnight UTC** so the date window has rolled over.

## Running a single notebook

Temporarily set the other activities to **Deactivated** with *Mark activity as: Succeeded*, leave the one you want **Activated**, then run.

## Monitoring

Use the Fabric **Monitoring hub** and the pipeline run history to check each activity's status, duration and errors.

## Troubleshooting

| Symptom | Fix |
|---|---|
| `ModuleNotFoundError: reverse_geocoder` | Add it to the published `Earthquake_Env` and set that environment on the Gold notebook |
| HTTP 430 capacity error | Too many Spark sessions: cancel unused ones in the Monitoring hub |
| File not visible in Files | Confirm Bronze completed, Lakehouse is the default, then refresh |
| Gold table not found | Run `SHOW TABLES`, rerun the Gold write cell |
| Wrong Lakehouse context | Attach and pin `Earthquakes_Lakehouse` as default, restart the session |
