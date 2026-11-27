#include <assert.h>
#include <stdio.h>
#include <string.h>
#include "yads/yads.h"

int main(void) {
    assert(yads_version() != NULL);
    assert(strlen(yads_version()) > 0);
    printf("test_smoke: OK\n");
    return 0;
}