.PHONY: mistspren-review mistspren-integrity mistspren-dry-run

mistspren-review:
	@if [ -z "$$TRUTHWATCHER_REPO_PATH" ]; then echo "Set TRUTHWATCHER_REPO_PATH=/path/to/truthwatcher" >&2; exit 2; fi
	./scripts/truthwatcher-review.sh --project truthwatcher --truthwatcher-path "$$TRUTHWATCHER_REPO_PATH"

mistspren-integrity:
	./scripts/integrity.sh --project truthwatcher

mistspren-dry-run:
	./scripts/truthwatcher-review.sh --project truthwatcher --truthwatcher-path "$${TRUTHWATCHER_REPO_PATH:-.}" --dry-run || true
	./scripts/synthesize.sh --project truthwatcher --dry-run
	./scripts/integrity.sh --project truthwatcher --dry-run
