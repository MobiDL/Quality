## Testing

### Requirements

- [Pytest-workflow](https://github.com/LUMC/pytest-workflow)
- Cromwell (to run workflows)

<br>

### Run tests

```bash
pytest \
	--keep-workflow-wd \
	--verbose \
	--git-aware \
	--basetemp=/path/to/anotherDir/ \
	tests/
```

WARN: For test to work, replace in `tests/jsons/smalltest_inputs.json`:

* '/path/to/anotherDir/' by '--basetemp' you provied above
* `REPLACE` by "/path/to/tests_dataset" cloned repo


Due to `--keep-workflow-wd` option, dirs `Name_of_my_test` present at `--basetemp` path (created by `pytest-workflow`) must be be deleted *manually* afterwards
