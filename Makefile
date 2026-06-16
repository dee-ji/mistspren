.PHONY: mistspren-review mistspren-integrity mistspren-dry-run mistspren-run adr-propose adr-accept adr-reject adr-supersede

mistspren-review:
	@if [ -z "$$TRUTHWATCHER_HOME" ]; then echo "Set TRUTHWATCHER_HOME=/path/to/truthwatcher" >&2; exit 2; fi
	./scripts/truthwatcher-review.sh --project truthwatcher

mistspren-integrity:
	./scripts/integrity.sh --project truthwatcher

mistspren-dry-run:
	@if [ -z "$$TRUTHWATCHER_HOME" ]; then echo "Set TRUTHWATCHER_HOME=/path/to/truthwatcher" >&2; exit 2; fi
	./scripts/truthwatcher-review.sh --project truthwatcher --dry-run
	./scripts/synthesize.sh --project truthwatcher --dry-run
	./scripts/decide.sh --project truthwatcher --dry-run
	./scripts/roadmap.sh --project truthwatcher --dry-run
	./scripts/integrity.sh --project truthwatcher --dry-run

mistspren-run:
	@if [ -z "$$TRUTHWATCHER_HOME" ]; then echo "Set TRUTHWATCHER_HOME=/path/to/truthwatcher" >&2; exit 2; fi
	./scripts/truthwatcher-review.sh --project truthwatcher
	./scripts/synthesize.sh --project truthwatcher
	./scripts/decide.sh --project truthwatcher
	./scripts/roadmap.sh --project truthwatcher
	./scripts/integrity.sh --project truthwatcher
	@printf '\nMistspren run complete.\n'
	@printf 'Read next: .mistspren/review/latest-next-actions.md\n'
	@printf 'Decision queue: .mistspren/review/latest-decision-review.md\n'
	@printf 'Generated logs and reports are local audit output and are ignored by Git.\n'

adr-propose:
	@if [ -z "$(ADR)" ]; then echo "Usage: make adr-propose ADR=ADR-0001" >&2; exit 2; fi
	./scripts/adr-status.sh --project truthwatcher --adr "$(ADR)" --status proposed

adr-accept:
	@if [ -z "$(ADR)" ]; then echo "Usage: make adr-accept ADR=ADR-0001" >&2; exit 2; fi
	./scripts/adr-status.sh --project truthwatcher --adr "$(ADR)" --status accepted

adr-reject:
	@if [ -z "$(ADR)" ]; then echo "Usage: make adr-reject ADR=ADR-0001" >&2; exit 2; fi
	./scripts/adr-status.sh --project truthwatcher --adr "$(ADR)" --status rejected

adr-supersede:
	@if [ -z "$(ADR)" ]; then echo "Usage: make adr-supersede ADR=ADR-0001" >&2; exit 2; fi
	./scripts/adr-status.sh --project truthwatcher --adr "$(ADR)" --status superseded
