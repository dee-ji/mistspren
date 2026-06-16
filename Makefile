.PHONY: mistspren-review mistspren-integrity mistspren-dry-run

mistspren-review:
	@if [ -z "$$TRUTHWATCHER_HOME" ]; then echo "Set TRUTHWATCHER_HOME=/path/to/truthwatcher" >&2; exit 2; fi
	./scripts/truthwatcher-review.sh --project truthwatcher

mistspren-integrity:
	./scripts/integrity.sh --project truthwatcher

mistspren-dry-run:
	./scripts/truthwatcher-review.sh --project truthwatcher --dry-run || true
	./scripts/synthesize.sh --project truthwatcher --dry-run
	./scripts/integrity.sh --project truthwatcher --dry-run
