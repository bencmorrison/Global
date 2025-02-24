// Copyright © 2025 Ben Morrison. All rights reserved.

import Global

struct HelperStruct {
    @GlobalRW(\.globalEnum) var globalEnum
}

final class HelperClass {
    @GlobalRW(\.globalEnum) var globalEnum
}
