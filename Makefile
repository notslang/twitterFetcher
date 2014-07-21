
build: components index.coffee
	component build --use component-coffee --dev

components: component.json
	@component install --dev

clean:
	rm -fr build components template.js

.PHONY: clean
