BASICTOOL=basictool

BUILD=../build

TARGETS=$(BUILD)/scrtes1.bbc

$(shell mkdir -p $(BUILD))

all: $(TARGETS)

$(BUILD)/%.bbc:%.bas
	basictool --basic-2 -t $< $@
	echo '$$.$(shell echo $(notdir $(basename $@)) | tr [:lower:] [:upper:] | cut -c1-7) FFFF8023 FFFF8023' >$@.inf

deploy: all

clean:
	-rm $(TARGETS)
	-rm $(addsuffix .inf, $(TARGETS))
