suppressPackageStartupMessages({
  library(dplyr)
  library(tibble)
})

# Preserve 2021-2025 training sources; export completed 2026 data separately.
# Output:
#   1) weekly/raw tables by position
#   2) avg tables by position
#   3) hybrid tables by position with avg columns prefixed as avg_

model_source_seasons <- 2021:2025
current_source_season <- 2026L
current_source_through_week <- 1L
auto_source_season_scripts <- FALSE
reuse_historical_sources <- getOption("model_combine_reuse_history", TRUE)
combine_output_dir <- getOption("model_combine_history_dir",
                                "C:/Users/danma/OneDrive/Documents/NFLfastR/outputs/model_sources_2021_2025")

season_script_candidates <- list(
  `2021` = c("Weekly 2021 data"),
  `2022` = c("Weekly 2022 Data"),
  `2023` = c(
    file.path("repo_latest_main", "fantasypredictions-main", "Weekly 2023 data"),
    file.path("fantasypredictions-main", "Weekly 2023 data"),
    "Weekly 2023 data"
  ),
  `2024` = c(
    file.path("repo_latest_main", "fantasypredictions-main", "Weekly 2024 data"),
    file.path("fantasypredictions-main", "Weekly 2024 data"),
    "Weekly 2024 data"
  ),
  `2025` = c("Weekly 2025 Data")
)

position_configs <- list(
  QB = list(
    weekly = c(
      `2021` = "qb_sch_21",
      `2022` = "qb_sch_22",
      `2023` = "qb_sch_23",
      `2024` = "qb_sch_24",
      `2025` = "qb_sch_25"
    ),
    avg = c(
      `2021` = "qb_sch_21_avg",
      `2022` = "qb_sch_22_avg",
      `2023` = "qb_sch_23_avg",
      `2024` = "qb_sch_24_avg",
      `2025` = "qb_sch_25_avg"
    ),
    join_keys = c("Player", "TM", "POS", "SEA", "WK", "G")
  ),
  RB = list(
    weekly = c(
      `2021` = "rb_sch_21",
      `2022` = "rb_sch_22",
      `2023` = "rb_sch_23",
      `2024` = "rb_sch_24",
      `2025` = "rb_sch_25"
    ),
    avg = c(
      `2021` = "rb_sch_21_avg",
      `2022` = "rb_sch_22_avg",
      `2023` = "rb_sch_23_avg",
      `2024` = "rb_sch_24_avg",
      `2025` = "rb_sch_25_avg"
    ),
    join_keys = c("Player", "TM", "POS", "SEA", "WK", "G")
  ),
  WR = list(
    weekly = c(
      `2021` = "wr_sch_21",
      `2022` = "wr_sch_22",
      `2023` = "wr_sch_23",
      `2024` = "wr_sch_24",
      `2025` = "wr_sch_25"
    ),
    avg = c(
      `2021` = "wr_sch_21_avg",
      `2022` = "wr_sch_22_avg",
      `2023` = "wr_sch_23_avg",
      `2024` = "wr_sch_24_avg",
      `2025` = "wr_sch_25_avg"
    ),
    join_keys = c("Player", "TM", "POS", "SEA", "WK", "G")
  ),
  TE = list(
    weekly = c(
      `2021` = "TE_sch_21",
      `2022` = "TE_sch_22",
      `2023` = "TE_sch_23",
      `2024` = "TE_sch_24",
      `2025` = "TE_sch_25"
    ),
    avg = c(
      `2021` = "te_sch_21_avg",
      `2022` = "te_sch_22_avg",
      `2023` = "te_sch_23_avg",
      `2024` = "te_sch_24_avg",
      `2025` = "te_sch_25_avg"
    ),
    join_keys = c("Player", "TM", "POS", "SEA", "WK", "G")
  ),
  K = list(
    weekly = c(
      `2021` = "K_sch_21",
      `2022` = "K_sch_22",
      `2023` = "K_sch_23",
      `2024` = "K_sch_24",
      `2025` = "K_sch_25"
    ),
    avg = c(
      `2021` = "k_sch_21_avg",
      `2022` = "k_sch_22_avg",
      `2023` = "k_sch_23_avg",
      `2024` = "k_sch_24_avg",
      `2025` = "k_sch_25_avg"
    ),
    join_keys = c("Player", "TM", "POS", "SEA", "WK", "G")
  ),
  DST = list(
    weekly = c(
      `2021` = "dst_sch_21",
      `2022` = "dst_sch_22",
      `2023` = "dst_sch_23",
      `2024` = "dst_sch_24",
      `2025` = "dst_sch_25"
    ),
    avg = c(
      `2021` = "dst_sch_21_avg",
      `2022` = "dst_sch_22_avg",
      `2023` = "dst_sch_23_avg",
      `2024` = "dst_sch_24_avg",
      `2025` = "dst_sch_25_avg"
    ),
    join_keys = c("Name", "TM", "POS", "SEA", "WK", "G")
  )
)

# Names match the completed-data outputs of Weekly 2026 data.R.
current_weekly_objects <- c(QB = "qb_sch_26", RB = "rb_sch_26",
                            WR = "wr_sch_26", TE = "TE_sch_26", K = "K_sch_26", DST = "dst_sch_26")
current_avg_objects <- c(QB = "qb_sch_26_avg", RB = "rb_sch_26_avg",
                         WR = "wr_sch_26_avg", TE = "te_sch_26_avg", K = "k_sch_26_avg", DST = "dst_sch_26_avg")
for (position_name in names(position_configs)) {
  position_configs[[position_name]]$weekly[["2026"]] <- current_weekly_objects[[position_name]]
  position_configs[[position_name]]$avg[["2026"]] <- current_avg_objects[[position_name]]
}

resolve_season_script_path <- function(season_year) {
  candidate_paths <- season_script_candidates[[as.character(season_year)]]
  existing_paths <- candidate_paths[file.exists(candidate_paths)]
  if (length(existing_paths) == 0) {
    stop(
      paste0(
        "Could not find the season script for ",
        season_year,
        ". Checked: ",
        paste(candidate_paths, collapse = ", ")
      ),
      call. = FALSE
    )
  }
  existing_paths[[1]]
}

source_weekly_script_safely <- function(script_path, env = .GlobalEnv) {
  script_lines <- readLines(script_path, warn = FALSE, encoding = "UTF-8")
  keep_line <- !grepl("^\\s*install\\.packages\\(", script_lines)
  cleaned_lines <- script_lines[keep_line]
  temp_script <- tempfile(fileext = ".R")
  writeLines(cleaned_lines, temp_script, useBytes = TRUE)
  sys.source(temp_script, envir = env)
}

required_objects_for_season <- function(season_year) {
  unname(unlist(
    lapply(
      position_configs,
      function(cfg) c(cfg$weekly[[as.character(season_year)]], cfg$avg[[as.character(season_year)]])
    ),
    use.names = FALSE
  ))
}

ensure_season_objects <- function(season_year, env = .GlobalEnv, auto_source = TRUE) {
  needed_objects <- required_objects_for_season(season_year)
  missing_objects <- needed_objects[!vapply(needed_objects, exists, logical(1), envir = env, inherits = FALSE)]
  
  if (length(missing_objects) == 0) {
    return(invisible(TRUE))
  }
  
  if (!auto_source) {
    stop(
      paste0(
        "Missing required objects for ",
        season_year,
        ": ",
        paste(missing_objects, collapse = ", "),
        ". Load that season script first or set auto_source_season_scripts <- TRUE."
      ),
      call. = FALSE
    )
  }
  
  season_script_path <- resolve_season_script_path(season_year)
  message("Sourcing season script: ", season_script_path)
  source_weekly_script_safely(season_script_path, env = env)
  
  missing_after_source <- needed_objects[!vapply(needed_objects, exists, logical(1), envir = env, inherits = FALSE)]
  if (length(missing_after_source) > 0) {
    stop(
      paste0(
        "Season script loaded but some expected objects are still missing for ",
        season_year,
        ": ",
        paste(missing_after_source, collapse = ", ")
      ),
      call. = FALSE
    )
  }
  
  invisible(TRUE)
}

coerce_position_df <- function(df, position_name, season_year, variant_name) {
  df <- as_tibble(df)
  
  if (!("SEA" %in% names(df))) {
    df$SEA <- as.integer(season_year)
  }
  if (!("POS" %in% names(df))) {
    df$POS <- position_name
  }
  
  df$SEA <- suppressWarnings(as.integer(df$SEA))
  if ("WK" %in% names(df)) {
    df$WK <- suppressWarnings(as.integer(df$WK))
  }
  if ("G" %in% names(df)) {
    df$G <- suppressWarnings(as.integer(df$G))
  }
  
  df$position_group <- position_name
  df$source_variant <- variant_name
  df$source_season <- as.integer(season_year)
  df
}

collect_position_variant <- function(position_name, variant_name, seasons = model_source_seasons, env = .GlobalEnv) {
  cfg <- position_configs[[position_name]]
  object_map <- cfg[[variant_name]]
  
  position_dfs <- lapply(seasons, function(season_year) {
    object_name <- object_map[[as.character(season_year)]]
    if (!exists(object_name, envir = env, inherits = FALSE)) {
      stop(
        paste0(
          "Expected object ",
          object_name,
          " is missing for ",
          position_name,
          " ",
          variant_name,
          " ",
          season_year,
          "."
        ),
        call. = FALSE
      )
    }
    coerce_position_df(get(object_name, envir = env), position_name, season_year, variant_name)
  })
  
  bind_rows(position_dfs)
}

build_hybrid_position_df <- function(position_name, weekly_df, avg_df) {
  join_keys <- intersect(
    position_configs[[position_name]]$join_keys,
    intersect(names(weekly_df), names(avg_df))
  )
  
  if (length(join_keys) == 0) {
    stop(
      paste0("No shared join keys found for ", position_name, " weekly/avg merge."),
      call. = FALSE
    )
  }
  
  avg_df_dedup <- avg_df %>%
    distinct(across(all_of(join_keys)), .keep_all = TRUE)
  
  avg_only_cols <- setdiff(names(avg_df_dedup), join_keys)
  avg_df_prefixed <- avg_df_dedup %>%
    rename_with(
      ~ paste0("avg_", .x),
      .cols = all_of(avg_only_cols)
    )
  
  hybrid_df <- weekly_df %>%
    left_join(avg_df_prefixed, by = join_keys)
  
  attr(hybrid_df, "join_keys") <- join_keys
  hybrid_df
}

write_position_csv <- function(df, file_name) {
  utils::write.csv(df, file.path(combine_output_dir, file_name), row.names = FALSE, na = "")
}

audit_current_dst_sources <- function(weekly, avg,
                                      data_dir = "C:/Users/danma/OneDrive/Documents/NFLfastR/2026 data") {
  normalize <- function(x) {
    x <- toupper(trimws(as.character(x)))
    alias <- c(ARZ="ARI", BLT="BAL", CLV="CLE", HST="HOU", LA="LAR", JAC="JAX", WSH="WAS")
    hit <- x %in% names(alias); x[hit] <- unname(alias[x[hit]]); x
  }
  mapping <- c(SACK_def_team="sacks", INT_def_team="interceptions", FUM_def_team="fumbleRecoveries",
               safety_def_team="safeties", Def_TDs_team="defenseTouchdowns", K_TDs_team="kickTouchdowns",
               P_TDs_team="puntTouchdowns", PTs_allw_team="paPerGame")
  needed <- c("TM_DEF","SEA","WK","DST_ftpts",names(mapping))
  if (!all(needed %in% names(weekly))) stop("DST weekly source is missing audited scoring columns")
  expected <- list()
  for (week in sort(unique(as.integer(weekly$WK)))) {
    path <- file.path(data_dir,sprintf("DST 26 wk %d.csv",week))
    if (!file.exists(path)) stop("Missing DST box score: ",path)
    box <- utils::read.csv(path,stringsAsFactors=FALSE,check.names=FALSE)
    if (!all(c("team","games",unname(mapping)) %in% names(box))) stop("Incomplete DST box-score schema")
    box$TM_DEF <- normalize(box$team)
    if (anyNA(box$TM_DEF) || any(!nzchar(box$TM_DEF)) || anyDuplicated(box$TM_DEF)) stop("Invalid DST box-score keys")
    if (anyNA(box$games) || any(box$games != 1)) stop("DST box score must have one game per team/week")
    e <- data.frame(TM_DEF=box$TM_DEF,WK=week)
    for (col in names(mapping)) {
      e[[col]] <- suppressWarnings(as.numeric(box[[mapping[[col]]]]))
      if (any(!is.finite(e[[col]]) | e[[col]] < 0)) stop("Invalid DST box score component: ",col)
    }
    pa <- e$PTs_allw_team
    pa_points <- ifelse(pa==0,5,ifelse(pa<=6,4,ifelse(pa<=13,3,ifelse(pa<=17,1,
                                                                      ifelse(pa<=27,0,ifelse(pa<=34,-1,ifelse(pa<=45,-3,-5)))))))
    e$DST_ftpts <- e$SACK_def_team + 2*(e$INT_def_team + e$FUM_def_team + e$safety_def_team) +
      6*(e$Def_TDs_team + e$K_TDs_team + e$P_TDs_team) + pa_points
    expected[[as.character(week)]] <- e
  }
  expected <- dplyr::bind_rows(expected)
  key <- function(x) paste(normalize(x$TM_DEF),x$WK,sep="|")
  if (anyDuplicated(key(weekly)) || !setequal(key(expected),key(weekly))) stop("DST actual-source coverage or keys do not match")
  i <- match(key(weekly),key(expected))
  checks <- lapply(c(names(mapping),"DST_ftpts"),function(col) {
    actual <- suppressWarnings(as.numeric(weekly[[col]]))
    bad <- !is.finite(actual) | abs(actual-expected[[col]][i])>1e-7
    data.frame(field=col,variant="weekly",rows=length(bad),mismatches=sum(bad))
  })
  # Both season-average aliases must reflect the corrected actual components.
  for (entry in list(list(data=weekly,label="weekly"),list(data=avg,label="avg"))) {
    df <- entry$data
    if (!"TM_DEF" %in% names(df)) stop("Missing defense-team key in DST averages")
    for (col in c(names(mapping),"DST_ftpts")) {
      means <- tapply(expected[[col]],expected$TM_DEF,mean)
      want <- round(as.numeric(means[normalize(df$TM_DEF)]),2)
      candidates <- unique(c(paste0("avg_total_",col),paste0("avg_total_",sub("_team$","",col))))
      available <- intersect(candidates,names(df))
      if (!length(available)) stop("Missing DST average component: ",col)
      for (alias in available) {
        actual <- suppressWarnings(as.numeric(df[[alias]]))
        bad <- !is.finite(actual) | !is.finite(want) | abs(actual-want)>1e-7
        checks[[length(checks)+1L]] <- data.frame(field=alias,variant=entry$label,rows=nrow(df),mismatches=sum(bad))
      }
    }
  }
  audit <- dplyr::bind_rows(checks)
  audit$status <- ifelse(audit$mismatches==0L,"PASS","FAIL")
  audit
}

prepare_current_sources <- function(env = .GlobalEnv) {
  cutoff <- current_source_through_week
  if (length(cutoff) != 1L || is.na(cutoff) || cutoff < 1L || cutoff > 18L ||
      cutoff != as.integer(cutoff)) stop("Invalid completed-week cutoff.", call. = FALSE)
  # Do not auto-source a partially failed season run or reuse preseason blanks.
  if (!isTRUE(get0("use_real_2026_weekly_stats", envir = env, inherits = FALSE)) ||
      !identical(as.integer(get0("season_run_through_week_26", envir = env,
                                 inherits = FALSE)), as.integer(cutoff))) {
    stop("Run the updated 2026 script successfully with real stats and through-week ",
         cutoff, " before combining current-season data.", call. = FALSE)
  }
  ensure_season_objects(current_source_season, env = env, auto_source = FALSE)
  outputs <- list()
  audit <- list()
  for (position in names(position_configs)) {
    parts <- list()
    for (variant in c("weekly", "avg")) {
      object <- position_configs[[position]][[variant]][["2026"]]
      df <- get(object, envir = env, inherits = FALSE)
      if (!is.data.frame(df) || !all(c("SEA", "WK", "TM") %in% names(df))) {
        stop(object, " must contain SEA, WK and TM.", call. = FALSE)
      }
      df <- coerce_position_df(df, position, current_source_season, variant)
      # Historical CSVs store dates and factors as text; align in-memory sources.
      for (column in names(df)) {
        if (inherits(df[[column]], c("Date", "POSIXt")) || is.factor(df[[column]])) {
          df[[column]] <- as.character(df[[column]])
        }
      }
      if (anyNA(df$SEA) || anyNA(df$WK) || any(df$SEA != current_source_season) ||
          any(df$WK < 1L | df$WK > 18L)) {
        stop("Invalid season/week keys in ", object, call. = FALSE)
      }
      future_rows <- sum(df$WK > cutoff)
      df <- df[df$WK <= cutoff, , drop = FALSE]
      if (nrow(df) == 0L || !any(df$WK == cutoff)) {
        stop(object, " has no data at the completed-week cutoff.", call. = FALSE)
      }
      identity <- if (position == "DST") "Name" else "Player"
      keys <- c(identity, "TM", "POS", "SEA", "WK")
      if (!all(keys %in% names(df)) || anyNA(df[keys]) || anyDuplicated(df[keys])) {
        stop("Missing or duplicate player-week keys in ", object, call. = FALSE)
      }
      parts[[variant]] <- df
      audit[[length(audit) + 1L]] <- tibble(position = position, variant = variant,
                                            season = current_source_season, through_week = cutoff, rows = nrow(df),
                                            min_week = min(df$WK), max_week = max(df$WK),
                                            excluded_future_rows = future_rows, status = "PASS")
    }
    if (position == "DST") {
      dst_box_audit <- audit_current_dst_sources(parts$weekly, parts$avg)
      if (any(dst_box_audit$status != "PASS")) {
        stop("DST box-score reconciliation failed: ",
             paste(dst_box_audit$field[dst_box_audit$status != "PASS"],collapse=", "),
             ". Rerun the corrected 2026 script before combining; existing exports were not overwritten.",call.=FALSE)
      }
    }
    hybrid <- build_hybrid_position_df(position, parts$weekly, parts$avg)
    stopifnot(nrow(hybrid) == nrow(parts$weekly))
    outputs[[paste0(position, "_weekly")]] <- parts$weekly
    outputs[[paste0(position, "_avg")]] <- parts$avg
    outputs[[paste0(position, "_hybrid")]] <- hybrid
  }
  list(tables = outputs, audit = bind_rows(audit), dst_box_audit = dst_box_audit)
}

read_historical_sources <- function(directory = combine_output_dir) {
  tables <- list()
  for (position in names(position_configs)) {
    for (variant in c("weekly", "avg", "hybrid")) {
      name <- paste0(position, "_", variant)
      path <- file.path(directory, paste0(tolower(name), "_2021_2025.csv"))
      if (!file.exists(path)) {
        stop("Historical source missing: ", path,
             ". Restore the historical exports before combining current data.", call. = FALSE)
      }
      df <- utils::read.csv(path, stringsAsFactors = FALSE, check.names = FALSE)
      if (!"SEA" %in% names(df) || anyNA(df$SEA) ||
          any(!df$SEA %in% model_source_seasons)) {
        stop("Invalid historical season coverage: ", path, call. = FALSE)
      }
      tables[[name]] <- as_tibble(df)
    }
  }
  tables
}

write_current_sources <- function(current, history, output_root = dirname(combine_output_dir)) {
  current_dir <- file.path(output_root, "model_sources_2026")
  live_dir <- file.path(output_root, "model_sources_2021_2026")
  # Construct all tables before writing so type conflicts cannot leave partial exports.
  live <- lapply(names(current$tables), function(name) {
    if (is.null(history[[name]])) stop("Missing historical table: ", name, call. = FALSE)
    if (any(history[[name]]$SEA > 2025L, na.rm = TRUE)) {
      stop("Current-season rows must not enter the historical training sources.", call. = FALSE)
    }
    bind_rows(history[[name]], current$tables[[name]])
  })
  names(live) <- names(current$tables)
  current_all <- bind_rows(current$tables[grepl("_hybrid$", names(current$tables))])
  live_all <- bind_rows(live[grepl("_hybrid$", names(live))])
  dir.create(current_dir, recursive = TRUE, showWarnings = FALSE)
  dir.create(live_dir, recursive = TRUE, showWarnings = FALSE)
  for (name in names(current$tables)) {
    utils::write.csv(current$tables[[name]],
                     file.path(current_dir, paste0(tolower(name), "_2026.csv")), row.names = FALSE, na = "")
    utils::write.csv(live[[name]],
                     file.path(live_dir, paste0(tolower(name), "_2021_2026.csv")), row.names = FALSE, na = "")
  }
  utils::write.csv(current_all, file.path(current_dir, "all_positions_hybrid_2026.csv"),
                   row.names = FALSE, na = "")
  utils::write.csv(live_all, file.path(live_dir, "all_positions_hybrid_2021_2026.csv"),
                   row.names = FALSE, na = "")
  utils::write.csv(current$audit, file.path(current_dir, "current_source_audit_2026.csv"),
                   row.names = FALSE)
  utils::write.csv(current$dst_box_audit,file.path(current_dir,"dst_box_score_reconciliation_2026.csv"),row.names=FALSE)
  if (requireNamespace("writexl", quietly = TRUE)) {
    writexl::write_xlsx(c(current$tables, list(source_audit = current$audit)),
                        file.path(current_dir, "model_sources_2026.xlsx"))
  }
  message("Current actuals through Week ", current_source_through_week, ": ", current_dir)
  message("Combined live sources (not frozen training data): ", live_dir)
  invisible(list(current = current_dir, live = live_dir))
}

if (isTRUE(getOption("model_combine_run", TRUE))) {
  # Validate the current-season inputs before touching any existing exports.
  current_position_sources <- prepare_current_sources()
  
  if (isTRUE(reuse_historical_sources)) {
    position_outputs <- read_historical_sources()
    message("Reusing historical sources without overwriting them: ", combine_output_dir)
  } else {
    dir.create(combine_output_dir, recursive = TRUE, showWarnings = FALSE)
    for (season_year in model_source_seasons) {
      ensure_season_objects(
        season_year,
        env = .GlobalEnv,
        auto_source = auto_source_season_scripts
      )
    }
    
    position_outputs <- list()
    manifest_rows <- list()
    
    for (position_name in names(position_configs)) {
      weekly_df <- collect_position_variant(position_name, "weekly")
      avg_df <- collect_position_variant(position_name, "avg")
      hybrid_df <- build_hybrid_position_df(position_name, weekly_df, avg_df)
      join_keys <- attr(hybrid_df, "join_keys")
      
      weekly_file <- paste0(tolower(position_name), "_weekly_2021_2025.csv")
      avg_file <- paste0(tolower(position_name), "_avg_2021_2025.csv")
      hybrid_file <- paste0(tolower(position_name), "_hybrid_2021_2025.csv")
      
      write_position_csv(weekly_df, weekly_file)
      write_position_csv(avg_df, avg_file)
      write_position_csv(hybrid_df, hybrid_file)
      
      position_outputs[[paste0(position_name, "_weekly")]] <- weekly_df
      position_outputs[[paste0(position_name, "_avg")]] <- avg_df
      position_outputs[[paste0(position_name, "_hybrid")]] <- hybrid_df
      
      manifest_rows[[length(manifest_rows) + 1]] <- tibble(
        position = position_name,
        variant = "weekly",
        file_name = weekly_file,
        rows = nrow(weekly_df),
        cols = ncol(weekly_df),
        join_keys = paste(join_keys, collapse = ", ")
      )
      manifest_rows[[length(manifest_rows) + 1]] <- tibble(
        position = position_name,
        variant = "avg",
        file_name = avg_file,
        rows = nrow(avg_df),
        cols = ncol(avg_df),
        join_keys = paste(join_keys, collapse = ", ")
      )
      manifest_rows[[length(manifest_rows) + 1]] <- tibble(
        position = position_name,
        variant = "hybrid",
        file_name = hybrid_file,
        rows = nrow(hybrid_df),
        cols = ncol(hybrid_df),
        join_keys = paste(join_keys, collapse = ", ")
      )
    }
    
    manifest_df <- bind_rows(manifest_rows)
    utils::write.csv(
      manifest_df,
      file.path(combine_output_dir, "model_source_manifest_2021_2025.csv"),
      row.names = FALSE
    )
    
    if (requireNamespace("writexl", quietly = TRUE)) {
      workbook_sheets <- c(
        position_outputs,
        list(model_source_manifest = manifest_df)
      )
      writexl::write_xlsx(
        workbook_sheets,
        path = file.path(combine_output_dir, "model_sources_2021_2025.xlsx")
      )
    }
    
    message("Model source files written to: ", combine_output_dir)
    message("Manifest: ", file.path(combine_output_dir, "model_source_manifest_2021_2025.csv"))
  }
  write_current_sources(current_position_sources, position_outputs)
}
