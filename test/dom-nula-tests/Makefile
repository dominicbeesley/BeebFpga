BUILD=./build

SUBDIRS=scrtes1 scrtes2 paltes1 paltes2 paltes3

DEPLOY=~/hostfs/nulatest

SSD=$(BUILD)/dom-nula-tests.ssd

SSD_OBJS=scrtes1.bbc.inf scrtes2.bbc.inf paltes1.bbc.inf paltes2.bbc.inf paltes3.bbc.inf

.PHONY: clean all deploy $(SUBDIRS) $(SSD)

all: $(SUBDIRS) $(SSD)

deploy: all
	dfs read -i -d $(DEPLOY) $(SSD)

$(SUBDIRS):
	$(MAKE) -C $@ $(MAKECMDGOALS)

$(SSD):
	dfs form -80 $@
	dfs title $@ "DNTEST"
	dfs add $@ $(addprefix $(BUILD)/, $(SSD_OBJS))

clean: $(SUBDIRS)
	rm $(SSD)