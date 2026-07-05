suppressPackageStartupMessages({
  library(dplyr)
  library(tibble)
})

# Combine 2021-2025 position data into model-ready source files.
# Output:
#   1) weekly/raw tables by position
#   2) avg tables by position
#   3) hybrid tables by position with avg columns prefixed as avg_

model_source_seasons <- 2021:2025
auto_source_season_scripts <- TRUE
combine_output_dir <- file.path(getwd(), "outputs", "model_sources_2021_2025")

dir.create(combine_output_dir, recursive = TRUE, showWarnings = FALSE)

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
