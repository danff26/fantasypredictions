# Standalone week-over-week model script.
# This file is self-contained and does not source other local model scripts.

model_project_root <- "C:/Users/danma/OneDrive/Documents/New project"
options(model_project_root = model_project_root)

model_local_r_lib <- file.path(model_project_root, "r_libs")
if (dir.exists(model_local_r_lib)) {
  .libPaths(c(normalizePath(model_local_r_lib, winslash = "/", mustWork = FALSE), .libPaths()))
}

model_project_root <- getOption(
  "model_project_root",
  normalizePath(getwd(), winslash = "/", mustWork = TRUE)
)

first_existing_path <- function(paths) {
  existing <- paths[file.exists(paths)]
  if (length(existing) == 0) {
    return(NA_character_)
  }
  normalizePath(existing[[1]], winslash = "/", mustWork = TRUE)
}

model_paths <- list(
  project_root = normalizePath(model_project_root, winslash = "/", mustWork = TRUE),
  workspace_outputs_dir = normalizePath(file.path(model_project_root, "outputs"), winslash = "/", mustWork = FALSE),
  model_root_dir = normalizePath(file.path(model_project_root, "model"), winslash = "/", mustWork = FALSE),
  foundation_output_dir = normalizePath(file.path(model_project_root, "model", "outputs", "foundation"), winslash = "/", mustWork = FALSE),
  sos_output_dir = normalizePath(file.path(model_project_root, "model", "outputs", "season_over_season"), winslash = "/", mustWork = FALSE),
  wow_output_dir = normalizePath(file.path(model_project_root, "model", "outputs", "week_over_week"), winslash = "/", mustWork = FALSE),
  extra_model_data_dir = normalizePath("C:/Users/danma/OneDrive/Documents/extra model data", winslash = "/", mustWork = FALSE),
  nflfastr_root_dir = normalizePath("C:/Users/danma/OneDrive/Documents/NFLfastR", winslash = "/", mustWork = FALSE)
)

model_paths$all_positions_hybrid_csv <- first_existing_path(c(
  file.path(model_paths$workspace_outputs_dir, "all_positions_hybrid_2021_2025.csv"),
  file.path(model_paths$nflfastr_root_dir, "outputs", "model_sources_2021_2025", "all_positions_hybrid_2021_2025.csv")
))

model_paths$historical_weekly_archives <- c(
  "2021" = normalizePath(file.path(model_paths$project_root, "2021 data.zip"), winslash = "/", mustWork = FALSE),
  "2022" = normalizePath(file.path(model_paths$project_root, "2022 Weekly Data.zip"), winslash = "/", mustWork = FALSE),
  "2023" = normalizePath(file.path(model_paths$project_root, "2023 weekly data.zip"), winslash = "/", mustWork = FALSE),
  "2024" = normalizePath(file.path(model_paths$project_root, "2024 weekly data.zip"), winslash = "/", mustWork = FALSE),
  "2025" = normalizePath(file.path(model_paths$project_root, "2025 Weekly Data.zip"), winslash = "/", mustWork = FALSE)
)

model_paths$adp_2026_csv <- normalizePath(
  file.path(model_paths$extra_model_data_dir, "FantasyPros_2026_Overall_ADP_Rankings (1).csv"),
  winslash = "/",
  mustWork = FALSE
)

model_paths$adp_2021_2025_zip <- normalizePath(
  file.path(model_paths$extra_model_data_dir, "FantasyPros_2021_2025_Overall_ADP_Rankings (1).zip"),
  winslash = "/",
  mustWork = FALSE
)

model_paths$college_qb_pass_zip <- normalizePath(
  file.path(model_paths$extra_model_data_dir, "College QB Pass 15-25.zip"),
  winslash = "/",
  mustWork = FALSE
)

model_paths$college_receiving_zip <- normalizePath(
  file.path(model_paths$extra_model_data_dir, "College Receiving 15-25.zip"),
  winslash = "/",
  mustWork = FALSE
)

model_paths$college_rush_zip <- normalizePath(
  file.path(model_paths$extra_model_data_dir, "College Rush 15-25.zip"),
  winslash = "/",
  mustWork = FALSE
)

model_handoff_registry <- data.frame(
  position = c("QB", "QB", "RB", "RB", "WR", "WR", "TE", "TE"),
  mode = c(
    "season_over_season", "week_over_week",
    "season_over_season", "week_over_week",
    "season_over_season", "week_over_week",
    "season_over_season", "week_over_week"
  ),
  handoff_type = c(
    "zip_markdown", "zip_markdown",
    "markdown", "markdown",
    "zip_markdown", "zip_markdown",
    "zip_markdown", "zip_markdown"
  ),
  handoff_path = c(
    normalizePath(file.path(model_paths$extra_model_data_dir, "qb_2026_codex_handoff_package.zip"), winslash = "/", mustWork = FALSE),
    normalizePath(file.path(model_paths$extra_model_data_dir, "qb_2026_codex_handoff_package.zip"), winslash = "/", mustWork = FALSE),
    normalizePath(file.path(model_paths$extra_model_data_dir, "RB_Codex_Handoff_Season_Over_Season_Model.md"), winslash = "/", mustWork = FALSE),
    normalizePath(file.path(model_paths$extra_model_data_dir, "RB_Codex_Handoff_Week_Over_Week_InSeason_Model.md"), winslash = "/", mustWork = FALSE),
    normalizePath(file.path(model_paths$extra_model_data_dir, "wr_codex_handoff_model_logic_v1.zip"), winslash = "/", mustWork = FALSE),
    normalizePath(file.path(model_paths$extra_model_data_dir, "wr_codex_handoff_model_logic_v1.zip"), winslash = "/", mustWork = FALSE),
    normalizePath(file.path(model_paths$extra_model_data_dir, "te_2026_codex_master_handoff_package.zip"), winslash = "/", mustWork = FALSE),
    normalizePath(file.path(model_paths$extra_model_data_dir, "te_2026_codex_master_handoff_package.zip"), winslash = "/", mustWork = FALSE)
  ),
  handoff_member = c(
    "qb_2026_codex_handoff/docs/QB_SEASON_OVER_SEASON_CODEX_HANDOFF.md",
    "qb_2026_codex_handoff/docs/QB_WEEK_OVER_WEEK_CODEX_HANDOFF.md",
    NA_character_,
    NA_character_,
    "wr_codex_handoff_model_logic_v1/WR_SEASON_OVER_SEASON_CODEX_HANDOFF.md",
    "wr_codex_handoff_model_logic_v1/WR_WEEK_OVER_WEEK_CODEX_HANDOFF.md",
    "te_2026_codex_master_handoff_package/TE_2026_MASTER_CODEX_R_HANDOFF.md",
    "te_2026_codex_master_handoff_package/TE_2026_MASTER_CODEX_R_HANDOFF.md"
  ),
  notes = c(
    "Primary QB season-over-season handoff inside zip package.",
    "Primary QB week-over-week handoff inside zip package.",
    "RB season-over-season markdown file.",
    "RB week-over-week markdown file.",
    "Primary WR season-over-season handoff inside zip package.",
    "Primary WR week-over-week handoff inside zip package.",
    "TE master handoff covers both season-over-season and week-over-week logic.",
    "TE master handoff covers both season-over-season and week-over-week logic."
  ),
  stringsAsFactors = FALSE
)

get_handoff_spec <- function(position, mode) {
  spec <- model_handoff_registry[
    model_handoff_registry$position == position &
      model_handoff_registry$mode == mode,
  ]
  if (nrow(spec) == 0) {
    stop(
      paste0("No handoff spec found for ", position, " / ", mode, "."),
      call. = FALSE
    )
  }
  spec
}

validate_model_paths <- function(paths = model_paths) {
  out <- data.frame(
    key = c(
      "all_positions_hybrid_csv",
      "extra_model_data_dir",
      "adp_2026_csv",
      "adp_2021_2025_zip",
      "college_qb_pass_zip",
      "college_receiving_zip",
      "college_rush_zip"
    ),
    path = c(
      paths$all_positions_hybrid_csv,
      paths$extra_model_data_dir,
      paths$adp_2026_csv,
      paths$adp_2021_2025_zip,
      paths$college_qb_pass_zip,
      paths$college_receiving_zip,
      paths$college_rush_zip
    ),
    stringsAsFactors = FALSE
  )
  out$exists <- file.exists(out$path)
  out
}

ensure_package <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    stop(
      paste0("Package '", pkg, "' is required for this model step. Install it in your R environment first."),
      call. = FALSE
    )
  }
}

load_model_core_packages <- function() {
  ensure_package("dplyr")
  if (!"package:dplyr" %in% search()) {
    suppressPackageStartupMessages(library(dplyr))
  }
  invisible(TRUE)
}

pick_first_existing <- function(df, candidates) {
  for (candidate in candidates) {
    if (candidate %in% names(df)) {
      return(df[[candidate]])
    }
  }
  rep(NA, nrow(df))
}

pick_first_existing_numeric <- function(df, candidates) {
  safe_numeric(pick_first_existing(df, candidates))
}

pick_first_existing_character <- function(df, candidates) {
  as.character(pick_first_existing(df, candidates))
}

`%||%` <- function(x, y) {
  if (is.null(x) || length(x) == 0) y else x
}

safe_numeric <- function(x) {
  suppressWarnings(as.numeric(x))
}

safe_integer <- function(x) {
  suppressWarnings(as.integer(x))
}

safe_div <- function(num, den) {
  num <- safe_numeric(num)
  den <- safe_numeric(den)
  ifelse(is.na(den) | den == 0, NA_real_, num / den)
}

sum_existing_numeric <- function(df, candidate_groups) {
  if (length(candidate_groups) == 0) {
    return(rep(0, nrow(df)))
  }
  
  parts <- lapply(candidate_groups, function(candidates) {
    pick_first_existing_numeric(df, candidates)
  })
  
  out <- Reduce(`+`, parts)
  out[!is.finite(out)] <- 0
  out
}

compute_k_fga_from_df <- function(df) {
  sum_existing_numeric(
    df,
    list(
      c("attempt19", "attempt_19", "att19", "FGA19", "fga19"),
      c("attempt29", "attempt_29", "att29", "FGA29", "fga29"),
      c("attempt39", "attempt_39", "att39", "FGA39", "fga39"),
      c("attempt49", "attempt_49", "att49", "FGA49", "fga49"),
      c("attempt50", "attempt_50", "att50", "FGA50", "fga50")
    )
  )
}

compute_k_fgm_from_df <- function(df) {
  sum_existing_numeric(
    df,
    list(
      c("complete19", "complete_19", "made19", "FGM19", "fgm19"),
      c("complete29", "complete_29", "made29", "FGM29", "fgm29"),
      c("complete39", "complete_39", "made39", "FGM39", "fgm39"),
      c("complete49", "complete_49", "made49", "FGM49", "fgm49"),
      c("complete50", "complete_50", "made50", "FGM50", "fgm50")
    )
  )
}

compute_k_fg_pct_from_df <- function(df) {
  round(safe_div(compute_k_fgm_from_df(df), compute_k_fga_from_df(df)) * 100, 1)
}

compute_k_fantasy_points_from_df <- function(df) {
  made_0_39 <- sum_existing_numeric(
    df,
    list(
      c("complete19", "complete_19", "made19", "FGM19", "fgm19"),
      c("complete29", "complete_29", "made29", "FGM29", "fgm29"),
      c("complete39", "complete_39", "made39", "FGM39", "fgm39")
    )
  )
  made_40_49 <- sum_existing_numeric(
    df,
    list(
      c("complete49", "complete_49", "made49", "FGM49", "fgm49")
    )
  )
  made_50_plus <- sum_existing_numeric(
    df,
    list(
      c("complete50", "complete_50", "made50", "FGM50", "fgm50")
    )
  )
  xp_made <- pick_first_existing_numeric(df, c("epsMade", "epsMade_ply", "xpm", "XPM", "XP_Made"))
  
  points <- made_0_39 * 3 + made_40_49 * 4 + made_50_plus * 5 + xp_made
  points[!is.finite(points)] <- NA_real_
  points
}

compute_dst_fantasy_points_from_df <- function(df) {
  out <- dplyr::coalesce(
    pick_first_existing_numeric(df, c("fantasyPts", "fantasyPts_ply")),
    pick_first_existing_numeric(df, c("DST_ftpts", "dst_ftpts"))
  )
  out[!is.finite(out)] <- NA_real_
  out
}

pct_to_num <- function(x) {
  x_chr <- as.character(x)
  x_chr <- trimws(gsub("%", "", x_chr, fixed = TRUE))
  safe_numeric(x_chr)
}

first_non_missing <- function(x) {
  keep <- x[!is.na(x) & x != ""]
  if (length(keep) == 0) {
    return(NA)
  }
  keep[[1]]
}

first_non_missing_character <- function(x) {
  x_chr <- trimws(as.character(x))
  keep <- x_chr[!is.na(x_chr) & x_chr != ""]
  if (length(keep) == 0) {
    return(NA_character_)
  }
  keep[[1]]
}

first_non_missing_numeric <- function(x) {
  x_num <- safe_numeric(x)
  keep <- x_num[is.finite(x_num)]
  if (length(keep) == 0) {
    return(NA_real_)
  }
  keep[[1]]
}

normalize_team_abbr <- function(team_vec) {
  team_vec <- as.character(team_vec)
  dplyr::case_when(
    team_vec == "LA" ~ "LAR",
    team_vec == "CLV" ~ "CLE",
    team_vec == "HST" ~ "HOU",
    team_vec == "BLT" ~ "BAL",
    team_vec == "ARZ" ~ "ARI",
    TRUE ~ team_vec
  )
}

make_player_key <- function(player_vec) {
  player_vec <- as.character(player_vec)
  ascii_vec <- iconv(player_vec, to = "ASCII//TRANSLIT")
  player_vec[!is.na(ascii_vec)] <- ascii_vec[!is.na(ascii_vec)]
  player_vec <- tolower(player_vec)
  player_vec <- gsub("[.`']", "", player_vec)
  player_vec <- gsub("\\b(jr|sr|ii|iii|iv|v)\\b", "", player_vec)
  player_vec <- gsub("[^a-z0-9 ]", " ", player_vec)
  trimws(gsub("\\s+", " ", player_vec))
}

read_csv_flexible <- function(path, ...) {
  if (!file.exists(path)) {
    stop(paste0("File does not exist: ", path), call. = FALSE)
  }
  
  if (requireNamespace("data.table", quietly = TRUE)) {
    return(as.data.frame(data.table::fread(path, ...)))
  }
  
  if (requireNamespace("readr", quietly = TRUE)) {
    return(as.data.frame(readr::read_csv(path, show_col_types = FALSE, progress = FALSE, ...)))
  }
  
  utils::read.csv(path, check.names = FALSE, stringsAsFactors = FALSE, ...)
}

read_text_from_zip <- function(zip_path, member_path) {
  if (!file.exists(zip_path)) {
    stop(paste0("Zip file does not exist: ", zip_path), call. = FALSE)
  }
  paste(
    readLines(unz(zip_path, member_path), warn = FALSE, encoding = "UTF-8"),
    collapse = "\n"
  )
}

read_text_from_handoff <- function(handoff_spec) {
  handoff_type <- handoff_spec$handoff_type[[1]]
  handoff_path <- handoff_spec$handoff_path[[1]]
  handoff_member <- handoff_spec$handoff_member[[1]]
  
  if (handoff_type == "markdown") {
    return(paste(readLines(handoff_path, warn = FALSE, encoding = "UTF-8"), collapse = "\n"))
  }
  
  if (handoff_type == "zip_markdown") {
    return(read_text_from_zip(handoff_path, handoff_member))
  }
  
  stop(paste0("Unsupported handoff type: ", handoff_type), call. = FALSE)
}

load_all_positions_hybrid <- function(file_path = model_paths$all_positions_hybrid_csv) {
  if (is.na(file_path) || !file.exists(file_path)) {
    stop(
      "The combined hybrid CSV could not be found. Rebuild it or update model_paths$all_positions_hybrid_csv.",
      call. = FALSE
    )
  }
  
  read_csv_flexible(file_path)
}

augment_model_spine <- function(df) {
  load_model_core_packages()
  
  kicker_fantasy_points <- compute_k_fantasy_points_from_df(df)
  dst_fantasy_points <- compute_dst_fantasy_points_from_df(df)
  
  df |>
    mutate(
      player_name = dplyr::coalesce(as.character(.data$Player), as.character(.data$Name)),
      player_key = make_player_key(player_name),
      team = normalize_team_abbr(.data$TM),
      position = as.character(.data$POS),
      season = safe_integer(.data$SEA),
      week = safe_integer(.data$WK),
      game_number = safe_integer(.data$G),
      opponent_team = normalize_team_abbr(.data$TM_DEF),
      depth_team_num = safe_numeric(.data$depth_team),
      age_num = safe_numeric(.data$age),
      rookie_year_num = safe_integer(.data$rookie_year),
      report_status = dplyr::coalesce(
        dplyr::na_if(trimws(as.character(.data$report_status)), ""),
        "Active"
      ),
      practice_status = dplyr::coalesce(
        dplyr::na_if(trimws(as.character(.data$practice_status)), ""),
        "Full"
      ),
      fantasy_points_game = dplyr::coalesce(
        safe_numeric(.data$fantasyPts),
        safe_numeric(.data$FP_G),
        safe_numeric(.data$FP_G_rush),
        kicker_fantasy_points,
        dst_fantasy_points
      ),
      source_position = if ("dataset_file" %in% names(df)) {
        sub("_.*$", "", as.character(.data$dataset_file))
      } else {
        NA_character_
      }
    )
}

filter_model_positions <- function(df, positions = c("QB", "RB", "WR", "TE")) {
  load_model_core_packages()
  
  df |>
    filter(.data$position %in% .env$positions)
}

build_team_week_context_reference <- function(
    file_path = model_paths$all_positions_hybrid_csv,
    positions = c("QB", "RB", "WR", "TE")
) {
  load_model_core_packages()
  
  context_raw <- load_all_positions_hybrid(file_path) |>
    augment_model_spine() |>
    dplyr::filter(.data$position %in% .env$positions)
  
  if (nrow(context_raw) == 0) {
    return(data.frame(
      season = integer(),
      week = integer(),
      team = character(),
      opponent_context = character(),
      defense_team_context = character(),
      defense_name_context = character(),
      defense_head_coach_context = character(),
      game_day_context = character(),
      week_day_context = character(),
      game_time_context = character(),
      team_total_line_context = double(),
      team_spread_line_context = double(),
      game_temp_context = double(),
      game_wind_context = double(),
      stadium_context = character(),
      roof_context = character(),
      surface_context = character(),
      stringsAsFactors = FALSE
    ))
  }
  
  context_raw |>
    dplyr::transmute(
      season = .data$season,
      week = .data$week,
      team = .data$team,
      opponent_context = .data$opponent_team,
      defense_team_context = normalize_team_abbr(pick_first_existing_character(context_raw, c("TM_DEF"))),
      defense_name_context = pick_first_existing_character(context_raw, c("Name_DEF")),
      defense_head_coach_context = pick_first_existing_character(context_raw, c("Head_Coach_DEF")),
      game_day_context = pick_first_existing_character(context_raw, c("gameday_off", "gameday")),
      week_day_context = pick_first_existing_character(context_raw, c("weekday_off", "weekday")),
      game_time_context = pick_first_existing_character(context_raw, c("gametime_off", "gametime")),
      team_total_line_context = pick_first_existing_numeric(context_raw, c("total_line_off", "total_off")),
      team_spread_line_context = pick_first_existing_numeric(context_raw, c("spread_line_off", "spread_line")),
      game_temp_context = pick_first_existing_numeric(context_raw, c("temp_off", "temp")),
      game_wind_context = pick_first_existing_numeric(context_raw, c("wind_off", "wind")),
      stadium_context = pick_first_existing_character(context_raw, c("stadium_off", "stadium")),
      roof_context = pick_first_existing_character(context_raw, c("roof_off", "roof")),
      surface_context = pick_first_existing_character(context_raw, c("surface_off", "surface"))
    ) |>
    dplyr::group_by(.data$season, .data$week, .data$team) |>
    dplyr::summarise(
      opponent_context = first_non_missing_character(.data$opponent_context),
      defense_team_context = first_non_missing_character(.data$defense_team_context),
      defense_name_context = first_non_missing_character(.data$defense_name_context),
      defense_head_coach_context = first_non_missing_character(.data$defense_head_coach_context),
      game_day_context = first_non_missing_character(.data$game_day_context),
      week_day_context = first_non_missing_character(.data$week_day_context),
      game_time_context = first_non_missing_character(.data$game_time_context),
      team_total_line_context = first_non_missing_numeric(.data$team_total_line_context),
      team_spread_line_context = first_non_missing_numeric(.data$team_spread_line_context),
      game_temp_context = first_non_missing_numeric(.data$game_temp_context),
      game_wind_context = first_non_missing_numeric(.data$game_wind_context),
      stadium_context = first_non_missing_character(.data$stadium_context),
      roof_context = first_non_missing_character(.data$roof_context),
      surface_context = first_non_missing_character(.data$surface_context),
      .groups = "drop"
    )
}

load_position_hybrid <- function(position, include_spine = TRUE, file_path = model_paths$all_positions_hybrid_csv) {
  load_model_core_packages()
  
  position <- toupper(position)
  
  df <- load_all_positions_hybrid(file_path)
  if (include_spine) {
    df <- augment_model_spine(df)
  }
  
  df |>
    filter(.data$POS == .env$position)
}

build_position_foundation <- function(position, output_dir = model_paths$foundation_output_dir, write_output = FALSE) {
  load_model_core_packages()
  
  position <- toupper(position)
  foundation_df <- load_position_hybrid(position)
  
  foundation_df <- foundation_df |>
    arrange(.data$season, .data$week, .data$team, .data$player_name)
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    output_path <- file.path(
      output_dir,
      paste0(tolower(position), "_foundation_hybrid_2021_2025.csv")
    )
    utils::write.csv(foundation_df, output_path, row.names = FALSE, na = "")
  }
  
  foundation_df
}

build_all_position_foundations <- function(positions = c("QB", "RB", "WR", "TE"), write_output = FALSE) {
  load_model_core_packages()
  
  out <- lapply(positions, function(pos) build_position_foundation(pos, write_output = write_output))
  names(out) <- positions
  out
}

build_sos_player_season_index <- function(position) {
  load_model_core_packages()
  
  position <- toupper(position)
  
  load_position_hybrid(position) |>
    filter(.data$season >= 2021, .data$season <= 2025) |>
    group_by(.data$player_key, .data$player_name, .data$team, .data$position, .data$season) |>
    summarise(
      games = n_distinct(.data$week[!is.na(.data$week)]),
      first_week = suppressWarnings(min(.data$week, na.rm = TRUE)),
      last_week = suppressWarnings(max(.data$week, na.rm = TRUE)),
      best_depth_team = suppressWarnings(min(.data$depth_team_num, na.rm = TRUE)),
      age = first_non_missing(.data$age_num),
      rookie_year = first_non_missing(.data$rookie_year_num),
      draft_day = first_non_missing(as.character(.data$Draft_Day)),
      fantasy_points_mean = mean(.data$fantasy_points_game, na.rm = TRUE),
      fantasy_points_sum = sum(.data$fantasy_points_game, na.rm = TRUE),
      .groups = "drop"
    ) |>
    mutate(
      first_week = ifelse(is.infinite(.data$first_week), NA, .data$first_week),
      last_week = ifelse(is.infinite(.data$last_week), NA, .data$last_week)
    )
}

write_sos_player_season_index <- function(position, output_dir = model_paths$sos_output_dir) {
  load_model_core_packages()
  
  position <- toupper(position)
  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
  
  out <- build_sos_player_season_index(position)
  output_path <- file.path(output_dir, paste0(tolower(position), "_sos_player_season_index_2021_2025.csv"))
  utils::write.csv(out, output_path, row.names = FALSE, na = "")
  output_path
}

qb_sos_handoff <- get_handoff_spec("QB", "season_over_season")

qb_fantasy_points_formula <- function(pass_yards, pass_td, interceptions, rush_yards, rush_td) {
  pass_yards <- safe_numeric(pass_yards)
  pass_td <- safe_numeric(pass_td)
  interceptions <- safe_numeric(interceptions)
  rush_yards <- safe_numeric(rush_yards)
  rush_td <- safe_numeric(rush_td)
  
  pass_yards[!is.finite(pass_yards)] <- 0
  pass_td[!is.finite(pass_td)] <- 0
  interceptions[!is.finite(interceptions)] <- 0
  rush_yards[!is.finite(rush_yards)] <- 0
  rush_td[!is.finite(rush_td)] <- 0
  
  pass_yards / 25 +
    pass_td * 4 -
    interceptions * 2 +
    rush_yards / 10 +
    rush_td * 6
}

build_qb_clean_weekly_master <- function(write_output = FALSE, output_dir = model_paths$foundation_output_dir) {
  load_model_core_packages()
  
  qb_raw <- load_position_hybrid("QB")
  
  qb_weekly <- qb_raw |>
    dplyr::transmute(
      season = .data$season,
      week = .data$week,
      game_number = .data$game_number,
      player = .data$player_name,
      player_key = .data$player_key,
      team = .data$team,
      opponent = .data$opponent_team,
      position = .data$position,
      depth_team = .data$depth_team_num,
      qb_depth_role = pick_first_existing_character(qb_raw, c("QB_Depth_Role")),
      draft_day = pick_first_existing_character(qb_raw, c("Draft_Day")),
      report_status = pick_first_existing_character(qb_raw, c("report_status")),
      practice_primary_injury = pick_first_existing_character(qb_raw, c("practice_primary_injury")),
      practice_secondary_injury = pick_first_existing_character(qb_raw, c("practice_secondary_injury")),
      practice_status = pick_first_existing_character(qb_raw, c("practice_status")),
      birth_date = pick_first_existing_character(qb_raw, c("birth_date")),
      rookie_year = .data$rookie_year_num,
      age = .data$age_num,
      pass_attempts = pick_first_existing_numeric(qb_raw, c("ATT", "ATT_ply")),
      completions = pick_first_existing_numeric(qb_raw, c("CMP", "CMP_ply")),
      completion_pct = pick_first_existing_numeric(qb_raw, c("CMP_PCT", "CMP_PCT_ply")),
      pass_yards = pick_first_existing_numeric(qb_raw, c("YDS", "YDS_ply")),
      pass_yards_per_game = pick_first_existing_numeric(qb_raw, c("YDS_G", "YDS_G_ply")),
      yards_per_attempt = pick_first_existing_numeric(qb_raw, c("YPA", "YPA_ply")),
      pass_td = pick_first_existing_numeric(qb_raw, c("TD", "TD_ply")),
      pass_td_rate = pick_first_existing_numeric(qb_raw, c("TD_Rate", "TD_Rate_ply")),
      interceptions = pick_first_existing_numeric(qb_raw, c("INT", "INT_ply")),
      turnovers_total = pick_first_existing_numeric(qb_raw, c("TO", "TO_ply")),
      passer_rating = pick_first_existing_numeric(qb_raw, c("RATE", "RATE_ply")),
      sacks = pick_first_existing_numeric(qb_raw, c("SACK", "SACK_ply")),
      sack_yards = pick_first_existing_numeric(qb_raw, c("SK_YDS", "SK_YDS_ply")),
      sack_pct = pick_first_existing_numeric(qb_raw, c("SACK_PCT", "SACK_PCT_ply", "SK_PCT")),
      any_a = pick_first_existing_numeric(qb_raw, c("ANY_A", "ANY_A_ply")),
      cpoe = pick_first_existing_numeric(qb_raw, c("CPOE", "CPOE_ply")),
      adot = pick_first_existing_numeric(qb_raw, c("aDOT", "aDOT_ply")),
      air_yards = pick_first_existing_numeric(qb_raw, c("AY", "AY_ply")),
      deep_throw_pct = pick_first_existing_numeric(qb_raw, c("DEEP_THROW_PCT", "DEEP_THROW_PCT_ply")),
      deep_throw_attempts = pick_first_existing_numeric(qb_raw, c("DEEP_THROW_ATT", "DEEP_THROW_ATT_ply")),
      yac_pct = pick_first_existing_numeric(qb_raw, c("YAC_PCT", "YAC_PCT_ply")),
      adjusted_completion_pct = pick_first_existing_numeric(qb_raw, c("ADJ_CMP_PCT", "ADJ_CMP_PCT_ply")),
      first_read_pct = pick_first_existing_numeric(qb_raw, c("X1Read_PCT", "X1Read_PCT_ply")),
      accurate_pct = pick_first_existing_numeric(qb_raw, c("ACC_PCT", "ACC_PCT_ply")),
      catchable_pct = pick_first_existing_numeric(qb_raw, c("CATCHABLE_PCT", "CATCHABLE_PCT_ply")),
      off_target_pct = pick_first_existing_numeric(qb_raw, c("OFF_PCT", "OFF_PCT_ply")),
      hero_throw_pct = pick_first_existing_numeric(qb_raw, c("HERO_PCT", "HERO_PCT_ply")),
      twt_rate = pick_first_existing_numeric(qb_raw, c("TWT_RATE", "TWT_RATE_ply")),
      drop_pct = pick_first_existing_numeric(qb_raw, c("DROP_PCT", "DROP_PCT_ply")),
      drop_yards = pick_first_existing_numeric(qb_raw, c("DROP_YDS", "DROP_YDS_ply")),
      time_to_throw = pick_first_existing_numeric(qb_raw, c("TTT", "TTT_ply")),
      time_to_pressure = pick_first_existing_numeric(qb_raw, c("TTP", "TTP_ply")),
      time_to_sack = pick_first_existing_numeric(qb_raw, c("TTSK", "TTSK_ply")),
      time_to_scramble = pick_first_existing_numeric(qb_raw, c("TTSC", "TTSC_ply")),
      qb_sacks_charged = pick_first_existing_numeric(qb_raw, c("QB_SK", "QB_SK_ply")),
      pressures = pick_first_existing_numeric(qb_raw, c("QBP", "QBP_ply")),
      pressure_pct = pick_first_existing_numeric(qb_raw, c("PRESS_PCT", "PRESS_PCT_ply")),
      pressure_to_sack_pct = pick_first_existing_numeric(qb_raw, c("PRESS_TO_SK", "PRESS_TO_SK_ply")),
      pass_roe = pick_first_existing_numeric(qb_raw, c("PrROE", "PrROE_ply")),
      checkdown_pct = pick_first_existing_numeric(qb_raw, c("CHECK_PCT", "CHECK_PCT_ply")),
      rpo_pct = pick_first_existing_numeric(qb_raw, c("RPO_PCT", "RPO_PCT_ply")),
      throwaways = pick_first_existing_numeric(qb_raw, c("TA", "TA_ply")),
      batted_passes = pick_first_existing_numeric(qb_raw, c("BAT", "BAT_ply")),
      spikes = pick_first_existing_numeric(qb_raw, c("SPK", "SPK_ply")),
      rush_attempts = pick_first_existing_numeric(qb_raw, c("CAR", "CAR_ply")),
      rush_yards = pick_first_existing_numeric(qb_raw, c("YDS_rush", "YDS_rush_ply")),
      yards_per_carry = pick_first_existing_numeric(qb_raw, c("YPC", "YPC_ply")),
      rush_td = pick_first_existing_numeric(qb_raw, c("TD_rush", "TD_rush_ply")),
      fumbles = pick_first_existing_numeric(qb_raw, c("FUM", "FUM_ply")),
      scrambles = pick_first_existing_numeric(qb_raw, c("SCRM", "SCRM_ply")),
      scramble_yards = pick_first_existing_numeric(qb_raw, c("SCRM_YDS", "SCRM_YDS_ply")),
      scramble_td = pick_first_existing_numeric(qb_raw, c("SCRM_TD", "SCRM_TD_ply")),
      fantasy_points_source = dplyr::coalesce(
        pick_first_existing_numeric(qb_raw, c("fantasyPts")),
        pick_first_existing_numeric(qb_raw, c("FP_G", "FP_G_ply", "FP_G_rush"))
      ),
      game_day = pick_first_existing_character(qb_raw, c("gameday_off", "gameday")),
      week_day = pick_first_existing_character(qb_raw, c("weekday_off", "weekday")),
      game_time = pick_first_existing_character(qb_raw, c("gametime_off", "gametime")),
      team_total_line = pick_first_existing_numeric(qb_raw, c("total_line_off", "total_off")),
      team_spread_line = pick_first_existing_numeric(qb_raw, c("spread_line_off", "spread_line")),
      game_temp = pick_first_existing_numeric(qb_raw, c("temp_off", "temp")),
      game_wind = pick_first_existing_numeric(qb_raw, c("wind_off", "wind")),
      stadium = pick_first_existing_character(qb_raw, c("stadium_off", "stadium")),
      defense_team = pick_first_existing_character(qb_raw, c("TM_DEF")),
      defense_name = pick_first_existing_character(qb_raw, c("Name_DEF")),
      defense_head_coach = pick_first_existing_character(qb_raw, c("Head_Coach_DEF")),
      source_file = pick_first_existing_character(qb_raw, c("dataset_file"))
    ) |>
    dplyr::filter(!is.na(.data$season), !is.na(.data$week), .data$week >= 1, .data$week <= 18) |>
    dplyr::mutate(
      team = normalize_team_abbr(.data$team),
      opponent = normalize_team_abbr(.data$opponent),
      defense_team = normalize_team_abbr(.data$defense_team),
      fantasy_points_calc = qb_fantasy_points_formula(
        .data$pass_yards,
        .data$pass_td,
        .data$interceptions,
        .data$rush_yards,
        .data$rush_td
      ),
      fantasy_points_official = dplyr::coalesce(.data$fantasy_points_calc, .data$fantasy_points_source),
      regular_season_flag = TRUE
    ) |>
    dplyr::arrange(.data$season, .data$week, .data$team, .data$player)
  
  duplicate_keys <- qb_weekly |>
    dplyr::count(.data$season, .data$week, .data$player_key, name = "dup_n") |>
    dplyr::filter(.data$dup_n > 1)
  
  if (nrow(duplicate_keys) > 0) {
    qb_conflict_cols <- c(
      "team", "pass_attempts", "completions", "pass_yards", "pass_td", "interceptions",
      "rush_attempts", "rush_yards", "rush_td", "fantasy_points_calc"
    )
    conflicting_keys <- qb_weekly |>
      dplyr::semi_join(duplicate_keys, by = c("season", "week", "player_key")) |>
      dplyr::group_by(.data$season, .data$week, .data$player_key) |>
      dplyr::summarise(
        dplyr::across(
          dplyr::all_of(qb_conflict_cols),
          ~ dplyr::n_distinct(.x[!is.na(.x)]),
          .names = "distinct_{.col}"
        ),
        .groups = "drop"
      ) |>
      dplyr::filter(dplyr::if_any(dplyr::starts_with("distinct_"), ~ .x > 1L))
    
    if (nrow(conflicting_keys) > 0) {
      stop(
        paste0(
          "QB clean weekly master has ", nrow(conflicting_keys),
          " conflicting player-week duplicates; inspect the hybrid source before modeling."
        ),
        call. = FALSE
      )
    }
  }
  
  qb_quality_cols <- c(
    "pass_attempts", "completions", "pass_yards", "pass_td", "interceptions",
    "rush_attempts", "rush_yards", "rush_td", "fantasy_points_calc",
    "depth_team", "opponent"
  )
  qb_weekly$.qb_row_completeness <- rowSums(!is.na(qb_weekly[qb_quality_cols]))
  qb_weekly <- qb_weekly |>
    dplyr::arrange(
      .data$season, .data$week, .data$player_key,
      dplyr::desc(.data$.qb_row_completeness),
      dplyr::desc(!is.na(.data$source_file))
    ) |>
    dplyr::distinct(.data$season, .data$week, .data$player_key, .keep_all = TRUE) |>
    dplyr::select(-dplyr::all_of(".qb_row_completeness"))
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      qb_weekly,
      file.path(output_dir, "qb_clean_weekly_master_2021_2025_regular.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  qb_weekly
}

build_qb_team_week_opportunity_table <- function(qb_weekly = build_qb_clean_weekly_master(), write_output = FALSE, output_dir = model_paths$foundation_output_dir) {
  load_model_core_packages()
  
  out <- qb_weekly |>
    dplyr::group_by(.data$season, .data$week, .data$team) |>
    dplyr::summarise(
      team_qb_games = dplyr::n(),
      team_pass_attempts = sum(.data$pass_attempts, na.rm = TRUE),
      team_completions = sum(.data$completions, na.rm = TRUE),
      team_pass_yards = sum(.data$pass_yards, na.rm = TRUE),
      team_pass_td = sum(.data$pass_td, na.rm = TRUE),
      team_interceptions = sum(.data$interceptions, na.rm = TRUE),
      team_sacks = sum(.data$sacks, na.rm = TRUE),
      team_rush_attempts = sum(.data$rush_attempts, na.rm = TRUE),
      team_rush_yards = sum(.data$rush_yards, na.rm = TRUE),
      team_rush_td = sum(.data$rush_td, na.rm = TRUE),
      team_qb_fantasy_points = sum(.data$fantasy_points_calc, na.rm = TRUE),
      .groups = "drop"
    )
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "qb_team_week_opportunity_2021_2025_regular.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_qb_player_share_table <- function(
    qb_weekly = build_qb_clean_weekly_master(),
    team_week = build_qb_team_week_opportunity_table(qb_weekly),
    write_output = FALSE,
    output_dir = model_paths$foundation_output_dir
) {
  load_model_core_packages()
  
  out <- qb_weekly |>
    dplyr::left_join(team_week, by = c("season", "week", "team")) |>
    dplyr::mutate(
      pass_attempt_share = safe_div(.data$pass_attempts, .data$team_pass_attempts),
      pass_yards_share = safe_div(.data$pass_yards, .data$team_pass_yards),
      pass_td_share = safe_div(.data$pass_td, .data$team_pass_td),
      rush_attempt_share = safe_div(.data$rush_attempts, .data$team_rush_attempts),
      rush_yards_share = safe_div(.data$rush_yards, .data$team_rush_yards),
      rush_td_share = safe_div(.data$rush_td, .data$team_rush_td),
      fantasy_point_share = safe_div(.data$fantasy_points_calc, .data$team_qb_fantasy_points),
      starter_flag = dplyr::if_else(!is.na(.data$depth_team) & .data$depth_team <= 1, 1L, 0L)
    )
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "qb_player_share_table_2021_2025_regular.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_qb_weekly_role_usage_table <- function(
    qb_share = build_qb_player_share_table(),
    write_output = FALSE,
    output_dir = model_paths$foundation_output_dir
) {
  load_model_core_packages()
  
  out <- qb_share |>
    dplyr::transmute(
      season,
      week,
      player,
      player_key,
      team,
      opponent,
      depth_team,
      qb_depth_role,
      starter_flag,
      report_status,
      practice_primary_injury,
      practice_secondary_injury,
      practice_status,
      draft_day,
      rookie_year,
      age,
      pass_attempts,
      pass_yards,
      pass_td,
      rush_attempts,
      rush_yards,
      rush_td,
      fantasy_points_calc,
      pass_attempt_share,
      pass_yards_share,
      pass_td_share,
      rush_attempt_share,
      rush_yards_share,
      rush_td_share,
      fantasy_point_share
    )
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "qb_weekly_role_usage_2021_2025_regular.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_qb_player_season_combined_table <- function(
    qb_weekly = build_qb_clean_weekly_master(),
    qb_share = build_qb_player_share_table(qb_weekly = qb_weekly),
    write_output = FALSE,
    output_dir = model_paths$foundation_output_dir
) {
  load_model_core_packages()
  
  out <- qb_share |>
    dplyr::group_by(.data$season, .data$player_key, .data$player, .data$team) |>
    dplyr::summarise(
      games = dplyr::n_distinct(.data$week),
      starter_weeks = sum(.data$starter_flag, na.rm = TRUE),
      best_depth_team = suppressWarnings(min(.data$depth_team, na.rm = TRUE)),
      draft_day = first_non_missing(.data$draft_day),
      rookie_year = first_non_missing(.data$rookie_year),
      age = first_non_missing(.data$age),
      pass_attempts = sum(.data$pass_attempts, na.rm = TRUE),
      completions = sum(.data$completions, na.rm = TRUE),
      pass_yards = sum(.data$pass_yards, na.rm = TRUE),
      pass_td = sum(.data$pass_td, na.rm = TRUE),
      interceptions = sum(.data$interceptions, na.rm = TRUE),
      sacks = sum(.data$sacks, na.rm = TRUE),
      rush_attempts = sum(.data$rush_attempts, na.rm = TRUE),
      rush_yards = sum(.data$rush_yards, na.rm = TRUE),
      rush_td = sum(.data$rush_td, na.rm = TRUE),
      fantasy_points = sum(.data$fantasy_points_calc, na.rm = TRUE),
      fantasy_points_per_game = mean(.data$fantasy_points_calc, na.rm = TRUE),
      fantasy_points_sd = stats::sd(.data$fantasy_points_calc, na.rm = TRUE),
      weekly_floor_p25 = suppressWarnings(stats::quantile(.data$fantasy_points_calc, probs = 0.25, na.rm = TRUE, names = FALSE)),
      weekly_median_p50 = suppressWarnings(stats::quantile(.data$fantasy_points_calc, probs = 0.50, na.rm = TRUE, names = FALSE)),
      weekly_ceiling_p75 = suppressWarnings(stats::quantile(.data$fantasy_points_calc, probs = 0.75, na.rm = TRUE, names = FALSE)),
      weekly_ceiling_p90 = suppressWarnings(stats::quantile(.data$fantasy_points_calc, probs = 0.90, na.rm = TRUE, names = FALSE)),
      pass_attempt_share_mean = mean(.data$pass_attempt_share, na.rm = TRUE),
      pass_yards_share_mean = mean(.data$pass_yards_share, na.rm = TRUE),
      pass_td_share_mean = mean(.data$pass_td_share, na.rm = TRUE),
      rush_attempt_share_mean = mean(.data$rush_attempt_share, na.rm = TRUE),
      rush_yards_share_mean = mean(.data$rush_yards_share, na.rm = TRUE),
      fantasy_point_share_mean = mean(.data$fantasy_point_share, na.rm = TRUE),
      any_a_mean = mean(.data$any_a, na.rm = TRUE),
      cpoe_mean = mean(.data$cpoe, na.rm = TRUE),
      pass_roe_mean = mean(.data$pass_roe, na.rm = TRUE),
      pressure_pct_mean = mean(.data$pressure_pct, na.rm = TRUE),
      .groups = "drop"
    ) |>
    dplyr::mutate(
      best_depth_team = ifelse(is.infinite(.data$best_depth_team), NA, .data$best_depth_team),
      qualified_4_games_current = .data$games >= 4,
      qualified_8_games_current = .data$games >= 8,
      next_season = .data$season + 1L
    ) |>
    dplyr::arrange(.data$season, dplyr::desc(.data$fantasy_points_per_game))
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "qb_player_season_combined_table_2021_2025_regular.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_qb_sos_inputs <- function(write_output = FALSE) {
  load_model_core_packages()
  
  qb_clean_weekly_master <- build_qb_clean_weekly_master(write_output = write_output)
  qb_team_week_opportunity <- build_qb_team_week_opportunity_table(
    qb_weekly = qb_clean_weekly_master,
    write_output = write_output
  )
  qb_player_share_table <- build_qb_player_share_table(
    qb_weekly = qb_clean_weekly_master,
    team_week = qb_team_week_opportunity,
    write_output = write_output
  )
  qb_weekly_role_usage <- build_qb_weekly_role_usage_table(
    qb_share = qb_player_share_table,
    write_output = write_output
  )
  qb_player_season_combined_table <- build_qb_player_season_combined_table(
    qb_weekly = qb_clean_weekly_master,
    qb_share = qb_player_share_table,
    write_output = write_output
  )
  
  out <- list(
    position = "QB",
    mode = "season_over_season",
    handoff = qb_sos_handoff,
    handoff_text = read_text_from_handoff(qb_sos_handoff),
    qb_clean_weekly_master = qb_clean_weekly_master,
    qb_team_week_opportunity = qb_team_week_opportunity,
    qb_player_share_table = qb_player_share_table,
    qb_weekly_role_usage = qb_weekly_role_usage,
    qb_player_season_combined_table = qb_player_season_combined_table,
    player_season_index = build_sos_player_season_index("QB"),
    next_steps = c(
      "Build next-season QB targets from the player-season combined table.",
      "Implement QB season-over-season feature families and next-season targets from the handoff.",
      "Add ADP challenger, OMFG, ranges, and simulation layers after the clean foundation is locked."
    )
  )
  
  if (write_output) {
    out$output_paths <- c(
      qb_clean_weekly_master = file.path(model_paths$foundation_output_dir, "qb_clean_weekly_master_2021_2025_regular.csv"),
      qb_team_week_opportunity = file.path(model_paths$foundation_output_dir, "qb_team_week_opportunity_2021_2025_regular.csv"),
      qb_player_share_table = file.path(model_paths$foundation_output_dir, "qb_player_share_table_2021_2025_regular.csv"),
      qb_weekly_role_usage = file.path(model_paths$foundation_output_dir, "qb_weekly_role_usage_2021_2025_regular.csv"),
      qb_player_season_combined_table = file.path(model_paths$foundation_output_dir, "qb_player_season_combined_table_2021_2025_regular.csv"),
      qb_player_season_index = write_sos_player_season_index("QB")
    )
  }
  
  out
}

build_wow_weekly_base <- function(position) {
  load_model_core_packages()
  
  position <- toupper(position)
  
  load_position_hybrid(position) |>
    filter(.data$season >= 2021, .data$season <= 2025) |>
    arrange(.data$player_key, .data$season, .data$week) |>
    group_by(.data$player_key, .data$season) |>
    mutate(
      games_played_to_date = row_number(),
      season_to_date_fantasy_points = cumsum(dplyr::coalesce(.data$fantasy_points_game, 0)),
      season_to_date_fantasy_points_per_game = season_to_date_fantasy_points / games_played_to_date
    ) |>
    ungroup()
}

write_wow_weekly_base <- function(position, output_dir = model_paths$wow_output_dir) {
  load_model_core_packages()
  
  position <- toupper(position)
  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
  
  out <- build_wow_weekly_base(position)
  output_path <- file.path(output_dir, paste0(tolower(position), "_wow_weekly_base_2021_2025.csv"))
  utils::write.csv(out, output_path, row.names = FALSE, na = "")
  output_path
}

qb_wow_handoff <- get_handoff_spec("QB", "week_over_week")

rolling_mean_vec <- function(x, window_n) {
  x <- safe_numeric(x)
  vapply(
    seq_along(x),
    function(i) mean(x[max(1, i - window_n + 1):i], na.rm = TRUE),
    numeric(1)
  )
}

rolling_sd_vec <- function(x, window_n) {
  x <- safe_numeric(x)
  vapply(
    seq_along(x),
    function(i) {
      vals <- x[max(1, i - window_n + 1):i]
      if (sum(!is.na(vals)) <= 1) {
        return(NA_real_)
      }
      stats::sd(vals, na.rm = TRUE)
    },
    numeric(1)
  )
}

build_qb_weekly_feature_base <- function(write_output = FALSE, output_dir = model_paths$wow_output_dir) {
  load_model_core_packages()
  
  qb_clean <- build_qb_clean_weekly_master(write_output = FALSE)
  
  out <- qb_clean |>
    dplyr::arrange(.data$player_key, .data$season, .data$week) |>
    dplyr::group_by(.data$player_key, .data$season) |>
    dplyr::mutate(
      feature_week = .data$week,
      next_week = .data$week + 1L,
      next_week_fantasy_points = dplyr::lead(.data$fantasy_points_calc),
      next_week_pass_yards = dplyr::lead(.data$pass_yards),
      next_week_pass_td = dplyr::lead(.data$pass_td),
      next_week_interceptions = dplyr::lead(.data$interceptions),
      next_week_rush_yards = dplyr::lead(.data$rush_yards),
      next_week_rush_td = dplyr::lead(.data$rush_td),
      games_played_to_date = dplyr::row_number(),
      season_to_date_fantasy_points = cumsum(dplyr::coalesce(.data$fantasy_points_calc, 0)),
      season_to_date_fantasy_points_per_game = season_to_date_fantasy_points / games_played_to_date,
      season_to_date_pass_attempts_per_game = cumsum(dplyr::coalesce(.data$pass_attempts, 0)) / games_played_to_date,
      season_to_date_pass_yards_per_game = cumsum(dplyr::coalesce(.data$pass_yards, 0)) / games_played_to_date,
      season_to_date_pass_td_per_game = cumsum(dplyr::coalesce(.data$pass_td, 0)) / games_played_to_date,
      season_to_date_rush_attempts_per_game = cumsum(dplyr::coalesce(.data$rush_attempts, 0)) / games_played_to_date,
      season_to_date_rush_yards_per_game = cumsum(dplyr::coalesce(.data$rush_yards, 0)) / games_played_to_date,
      season_to_date_rush_td_per_game = cumsum(dplyr::coalesce(.data$rush_td, 0)) / games_played_to_date,
      rolling3_fantasy_points = rolling_mean_vec(.data$fantasy_points_calc, 3),
      rolling5_fantasy_points = rolling_mean_vec(.data$fantasy_points_calc, 5),
      rolling3_pass_attempts = rolling_mean_vec(.data$pass_attempts, 3),
      rolling5_pass_attempts = rolling_mean_vec(.data$pass_attempts, 5),
      rolling3_pass_yards = rolling_mean_vec(.data$pass_yards, 3),
      rolling5_pass_yards = rolling_mean_vec(.data$pass_yards, 5),
      rolling3_pass_td = rolling_mean_vec(.data$pass_td, 3),
      rolling5_pass_td = rolling_mean_vec(.data$pass_td, 5),
      rolling3_rush_attempts = rolling_mean_vec(.data$rush_attempts, 3),
      rolling5_rush_attempts = rolling_mean_vec(.data$rush_attempts, 5),
      rolling3_rush_yards = rolling_mean_vec(.data$rush_yards, 3),
      rolling5_rush_yards = rolling_mean_vec(.data$rush_yards, 5),
      rolling3_rush_td = rolling_mean_vec(.data$rush_td, 3),
      rolling5_rush_td = rolling_mean_vec(.data$rush_td, 5),
      rolling5_fantasy_points_sd = rolling_sd_vec(.data$fantasy_points_calc, 5),
      rolling5_pass_attempts_sd = rolling_sd_vec(.data$pass_attempts, 5),
      rolling5_rush_attempts_sd = rolling_sd_vec(.data$rush_attempts, 5),
      trend_fantasy_points_3v5 = rolling3_fantasy_points - rolling5_fantasy_points,
      trend_pass_attempts_3v5 = rolling3_pass_attempts - rolling5_pass_attempts,
      trend_rush_attempts_3v5 = rolling3_rush_attempts - rolling5_rush_attempts
    ) |>
    dplyr::ungroup()
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "qb_weekly_feature_base_2021_2025_regular.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_qb_wow_inputs <- function(write_output = FALSE) {
  load_model_core_packages()
  
  qb_weekly_feature_base <- build_qb_weekly_feature_base(write_output = write_output)
  
  out <- list(
    position = "QB",
    mode = "week_over_week",
    handoff = qb_wow_handoff,
    handoff_text = read_text_from_handoff(qb_wow_handoff),
    weekly_base = build_wow_weekly_base("QB"),
    qb_weekly_feature_base = qb_weekly_feature_base,
    next_steps = c(
      "Convert the QB weekly feature base into explicit week-ahead training snapshots.",
      "Add role-state, injury, game environment, and defense matchup layers outside official OMFG.",
      "Build next-week QB projection, range, and backup-start override logic."
    )
  )
  
  if (write_output) {
    out$output_paths <- c(
      qb_weekly_base = write_wow_weekly_base("QB"),
      qb_weekly_feature_base = file.path(model_paths$wow_output_dir, "qb_weekly_feature_base_2021_2025_regular.csv")
    )
  }
  
  out
}

make_qb_wow_output_manifest <- function(qb_wow_result) {
  output_paths <- unname(qb_wow_result$output_paths %||% character())
  output_labels <- names(qb_wow_result$output_paths %||% character())
  
  data.frame(
    output_name = output_labels,
    output_path = output_paths,
    exists = file.exists(output_paths),
    stringsAsFactors = FALSE
  )
}

run_qb_wow_pipeline <- function(write_output = TRUE) {
  load_model_core_packages()
  
  dir.create(model_paths$wow_output_dir, recursive = TRUE, showWarnings = FALSE)
  
  qb_wow_result <- build_qb_wow_inputs(write_output = write_output)
  qb_wow_board_rebuild <- run_qb_wow_board_rebuild(write_output = write_output)
  
  output_paths <- c(
    qb_wow_result$output_paths %||% character(),
    qb_wow_board_metrics = file.path(model_paths$wow_output_dir, "qb_wow_board_metrics_2021_2025.csv"),
    qb_wow_board_summary = file.path(model_paths$wow_output_dir, "qb_wow_board_summary_2021_2025.csv"),
    qb_wow_final_export = file.path(model_paths$wow_output_dir, "qb_wow_final_export_2021_2025.csv")
  )
  
  qb_wow_result$output_paths <- output_paths
  output_manifest <- make_qb_wow_output_manifest(qb_wow_result)
  
  list(
    result = qb_wow_result,
    board = qb_wow_board_rebuild$board,
    board_summary = qb_wow_board_rebuild$board_summary,
    final_export = qb_wow_board_rebuild$final_export,
    output_manifest = output_manifest
  )
}

# -------------------- QB WOW board rebuild from state overlay output --------------------

qb_wow_percent_rank_0to100 <- function(x, higher_is_better = TRUE) {
  x_num <- suppressWarnings(as.numeric(x))
  out <- rep(NA_real_, length(x_num))
  keep <- is.finite(x_num)
  
  if (sum(keep) == 1L) {
    out[keep] <- 100
    return(out)
  }
  
  if (sum(keep) > 1L) {
    vals <- if (higher_is_better) x_num[keep] else -x_num[keep]
    out[keep] <- dplyr::percent_rank(vals) * 100
  }
  
  out
}

qb_wow_row_mean <- function(...) {
  args <- list(...)
  if (length(args) == 0) {
    return(numeric())
  }
  
  max_len <- max(vapply(args, length, integer(1)))
  cols <- lapply(args, function(x) {
    x_num <- suppressWarnings(as.numeric(x))
    length(x_num) <- max_len
    x_num
  })
  
  mat <- do.call(cbind, cols)
  out <- rowMeans(mat, na.rm = TRUE)
  out[!is.finite(out)] <- NA_real_
  out
}

qb_draft_day_score_0to100 <- function(draft_day_vec) {
  draft_chr <- trimws(tolower(as.character(draft_day_vec)))
  
  dplyr::case_when(
    draft_chr %in% c("day 1", "round 1", "round 1-2") ~ 100,
    draft_chr %in% c("day 2", "round 2", "round 2-3") ~ 82,
    draft_chr %in% c("day 3", "round 4", "round 4-7") ~ 64,
    draft_chr %in% c("undrafted", "udfa") ~ 28,
    is.na(draft_chr) | draft_chr == "" ~ 50,
    TRUE ~ 55
  )
}

build_qb_prior_season_week1_summary <- function(qb_wow_state_overlay) {
  load_model_core_packages()
  
  season_summary <- qb_wow_state_overlay |>
    dplyr::mutate(
      player_key = as.character(.data$player_key),
      season = suppressWarnings(as.integer(.data$season)),
      fantasy_points_calc = suppressWarnings(as.numeric(.data$fantasy_points_calc)),
      pass_yards = suppressWarnings(as.numeric(.data$pass_yards)),
      pass_td = suppressWarnings(as.numeric(.data$pass_td)),
      rush_yards = suppressWarnings(as.numeric(.data$rush_yards)),
      rush_td = suppressWarnings(as.numeric(.data$rush_td))
    ) |>
    dplyr::group_by(.data$player_key, .data$season) |>
    dplyr::summarise(
      season_games = sum(is.finite(.data$fantasy_points_calc)),
      season_ppg = ifelse(season_games > 0, mean(.data$fantasy_points_calc, na.rm = TRUE), NA_real_),
      season_total_fp = sum(.data$fantasy_points_calc, na.rm = TRUE),
      season_pass_yards_pg = ifelse(season_games > 0, mean(.data$pass_yards, na.rm = TRUE), NA_real_),
      season_pass_td_pg = ifelse(season_games > 0, mean(.data$pass_td, na.rm = TRUE), NA_real_),
      season_rush_yards_pg = ifelse(season_games > 0, mean(.data$rush_yards, na.rm = TRUE), NA_real_),
      season_rush_td_pg = ifelse(season_games > 0, mean(.data$rush_td, na.rm = TRUE), NA_real_),
      .groups = "drop"
    )
  
  prior_summary <- season_summary |>
    dplyr::transmute(
      player_key = .data$player_key,
      season = .data$season + 1L,
      prior_season_games = .data$season_games,
      prior_season_ppg = .data$season_ppg,
      prior_season_total_fp = .data$season_total_fp,
      prior_season_pass_yards_pg = .data$season_pass_yards_pg,
      prior_season_pass_td_pg = .data$season_pass_td_pg,
      prior_season_rush_yards_pg = .data$season_rush_yards_pg,
      prior_season_rush_td_pg = .data$season_rush_td_pg
    )
  
  target_rows <- season_summary |>
    dplyr::distinct(.data$player_key, .data$season)
  
  career_summary <- lapply(seq_len(nrow(target_rows)), function(i) {
    player_key_i <- target_rows$player_key[[i]]
    season_i <- target_rows$season[[i]]
    
    hist <- season_summary |>
      dplyr::filter(.data$player_key == player_key_i, .data$season < season_i, .data$season_games > 0)
    
    if (nrow(hist) == 0) {
      return(data.frame(
        player_key = player_key_i,
        season = season_i,
        career_games = NA_real_,
        career_seasons = NA_real_,
        career_ppg = NA_real_,
        career_total_fp = NA_real_,
        career_pass_yards_pg = NA_real_,
        career_pass_td_pg = NA_real_,
        career_rush_yards_pg = NA_real_,
        career_rush_td_pg = NA_real_,
        last_active_season = NA_real_,
        years_since_last_active = NA_real_,
        stringsAsFactors = FALSE
      ))
    }
    
    total_games <- sum(hist$season_games, na.rm = TRUE)
    total_fp <- sum(hist$season_total_fp, na.rm = TRUE)
    last_active <- max(hist$season, na.rm = TRUE)
    
    data.frame(
      player_key = player_key_i,
      season = season_i,
      career_games = total_games,
      career_seasons = nrow(hist),
      career_ppg = ifelse(total_games > 0, total_fp / total_games, NA_real_),
      career_total_fp = total_fp,
      career_pass_yards_pg = stats::weighted.mean(hist$season_pass_yards_pg, w = pmax(hist$season_games, 1), na.rm = TRUE),
      career_pass_td_pg = stats::weighted.mean(hist$season_pass_td_pg, w = pmax(hist$season_games, 1), na.rm = TRUE),
      career_rush_yards_pg = stats::weighted.mean(hist$season_rush_yards_pg, w = pmax(hist$season_games, 1), na.rm = TRUE),
      career_rush_td_pg = stats::weighted.mean(hist$season_rush_td_pg, w = pmax(hist$season_games, 1), na.rm = TRUE),
      last_active_season = last_active,
      years_since_last_active = season_i - last_active,
      stringsAsFactors = FALSE
    )
  }) |>
    dplyr::bind_rows()
  
  target_rows |>
    dplyr::left_join(prior_summary, by = c("player_key", "season")) |>
    dplyr::left_join(career_summary, by = c("player_key", "season"))
}

read_qb_wow_state_overlay_output <- function() {
  load_model_core_packages()
  
  state_overlay_path <- file.path(
    model_paths$wow_output_dir,
    "qb_wow_state_overlay_2023_2025.csv"
  )
  
  if (!file.exists(state_overlay_path)) {
    stop(
      paste0(
        "Missing state overlay file: ",
        state_overlay_path,
        ". Run the earlier QB WOW state-overlay build first."
      ),
      call. = FALSE
    )
  }
  
  state_overlay <- utils::read.csv(state_overlay_path, stringsAsFactors = FALSE)
  
  # The overlay is persisted separately from the hybrid source. Restrict it to
  # season/week pairs currently available so audits and new-season updates do
  # not accidentally reuse future rows from an older saved overlay.
  available_source <- tryCatch(
    load_all_positions_hybrid(model_paths$all_positions_hybrid_csv),
    error = function(e) NULL
  )
  
  if (is.null(available_source) || !all(c("season", "week") %in% names(state_overlay))) {
    return(state_overlay)
  }
  
  available_season_col <- if ("SEA" %in% names(available_source)) "SEA" else "season"
  available_week_col <- if ("WK" %in% names(available_source)) "WK" else "week"
  
  if (!all(c(available_season_col, available_week_col) %in% names(available_source))) {
    return(state_overlay)
  }
  
  available_pairs <- available_source |>
    dplyr::transmute(
      season = suppressWarnings(as.integer(.data[[available_season_col]])),
      week = suppressWarnings(as.integer(.data[[available_week_col]]))
    ) |>
    dplyr::filter(is.finite(.data$season), is.finite(.data$week)) |>
    dplyr::distinct()
  
  state_overlay |>
    dplyr::mutate(
      season = suppressWarnings(as.integer(.data$season)),
      week = suppressWarnings(as.integer(.data$week))
    ) |>
    dplyr::semi_join(available_pairs, by = c("season", "week"))
}

build_qb_wow_production_board_fixed <- function(qb_wow_state_overlay = NULL, write_output = TRUE) {
  load_model_core_packages()
  
  if (is.null(qb_wow_state_overlay)) {
    qb_wow_state_overlay <- read_qb_wow_state_overlay_output()
  }
  
  qb_prior_season_summary <- build_qb_prior_season_week1_summary(qb_wow_state_overlay)
  
  out <- qb_wow_state_overlay |>
    dplyr::left_join(qb_prior_season_summary, by = c("player_key", "season")) |>
    dplyr::mutate(
      player_key = as.character(.data$player_key),
      season = suppressWarnings(as.integer(.data$season)),
      week = suppressWarnings(as.integer(.data$week)),
      depth_team = suppressWarnings(as.numeric(.data$depth_team)),
      target_week_fp = suppressWarnings(as.numeric(.data$target_week_fp)),
      qb_wow_anchor_fp = suppressWarnings(as.numeric(.data$qb_wow_anchor_fp)),
      qb_in_season_omfg_score = suppressWarnings(as.numeric(.data$qb_in_season_omfg_score)),
      qb_weekly_board_score = suppressWarnings(as.numeric(.data$qb_weekly_board_score)),
      passing_form_component_0to100 = suppressWarnings(as.numeric(.data$passing_form_component_0to100)),
      role_security_component_0to100 = suppressWarnings(as.numeric(.data$role_security_component_0to100)),
      recent_form_component_0to100 = suppressWarnings(as.numeric(.data$recent_form_component_0to100)),
      rushing_form_component_0to100 = suppressWarnings(as.numeric(.data$rushing_form_component_0to100)),
      injury_status_component_0to100 = suppressWarnings(as.numeric(.data$injury_status_component_0to100)),
      season_to_date_fantasy_points_per_game = suppressWarnings(as.numeric(.data$season_to_date_fantasy_points_per_game)),
      rolling3_fantasy_points = suppressWarnings(as.numeric(.data$rolling3_fantasy_points)),
      rolling5_fantasy_points = suppressWarnings(as.numeric(.data$rolling5_fantasy_points)),
      fantasy_points_calc = suppressWarnings(as.numeric(.data$fantasy_points_calc)),
      prior_season_games = suppressWarnings(as.numeric(.data$prior_season_games)),
      prior_season_ppg = suppressWarnings(as.numeric(.data$prior_season_ppg)),
      prior_season_total_fp = suppressWarnings(as.numeric(.data$prior_season_total_fp)),
      prior_season_pass_yards_pg = suppressWarnings(as.numeric(.data$prior_season_pass_yards_pg)),
      prior_season_pass_td_pg = suppressWarnings(as.numeric(.data$prior_season_pass_td_pg)),
      prior_season_rush_yards_pg = suppressWarnings(as.numeric(.data$prior_season_rush_yards_pg)),
      prior_season_rush_td_pg = suppressWarnings(as.numeric(.data$prior_season_rush_td_pg)),
      career_games = suppressWarnings(as.numeric(.data$career_games)),
      career_seasons = suppressWarnings(as.numeric(.data$career_seasons)),
      career_ppg = suppressWarnings(as.numeric(.data$career_ppg)),
      career_total_fp = suppressWarnings(as.numeric(.data$career_total_fp)),
      career_pass_yards_pg = suppressWarnings(as.numeric(.data$career_pass_yards_pg)),
      career_pass_td_pg = suppressWarnings(as.numeric(.data$career_pass_td_pg)),
      career_rush_yards_pg = suppressWarnings(as.numeric(.data$career_rush_yards_pg)),
      career_rush_td_pg = suppressWarnings(as.numeric(.data$career_rush_td_pg)),
      last_active_season = suppressWarnings(as.numeric(.data$last_active_season)),
      years_since_last_active = suppressWarnings(as.numeric(.data$years_since_last_active)),
      rookie_year = suppressWarnings(as.numeric(.data$rookie_year)),
      draft_day_score_0to100 = qb_draft_day_score_0to100(.data$draft_day),
      has_prior_season_stats = is.finite(.data$prior_season_ppg) & .data$prior_season_games >= 4,
      has_career_stats = is.finite(.data$career_ppg) & .data$career_games >= 4,
      is_true_rookie = is.finite(.data$rookie_year) & .data$rookie_year >= .data$season,
      qb_wow_anchor_fp_filled = dplyr::coalesce(
        .data$qb_wow_anchor_fp,
        .data$season_to_date_fantasy_points_per_game,
        .data$rolling3_fantasy_points,
        .data$rolling5_fantasy_points,
        .data$fantasy_points_calc
      ),
      qb_in_season_omfg_score_filled = dplyr::coalesce(
        .data$qb_in_season_omfg_score,
        qb_wow_row_mean(
          .data$recent_form_component_0to100,
          .data$passing_form_component_0to100,
          .data$role_security_component_0to100,
          .data$rushing_form_component_0to100,
          .data$injury_status_component_0to100
        )
      )
    ) |>
    dplyr::group_by(.data$season, .data$week) |>
    dplyr::mutate(
      wow_anchor_rank_component = qb_wow_percent_rank_0to100(.data$qb_wow_anchor_fp_filled),
      prior_season_ppg_rank = qb_wow_percent_rank_0to100(.data$prior_season_ppg),
      prior_season_total_rank = qb_wow_percent_rank_0to100(.data$prior_season_total_fp),
      prior_season_pass_yards_rank = qb_wow_percent_rank_0to100(.data$prior_season_pass_yards_pg),
      prior_season_pass_td_rank = qb_wow_percent_rank_0to100(.data$prior_season_pass_td_pg),
      prior_season_rush_yards_rank = qb_wow_percent_rank_0to100(.data$prior_season_rush_yards_pg),
      prior_season_rush_td_rank = qb_wow_percent_rank_0to100(.data$prior_season_rush_td_pg),
      career_ppg_rank = qb_wow_percent_rank_0to100(.data$career_ppg),
      career_total_rank = qb_wow_percent_rank_0to100(.data$career_total_fp),
      career_pass_yards_rank = qb_wow_percent_rank_0to100(.data$career_pass_yards_pg),
      career_pass_td_rank = qb_wow_percent_rank_0to100(.data$career_pass_td_pg),
      career_rush_yards_rank = qb_wow_percent_rank_0to100(.data$career_rush_yards_pg),
      career_rush_td_rank = qb_wow_percent_rank_0to100(.data$career_rush_td_pg),
      week1_prior_production_score = qb_wow_row_mean(
        .data$prior_season_ppg_rank,
        .data$prior_season_total_rank,
        .data$prior_season_pass_yards_rank,
        .data$prior_season_pass_td_rank,
        .data$prior_season_rush_yards_rank,
        .data$prior_season_rush_td_rank
      ),
      week1_career_production_score = qb_wow_row_mean(
        .data$career_ppg_rank,
        .data$career_total_rank,
        .data$career_pass_yards_rank,
        .data$career_pass_td_rank,
        .data$career_rush_yards_rank,
        .data$career_rush_td_rank
      ),
      qb_weekly_board_score_filled = dplyr::coalesce(
        .data$qb_weekly_board_score,
        qb_wow_row_mean(
          .data$qb_in_season_omfg_score_filled,
          .data$wow_anchor_rank_component,
          .data$season_to_date_fantasy_points_per_game
        )
      ),
      week1_preseason_omfg_score_raw = dplyr::case_when(
        .data$has_prior_season_stats ~
          0.50 * dplyr::coalesce(.data$week1_prior_production_score, 0) +
          0.15 * dplyr::coalesce(.data$week1_career_production_score, 0) +
          0.20 * dplyr::coalesce(.data$wow_anchor_rank_component, 0) +
          0.10 * dplyr::coalesce(.data$role_security_component_0to100, 0) +
          0.05 * dplyr::coalesce(.data$injury_status_component_0to100, 0),
        .data$has_career_stats ~
          0.55 * dplyr::coalesce(.data$week1_career_production_score, 0) +
          0.15 * dplyr::coalesce(.data$wow_anchor_rank_component, 0) +
          0.15 * dplyr::coalesce(.data$role_security_component_0to100, 0) +
          0.10 * dplyr::coalesce(.data$injury_status_component_0to100, 85) +
          0.05 * dplyr::coalesce(.data$draft_day_score_0to100, 50),
        TRUE ~
          0.35 * dplyr::coalesce(.data$wow_anchor_rank_component, 50) +
          0.25 * dplyr::coalesce(.data$role_security_component_0to100, 50) +
          0.20 * dplyr::coalesce(.data$injury_status_component_0to100, 85) +
          0.20 * dplyr::coalesce(.data$draft_day_score_0to100, 50)
      ),
      week1_preseason_board_score_raw = dplyr::case_when(
        .data$has_prior_season_stats ~
          0.40 * dplyr::coalesce(.data$week1_prior_production_score, 0) +
          0.20 * dplyr::coalesce(.data$week1_career_production_score, 0) +
          0.20 * dplyr::coalesce(.data$wow_anchor_rank_component, 0) +
          0.15 * dplyr::coalesce(.data$role_security_component_0to100, 0) +
          0.05 * dplyr::coalesce(.data$injury_status_component_0to100, 0),
        .data$has_career_stats ~
          0.50 * dplyr::coalesce(.data$week1_career_production_score, 0) +
          0.20 * dplyr::coalesce(.data$wow_anchor_rank_component, 0) +
          0.15 * dplyr::coalesce(.data$role_security_component_0to100, 0) +
          0.10 * dplyr::coalesce(.data$injury_status_component_0to100, 85) +
          0.05 * dplyr::coalesce(.data$draft_day_score_0to100, 50),
        TRUE ~
          0.30 * dplyr::coalesce(.data$wow_anchor_rank_component, 50) +
          0.25 * dplyr::coalesce(.data$role_security_component_0to100, 50) +
          0.25 * dplyr::coalesce(.data$injury_status_component_0to100, 85) +
          0.20 * dplyr::coalesce(.data$draft_day_score_0to100, 50)
      ),
      week1_experience_modifier = dplyr::case_when(
        .data$is_true_rookie & !.data$has_career_stats ~ 0.82,
        !.data$has_prior_season_stats & .data$has_career_stats & is.finite(.data$years_since_last_active) & .data$years_since_last_active >= 2 ~ 0.88,
        !.data$has_prior_season_stats & .data$has_career_stats & .data$career_games < 10 ~ 0.90,
        .data$has_prior_season_stats & .data$prior_season_games < 8 ~ 0.96,
        TRUE ~ 1.00
      ),
      week1_score_cap = dplyr::case_when(
        .data$is_true_rookie & !.data$has_career_stats ~ 76,
        !.data$has_prior_season_stats & .data$has_career_stats & is.finite(.data$years_since_last_active) & .data$years_since_last_active >= 2 ~ 79,
        !.data$has_prior_season_stats & .data$has_career_stats ~ 83,
        TRUE ~ 100
      ),
      week1_preseason_omfg_score = pmin(.data$week1_preseason_omfg_score_raw * .data$week1_experience_modifier, .data$week1_score_cap),
      week1_preseason_board_score = pmin(.data$week1_preseason_board_score_raw * .data$week1_experience_modifier, .data$week1_score_cap),
      qb_in_season_omfg_score_display = dplyr::if_else(
        .data$week == 1L,
        .data$week1_preseason_omfg_score,
        .data$qb_in_season_omfg_score_filled
      ),
      qb_weekly_board_score_display = dplyr::if_else(
        .data$week == 1L,
        .data$week1_preseason_board_score,
        .data$qb_weekly_board_score_filled
      ),
      wow_score_num =
        0.30 * dplyr::coalesce(.data$qb_weekly_board_score_display, 0) +
        0.20 * dplyr::coalesce(.data$qb_in_season_omfg_score_display, 0) +
        0.20 * dplyr::coalesce(.data$wow_anchor_rank_component, 0) +
        0.10 * dplyr::coalesce(.data$passing_form_component_0to100, 0) +
        0.20 * dplyr::coalesce(.data$role_security_component_0to100, 0),
      wow_score_den =
        0.30 * as.numeric(is.finite(.data$qb_weekly_board_score_display)) +
        0.20 * as.numeric(is.finite(.data$qb_in_season_omfg_score_display)) +
        0.20 * as.numeric(is.finite(.data$wow_anchor_rank_component)) +
        0.10 * as.numeric(is.finite(.data$passing_form_component_0to100)) +
        0.20 * as.numeric(is.finite(.data$role_security_component_0to100)),
      qb_wow_final_score = dplyr::if_else(
        .data$week == 1L,
        .data$qb_weekly_board_score_display,
        dplyr::if_else(
          .data$wow_score_den > 0,
          .data$wow_score_num / .data$wow_score_den,
          NA_real_
        )
      )
    ) |>
    dplyr::group_by(.data$season, .data$week) |>
    dplyr::arrange(dplyr::desc(.data$qb_wow_final_score), .data$player, .by_group = TRUE) |>
    dplyr::mutate(
      qb_wow_rank = dplyr::row_number(),
      qb_wow_tier = dplyr::case_when(
        .data$qb_wow_rank <= 3 ~ "Tier 1",
        .data$qb_wow_rank <= 6 ~ "Tier 2",
        .data$qb_wow_rank <= 12 ~ "Tier 3",
        .data$qb_wow_rank <= 18 ~ "Tier 4",
        TRUE ~ "Tier 5"
      )
    ) |>
    dplyr::ungroup() |>
    dplyr::select(
      season,
      week,
      qb_wow_rank,
      qb_wow_tier,
      player,
      team,
      opponent,
      depth_team,
      report_status,
      practice_status,
      qb_wow_final_score,
      qb_weekly_board_score = qb_weekly_board_score_display,
      qb_in_season_omfg_score = qb_in_season_omfg_score_display,
      qb_wow_anchor_fp = qb_wow_anchor_fp_filled,
      passing_form_component_0to100,
      role_security_component_0to100,
      recent_form_component_0to100,
      rushing_form_component_0to100,
      injury_status_component_0to100,
      target_week_fp
    ) |>
    dplyr::arrange(.data$season, .data$week, .data$qb_wow_rank)
  
  if (write_output) {
    dir.create(model_paths$wow_output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(model_paths$wow_output_dir, "qb_wow_production_board_2021_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_qb_wow_board_summary_fixed <- function(qb_wow_board, write_output = TRUE) {
  load_model_core_packages()
  
  week_metrics_raw <- qb_wow_board |>
    dplyr::group_by(.data$season, .data$week) |>
    dplyr::summarise(
      n = sum(is.finite(.data$qb_wow_rank) & is.finite(.data$target_week_fp)),
      spearman = {
        keep <- is.finite(.data$qb_wow_rank) & is.finite(.data$target_week_fp)
        if (sum(keep) > 1) {
          suppressWarnings(stats::cor(-.data$qb_wow_rank[keep], .data$target_week_fp[keep], method = "spearman"))
        } else {
          NA_real_
        }
      },
      .groups = "drop"
    )
  
  full_week_template <- expand.grid(
    season = sort(unique(suppressWarnings(as.integer(qb_wow_board$season)))),
    week = 1:18,
    KEEP.OUT.ATTRS = FALSE,
    stringsAsFactors = FALSE
  )
  
  week_metrics <- full_week_template |>
    dplyr::left_join(week_metrics_raw, by = c("season", "week")) |>
    dplyr::mutate(
      n = dplyr::coalesce(suppressWarnings(as.integer(.data$n)), 0L),
      spearman = suppressWarnings(as.numeric(.data$spearman)),
      predicts_week = .data$week + 1L,
      is_scorable = as.integer(.data$n > 1 & is.finite(.data$spearman))
    ) |>
    dplyr::arrange(.data$season, .data$week)
  
  summary_out <- week_metrics |>
    dplyr::group_by(.data$season) |>
    dplyr::summarise(
      weeks_total = dplyr::n(),
      weeks = sum(.data$is_scorable, na.rm = TRUE),
      scorable_weeks = sum(.data$is_scorable, na.rm = TRUE),
      avg_spearman = if (sum(.data$is_scorable, na.rm = TRUE) > 0) {
        mean(.data$spearman[.data$is_scorable == 1L], na.rm = TRUE)
      } else {
        NA_real_
      },
      median_spearman = if (sum(.data$is_scorable, na.rm = TRUE) > 0) {
        stats::median(.data$spearman[.data$is_scorable == 1L], na.rm = TRUE)
      } else {
        NA_real_
      },
      min_spearman = if (sum(.data$is_scorable, na.rm = TRUE) > 0) {
        min(.data$spearman[.data$is_scorable == 1L], na.rm = TRUE)
      } else {
        NA_real_
      },
      max_spearman = if (sum(.data$is_scorable, na.rm = TRUE) > 0) {
        max(.data$spearman[.data$is_scorable == 1L], na.rm = TRUE)
      } else {
        NA_real_
      },
      weeks_over_0 = sum(.data$spearman[.data$is_scorable == 1L] > 0, na.rm = TRUE),
      weeks_over_030 = sum(.data$spearman[.data$is_scorable == 1L] >= 0.30, na.rm = TRUE),
      weeks_over_040 = sum(.data$spearman[.data$is_scorable == 1L] >= 0.40, na.rm = TRUE),
      .groups = "drop"
    ) |>
    dplyr::arrange(.data$season)
  
  if (write_output) {
    utils::write.csv(
      week_metrics,
      file.path(model_paths$wow_output_dir, "qb_wow_board_metrics_2021_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    utils::write.csv(
      summary_out,
      file.path(model_paths$wow_output_dir, "qb_wow_board_summary_2021_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    week_metrics = week_metrics,
    summary = summary_out
  )
}

build_qb_wow_final_export_fixed <- function(qb_wow_board, write_output = TRUE) {
  load_model_core_packages()
  
  out <- qb_wow_board |>
    dplyr::transmute(
      season = .data$season,
      week = .data$week,
      rank = .data$qb_wow_rank,
      tier = .data$qb_wow_tier,
      player = .data$player,
      team = .data$team,
      opponent = .data$opponent,
      depth_team = .data$depth_team,
      report_status = .data$report_status,
      practice_status = .data$practice_status,
      final_score = .data$qb_wow_final_score,
      weekly_board_score = .data$qb_weekly_board_score,
      in_season_omfg = .data$qb_in_season_omfg_score,
      anchor_fp = .data$qb_wow_anchor_fp,
      passing_form = .data$passing_form_component_0to100,
      role_security = .data$role_security_component_0to100,
      recent_form = .data$recent_form_component_0to100,
      rushing_form = .data$rushing_form_component_0to100,
      injury_status = .data$injury_status_component_0to100,
      actual_week_fp = .data$target_week_fp
    ) |>
    dplyr::arrange(.data$season, .data$week, .data$rank)
  
  if (write_output) {
    utils::write.csv(
      out,
      file.path(model_paths$wow_output_dir, "qb_wow_final_export_2021_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

run_qb_wow_board_rebuild <- function(write_output = TRUE) {
  load_model_core_packages()
  
  qb_wow_board <- build_qb_wow_production_board_fixed(write_output = write_output)
  qb_wow_board_summary <- build_qb_wow_board_summary_fixed(qb_wow_board, write_output = write_output)
  qb_wow_final_export <- build_qb_wow_final_export_fixed(qb_wow_board, write_output = write_output)
  
  list(
    board = qb_wow_board,
    board_summary = qb_wow_board_summary,
    final_export = qb_wow_final_export
  )
}

rb_wow_handoff <- get_handoff_spec("RB", "week_over_week")

rb_half_ppr_points_formula <- function(rush_yards, receptions, receiving_yards, total_td) {
  rush_yards <- safe_numeric(rush_yards)
  receptions <- safe_numeric(receptions)
  receiving_yards <- safe_numeric(receiving_yards)
  total_td <- safe_numeric(total_td)
  
  rush_yards[!is.finite(rush_yards)] <- 0
  receptions[!is.finite(receptions)] <- 0
  receiving_yards[!is.finite(receiving_yards)] <- 0
  total_td[!is.finite(total_td)] <- 0
  
  rush_yards / 10 +
    receptions * 0.5 +
    receiving_yards / 10 +
    total_td * 6
}

build_rb_clean_weekly_master <- function(write_output = FALSE, output_dir = model_paths$foundation_output_dir) {
  load_model_core_packages()
  
  rb_raw <- load_all_positions_hybrid() |>
    augment_model_spine() |>
    dplyr::filter(.data$POS %in% c("RB", "FB"))
  
  rb_weekly <- rb_raw |>
    dplyr::transmute(
      season = .data$season,
      week = .data$week,
      game_number = .data$game_number,
      player = .data$player_name,
      player_key = .data$player_key,
      team = .data$team,
      opponent = .data$opponent_team,
      position = .data$position,
      depth_team = .data$depth_team_num,
      draft_day = pick_first_existing_character(rb_raw, c("Draft_Day")),
      report_status = pick_first_existing_character(rb_raw, c("report_status")),
      practice_primary_injury = pick_first_existing_character(rb_raw, c("practice_primary_injury")),
      practice_secondary_injury = pick_first_existing_character(rb_raw, c("practice_secondary_injury")),
      practice_status = pick_first_existing_character(rb_raw, c("practice_status")),
      birth_date = pick_first_existing_character(rb_raw, c("birth_date")),
      rookie_year = .data$rookie_year_num,
      age = .data$age_num,
      rush_attempts = pick_first_existing_numeric(rb_raw, c("CAR", "CAR_ply")),
      rush_yards = pick_first_existing_numeric(rb_raw, c("YDS_rush", "YDS_rush_ply")),
      rush_td = pick_first_existing_numeric(rb_raw, c("TD_rush", "TD_rush_ply")),
      targets_primary = pick_first_existing_numeric(rb_raw, c("TGT_ply")),
      targets_fallback = pick_first_existing_numeric(rb_raw, c("TGT")),
      receptions = pick_first_existing_numeric(rb_raw, c("REC", "REC_ply")),
      receiving_yards = pick_first_existing_numeric(rb_raw, c("YDS", "YDS_ply")),
      receiving_td = pick_first_existing_numeric(rb_raw, c("TD", "TD_ply")),
      routes = pick_first_existing_numeric(rb_raw, c("RTE", "RTE_ply")),
      inside5_carries = pick_first_existing_numeric(rb_raw, c("i5_CAR", "i5_CAR_ply", "i5")),
      fantasy_points_source = dplyr::coalesce(
        pick_first_existing_numeric(rb_raw, c("fantasyPts")),
        pick_first_existing_numeric(rb_raw, c("FP_G", "FP_G_ply", "FP_G_rush"))
      ),
      source_file = pick_first_existing_character(rb_raw, c("dataset_file"))
    ) |>
    dplyr::filter(!is.na(.data$season), !is.na(.data$week), .data$week >= 1, .data$week <= 18) |>
    dplyr::mutate(
      team = normalize_team_abbr(.data$team),
      opponent = normalize_team_abbr(.data$opponent),
      targets = dplyr::if_else(
        !is.na(.data$targets_primary) & .data$targets_primary > 0,
        .data$targets_primary,
        dplyr::coalesce(.data$targets_fallback, 0)
      ),
      total_td = dplyr::coalesce(.data$rush_td, 0) + dplyr::coalesce(.data$receiving_td, 0),
      scrimmage_yards = dplyr::coalesce(.data$rush_yards, 0) + dplyr::coalesce(.data$receiving_yards, 0),
      opportunities = dplyr::coalesce(.data$rush_attempts, 0) + dplyr::coalesce(.data$targets, 0),
      half_ppr_points = rb_half_ppr_points_formula(
        .data$rush_yards,
        .data$receptions,
        .data$receiving_yards,
        .data$total_td
      ),
      fantasy_points_calc = dplyr::coalesce(.data$half_ppr_points, .data$fantasy_points_source),
      rb_model_eligible = .data$position == "RB",
      regular_season_flag = TRUE
    ) |>
    dplyr::select(-dplyr::any_of(c("targets_primary", "targets_fallback"))) |>
    dplyr::arrange(.data$season, .data$week, .data$team, .data$player)
  
  duplicate_keys <- rb_weekly |>
    dplyr::count(.data$season, .data$week, .data$player_key, name = "dup_n") |>
    dplyr::filter(.data$dup_n > 1)
  
  if (nrow(duplicate_keys) > 0) {
    rb_conflict_cols <- c(
      "team", "position", "rush_attempts", "rush_yards", "rush_td", "targets",
      "receptions", "receiving_yards", "receiving_td", "total_td", "half_ppr_points"
    )
    conflicting_keys <- rb_weekly |>
      dplyr::semi_join(duplicate_keys, by = c("season", "week", "player_key")) |>
      dplyr::group_by(.data$season, .data$week, .data$player_key) |>
      dplyr::summarise(
        dplyr::across(
          dplyr::all_of(rb_conflict_cols),
          ~ dplyr::n_distinct(.x[!is.na(.x)]),
          .names = "distinct_{.col}"
        ),
        .groups = "drop"
      ) |>
      dplyr::filter(dplyr::if_any(dplyr::starts_with("distinct_"), ~ .x > 1L))
    
    if (nrow(conflicting_keys) > 0) {
      stop(
        paste0(
          "RB clean weekly master has ", nrow(conflicting_keys),
          " conflicting player-week duplicates; inspect the hybrid source before modeling."
        ),
        call. = FALSE
      )
    }
  }
  
  rb_quality_cols <- c(
    "rush_attempts", "rush_yards", "rush_td", "targets", "receptions",
    "receiving_yards", "receiving_td", "total_td", "half_ppr_points",
    "depth_team", "opponent"
  )
  rb_weekly$.rb_row_completeness <- rowSums(!is.na(rb_weekly[rb_quality_cols]))
  rb_weekly <- rb_weekly |>
    dplyr::arrange(
      .data$season, .data$week, .data$player_key,
      dplyr::desc(.data$.rb_row_completeness),
      dplyr::desc(!is.na(.data$source_file))
    ) |>
    dplyr::distinct(.data$season, .data$week, .data$player_key, .keep_all = TRUE) |>
    dplyr::select(-dplyr::all_of(".rb_row_completeness"))
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      rb_weekly,
      file.path(output_dir, "rb_clean_weekly_master_2021_2025_regular.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  rb_weekly
}

build_rb_team_week_opportunity_table <- function(rb_weekly = build_rb_clean_weekly_master(), write_output = FALSE, output_dir = model_paths$foundation_output_dir) {
  load_model_core_packages()
  
  out <- rb_weekly |>
    dplyr::group_by(.data$season, .data$week, .data$team) |>
    dplyr::summarise(
      team_rbfb_rush_attempts = sum(.data$rush_attempts, na.rm = TRUE),
      team_rbfb_targets = sum(.data$targets, na.rm = TRUE),
      team_rbfb_opportunities = sum(.data$opportunities, na.rm = TRUE),
      team_rbfb_routes = sum(.data$routes, na.rm = TRUE),
      team_rbfb_half_ppr = sum(.data$half_ppr_points, na.rm = TRUE),
      .groups = "drop"
    )
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "rb_team_week_opportunity_2021_2025_regular.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_rb_player_share_table <- function(
    rb_weekly = build_rb_clean_weekly_master(),
    team_week = build_rb_team_week_opportunity_table(rb_weekly),
    write_output = FALSE,
    output_dir = model_paths$foundation_output_dir
) {
  load_model_core_packages()
  
  out <- rb_weekly |>
    dplyr::left_join(team_week, by = c("season", "week", "team")) |>
    dplyr::mutate(
      team_carry_share = safe_div(.data$rush_attempts, .data$team_rbfb_rush_attempts),
      team_target_share = safe_div(.data$targets, .data$team_rbfb_targets),
      team_opportunity_share = safe_div(.data$opportunities, .data$team_rbfb_opportunities),
      team_route_share = safe_div(.data$routes, .data$team_rbfb_routes),
      team_fantasy_share = safe_div(.data$half_ppr_points, .data$team_rbfb_half_ppr),
      starter_flag = dplyr::if_else(!is.na(.data$depth_team) & .data$depth_team <= 1, 1L, 0L)
    )
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "rb_player_share_table_2021_2025_regular.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_rb_weekly_feature_base <- function(write_output = FALSE, output_dir = model_paths$wow_output_dir) {
  load_model_core_packages()
  
  rb_share <- build_rb_player_share_table(write_output = FALSE)
  
  out <- rb_share |>
    dplyr::filter(.data$rb_model_eligible) |>
    dplyr::arrange(.data$player_key, .data$season, .data$week) |>
    dplyr::group_by(.data$player_key, .data$season) |>
    dplyr::mutate(
      feature_week = .data$week,
      next_week = .data$week + 1L,
      next_week_fantasy_points = dplyr::lead(.data$half_ppr_points),
      next_week_opportunities = dplyr::lead(.data$opportunities),
      next_week_rush_attempts = dplyr::lead(.data$rush_attempts),
      next_week_targets = dplyr::lead(.data$targets),
      next_week_routes = dplyr::lead(.data$routes),
      next_week_scrimmage_yards = dplyr::lead(.data$scrimmage_yards),
      next_week_total_td = dplyr::lead(.data$total_td),
      games_played_to_date = dplyr::row_number(),
      season_to_date_fantasy_points = cumsum(dplyr::coalesce(.data$half_ppr_points, 0)),
      season_to_date_fantasy_points_per_game = season_to_date_fantasy_points / games_played_to_date,
      season_to_date_opportunities_per_game = cumsum(dplyr::coalesce(.data$opportunities, 0)) / games_played_to_date,
      season_to_date_targets_per_game = cumsum(dplyr::coalesce(.data$targets, 0)) / games_played_to_date,
      season_to_date_routes_per_game = cumsum(dplyr::coalesce(.data$routes, 0)) / games_played_to_date,
      season_to_date_scrimmage_yards_per_game = cumsum(dplyr::coalesce(.data$scrimmage_yards, 0)) / games_played_to_date,
      rolling3_fantasy_points = rolling_mean_vec(.data$half_ppr_points, 3),
      rolling5_fantasy_points = rolling_mean_vec(.data$half_ppr_points, 5),
      rolling3_opportunities = rolling_mean_vec(.data$opportunities, 3),
      rolling5_opportunities = rolling_mean_vec(.data$opportunities, 5),
      rolling3_carries = rolling_mean_vec(.data$rush_attempts, 3),
      rolling5_carries = rolling_mean_vec(.data$rush_attempts, 5),
      rolling3_targets = rolling_mean_vec(.data$targets, 3),
      rolling5_targets = rolling_mean_vec(.data$targets, 5),
      rolling3_routes = rolling_mean_vec(.data$routes, 3),
      rolling5_routes = rolling_mean_vec(.data$routes, 5),
      rolling3_scrimmage_yards = rolling_mean_vec(.data$scrimmage_yards, 3),
      rolling5_scrimmage_yards = rolling_mean_vec(.data$scrimmage_yards, 5),
      rolling3_total_td = rolling_mean_vec(.data$total_td, 3),
      rolling5_total_td = rolling_mean_vec(.data$total_td, 5),
      rolling3_team_opp_share = rolling_mean_vec(.data$team_opportunity_share, 3),
      rolling5_team_opp_share = rolling_mean_vec(.data$team_opportunity_share, 5),
      rolling3_team_carry_share = rolling_mean_vec(.data$team_carry_share, 3),
      rolling5_team_carry_share = rolling_mean_vec(.data$team_carry_share, 5),
      rolling3_team_target_share = rolling_mean_vec(.data$team_target_share, 3),
      rolling5_team_target_share = rolling_mean_vec(.data$team_target_share, 5),
      rolling3_team_route_share = rolling_mean_vec(.data$team_route_share, 3),
      rolling5_team_route_share = rolling_mean_vec(.data$team_route_share, 5),
      rolling5_fantasy_points_sd = rolling_sd_vec(.data$half_ppr_points, 5),
      rolling5_opportunities_sd = rolling_sd_vec(.data$opportunities, 5),
      rolling5_routes_sd = rolling_sd_vec(.data$routes, 5),
      recent_8plus_opp_flag = as.numeric(dplyr::coalesce(.data$opportunities, 0) >= 8),
      games_with_8plus_opp_recent_rate = rolling_mean_vec(.data$recent_8plus_opp_flag, 5),
      trend_fantasy_points_3v5 = rolling3_fantasy_points - rolling5_fantasy_points,
      trend_opportunities_3v5 = rolling3_opportunities - rolling5_opportunities,
      trend_carries_3v5 = rolling3_carries - rolling5_carries,
      trend_targets_3v5 = rolling3_targets - rolling5_targets,
      trend_routes_3v5 = rolling3_routes - rolling5_routes,
      season_week = .data$week,
      depth_order_current = .data$depth_team,
      committee_pressure_flag = dplyr::if_else(dplyr::coalesce(.data$rolling5_team_opp_share, 0) < 0.55, 1L, 0L),
      target_week_fp = .data$next_week_fantasy_points
    ) |>
    dplyr::ungroup()
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "rb_weekly_feature_base_2021_2025_regular.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_rb_wow_inputs <- function(write_output = FALSE) {
  load_model_core_packages()
  
  rb_weekly_feature_base <- build_rb_weekly_feature_base(write_output = write_output)
  
  out <- list(
    position = "RB",
    mode = "week_over_week",
    handoff = rb_wow_handoff,
    handoff_text = read_text_from_handoff(rb_wow_handoff),
    weekly_base = build_wow_weekly_base("RB"),
    rb_weekly_feature_base = rb_weekly_feature_base,
    next_steps = c(
      "Convert the RB weekly feature base into explicit week-ahead training snapshots.",
      "Add role-state, injury replacement, committee pressure, and matchup context outside official OMFG.",
      "Build next-week RB projection, range, and weekly review-flag logic from the handoff."
    )
  )
  
  if (write_output) {
    out$output_paths <- c(
      rb_weekly_base = write_wow_weekly_base("RB"),
      rb_weekly_feature_base = file.path(model_paths$wow_output_dir, "rb_weekly_feature_base_2021_2025_regular.csv")
    )
  }
  
  out
}

make_rb_wow_output_manifest <- function(rb_wow_result) {
  output_paths <- unname(rb_wow_result$output_paths %||% character())
  output_labels <- names(rb_wow_result$output_paths %||% character())
  
  data.frame(
    output_name = output_labels,
    output_path = output_paths,
    exists = file.exists(output_paths),
    stringsAsFactors = FALSE
  )
}

run_rb_wow_pipeline <- function(write_output = TRUE) {
  load_model_core_packages()
  
  dir.create(model_paths$wow_output_dir, recursive = TRUE, showWarnings = FALSE)
  
  rb_wow_result <- build_rb_wow_inputs(write_output = write_output)
  rb_wow_board_rebuild <- run_rb_wow_board_rebuild(write_output = write_output)
  
  output_paths <- c(
    rb_wow_result$output_paths %||% character(),
    rb_wow_feature_overlay = file.path(model_paths$wow_output_dir, "rb_wow_feature_overlay_2021_2025.csv"),
    rb_wow_board_metrics = file.path(model_paths$wow_output_dir, "rb_wow_board_metrics_2021_2025.csv"),
    rb_wow_board_summary = file.path(model_paths$wow_output_dir, "rb_wow_board_summary_2021_2025.csv"),
    rb_wow_final_export = file.path(model_paths$wow_output_dir, "rb_wow_final_export_2021_2025.csv")
  )
  
  rb_wow_result$output_paths <- output_paths
  output_manifest <- make_rb_wow_output_manifest(rb_wow_result)
  
  list(
    result = rb_wow_result,
    board = rb_wow_board_rebuild$board,
    board_summary = rb_wow_board_rebuild$board_summary,
    final_export = rb_wow_board_rebuild$final_export,
    output_manifest = output_manifest
  )
}

rb_wow_age_window_score <- function(age_vec) {
  age_vec <- safe_numeric(age_vec)
  out <- 100 - pmin(abs(age_vec - 25) * 9, 100)
  out[!is.finite(age_vec)] <- NA_real_
  out
}

rb_wow_centered_rank <- function(x, higher_is_better = TRUE) {
  (qb_wow_percent_rank_0to100(x, higher_is_better = higher_is_better) - 50) / 50
}

build_rb_prior_season_week1_summary <- function(rb_wow_feature_base) {
  load_model_core_packages()
  
  season_summary <- rb_wow_feature_base |>
    dplyr::mutate(
      player_key = as.character(.data$player_key),
      season = suppressWarnings(as.integer(.data$season)),
      half_ppr_points = suppressWarnings(as.numeric(.data$half_ppr_points)),
      opportunities = suppressWarnings(as.numeric(.data$opportunities)),
      targets = suppressWarnings(as.numeric(.data$targets)),
      routes = suppressWarnings(as.numeric(.data$routes)),
      scrimmage_yards = suppressWarnings(as.numeric(.data$scrimmage_yards)),
      total_td = suppressWarnings(as.numeric(.data$total_td))
    ) |>
    dplyr::group_by(.data$player_key, .data$season) |>
    dplyr::summarise(
      season_games = sum(is.finite(.data$half_ppr_points)),
      season_ppg = ifelse(season_games > 0, mean(.data$half_ppr_points, na.rm = TRUE), NA_real_),
      season_total_fp = sum(.data$half_ppr_points, na.rm = TRUE),
      season_opportunities_pg = ifelse(season_games > 0, mean(.data$opportunities, na.rm = TRUE), NA_real_),
      season_targets_pg = ifelse(season_games > 0, mean(.data$targets, na.rm = TRUE), NA_real_),
      season_routes_pg = ifelse(season_games > 0, mean(.data$routes, na.rm = TRUE), NA_real_),
      season_scrimmage_yards_pg = ifelse(season_games > 0, mean(.data$scrimmage_yards, na.rm = TRUE), NA_real_),
      season_total_td_pg = ifelse(season_games > 0, mean(.data$total_td, na.rm = TRUE), NA_real_),
      .groups = "drop"
    )
  
  prior_summary <- season_summary |>
    dplyr::transmute(
      player_key = .data$player_key,
      season = .data$season + 1L,
      prior_season_games = .data$season_games,
      prior_season_ppg = .data$season_ppg,
      prior_season_total_fp = .data$season_total_fp,
      prior_season_opportunities_pg = .data$season_opportunities_pg,
      prior_season_targets_pg = .data$season_targets_pg,
      prior_season_routes_pg = .data$season_routes_pg,
      prior_season_scrimmage_yards_pg = .data$season_scrimmage_yards_pg,
      prior_season_total_td_pg = .data$season_total_td_pg
    )
  
  target_rows <- season_summary |>
    dplyr::distinct(.data$player_key, .data$season)
  
  career_summary <- lapply(seq_len(nrow(target_rows)), function(i) {
    player_key_i <- target_rows$player_key[[i]]
    season_i <- target_rows$season[[i]]
    
    hist <- season_summary |>
      dplyr::filter(.data$player_key == player_key_i, .data$season < season_i, .data$season_games > 0)
    
    if (nrow(hist) == 0) {
      return(data.frame(
        player_key = player_key_i,
        season = season_i,
        career_games = NA_real_,
        career_seasons = NA_real_,
        career_ppg = NA_real_,
        career_total_fp = NA_real_,
        career_opportunities_pg = NA_real_,
        career_targets_pg = NA_real_,
        career_routes_pg = NA_real_,
        career_scrimmage_yards_pg = NA_real_,
        career_total_td_pg = NA_real_,
        last_active_season = NA_real_,
        years_since_last_active = NA_real_,
        stringsAsFactors = FALSE
      ))
    }
    
    total_games <- sum(hist$season_games, na.rm = TRUE)
    total_fp <- sum(hist$season_total_fp, na.rm = TRUE)
    last_active <- max(hist$season, na.rm = TRUE)
    
    data.frame(
      player_key = player_key_i,
      season = season_i,
      career_games = total_games,
      career_seasons = nrow(hist),
      career_ppg = ifelse(total_games > 0, total_fp / total_games, NA_real_),
      career_total_fp = total_fp,
      career_opportunities_pg = stats::weighted.mean(hist$season_opportunities_pg, w = pmax(hist$season_games, 1), na.rm = TRUE),
      career_targets_pg = stats::weighted.mean(hist$season_targets_pg, w = pmax(hist$season_games, 1), na.rm = TRUE),
      career_routes_pg = stats::weighted.mean(hist$season_routes_pg, w = pmax(hist$season_games, 1), na.rm = TRUE),
      career_scrimmage_yards_pg = stats::weighted.mean(hist$season_scrimmage_yards_pg, w = pmax(hist$season_games, 1), na.rm = TRUE),
      career_total_td_pg = stats::weighted.mean(hist$season_total_td_pg, w = pmax(hist$season_games, 1), na.rm = TRUE),
      last_active_season = last_active,
      years_since_last_active = season_i - last_active,
      stringsAsFactors = FALSE
    )
  }) |>
    dplyr::bind_rows()
  
  target_rows |>
    dplyr::left_join(prior_summary, by = c("player_key", "season")) |>
    dplyr::left_join(career_summary, by = c("player_key", "season"))
}

build_rb_wow_defense_context <- function(rb_wow_feature_base) {
  load_model_core_packages()
  
  rb_wow_feature_base |>
    dplyr::group_by(season, week, defense_team = opponent) |>
    dplyr::summarise(
      rb_fp_allowed = sum(.data$half_ppr_points, na.rm = TRUE),
      rb_opp_allowed = sum(.data$opportunities, na.rm = TRUE),
      rb_targets_allowed = sum(.data$targets, na.rm = TRUE),
      rb_routes_allowed = sum(.data$routes, na.rm = TRUE),
      .groups = "drop"
    ) |>
    dplyr::arrange(.data$defense_team, .data$season, .data$week) |>
    dplyr::group_by(.data$defense_team, .data$season) |>
    dplyr::mutate(
      trailing3_rb_fp_allowed = dplyr::lag(rolling_mean_vec(.data$rb_fp_allowed, 3)),
      trailing5_rb_fp_allowed = dplyr::lag(rolling_mean_vec(.data$rb_fp_allowed, 5)),
      trailing5_rb_opp_allowed = dplyr::lag(rolling_mean_vec(.data$rb_opp_allowed, 5)),
      trailing5_rb_targets_allowed = dplyr::lag(rolling_mean_vec(.data$rb_targets_allowed, 5)),
      trailing5_rb_routes_allowed = dplyr::lag(rolling_mean_vec(.data$rb_routes_allowed, 5))
    ) |>
    dplyr::ungroup()
}

build_rb_wow_feature_overlay_table <- function(rb_wow_feature_base = NULL, write_output = TRUE, output_dir = model_paths$wow_output_dir) {
  load_model_core_packages()
  
  if (is.null(rb_wow_feature_base)) {
    rb_wow_feature_base <- build_rb_weekly_feature_base(write_output = FALSE)
  }
  
  rb_prior_season_summary <- build_rb_prior_season_week1_summary(rb_wow_feature_base)
  rb_defense_context <- build_rb_wow_defense_context(rb_wow_feature_base)
  
  out <- rb_wow_feature_base |>
    dplyr::left_join(rb_prior_season_summary, by = c("player_key", "season")) |>
    dplyr::left_join(rb_defense_context, by = c("season", "week", "opponent" = "defense_team")) |>
    dplyr::mutate(
      season = suppressWarnings(as.integer(.data$season)),
      week = suppressWarnings(as.integer(.data$week)),
      depth_team = suppressWarnings(as.numeric(.data$depth_team)),
      age = suppressWarnings(as.numeric(.data$age)),
      rookie_year = suppressWarnings(as.numeric(.data$rookie_year)),
      target_week_fp = suppressWarnings(as.numeric(.data$target_week_fp)),
      rb_wow_anchor_fp = dplyr::coalesce(
        safe_numeric(.data$season_to_date_fantasy_points_per_game),
        safe_numeric(.data$rolling3_fantasy_points),
        safe_numeric(.data$rolling5_fantasy_points),
        safe_numeric(.data$half_ppr_points)
      ),
      preseason_weight = dplyr::case_when(
        .data$week <= 1L ~ 0.65,
        .data$week == 2L ~ 0.50,
        .data$week == 3L ~ 0.40,
        .data$week == 4L ~ 0.30,
        .data$week == 5L ~ 0.20,
        TRUE ~ 0.15
      ),
      has_prior_season_stats = is.finite(.data$prior_season_ppg) & .data$prior_season_games >= 4,
      has_career_stats = is.finite(.data$career_ppg) & .data$career_games >= 4,
      is_true_rookie = is.finite(.data$rookie_year) & .data$rookie_year >= .data$season,
      draft_day_score_0to100 = qb_draft_day_score_0to100(.data$draft_day),
      td_share_context = safe_div(.data$rolling5_total_td, .data$rolling5_opportunities)
    ) |>
    dplyr::group_by(.data$season, .data$week) |>
    dplyr::mutate(
      wow_anchor_rank_component = qb_wow_percent_rank_0to100(.data$rb_wow_anchor_fp),
      prior_season_production_score = qb_wow_row_mean(
        qb_wow_percent_rank_0to100(.data$prior_season_ppg),
        qb_wow_percent_rank_0to100(.data$prior_season_total_fp),
        qb_wow_percent_rank_0to100(.data$prior_season_opportunities_pg),
        qb_wow_percent_rank_0to100(.data$prior_season_targets_pg),
        qb_wow_percent_rank_0to100(.data$prior_season_routes_pg),
        qb_wow_percent_rank_0to100(.data$prior_season_scrimmage_yards_pg),
        qb_wow_percent_rank_0to100(.data$prior_season_total_td_pg)
      ),
      career_production_score = qb_wow_row_mean(
        qb_wow_percent_rank_0to100(.data$career_ppg),
        qb_wow_percent_rank_0to100(.data$career_total_fp),
        qb_wow_percent_rank_0to100(.data$career_opportunities_pg),
        qb_wow_percent_rank_0to100(.data$career_targets_pg),
        qb_wow_percent_rank_0to100(.data$career_routes_pg),
        qb_wow_percent_rank_0to100(.data$career_scrimmage_yards_pg),
        qb_wow_percent_rank_0to100(.data$career_total_td_pg)
      ),
      current_production_score = (
        0.45 * qb_wow_percent_rank_0to100(.data$rolling5_fantasy_points) +
          0.30 * qb_wow_percent_rank_0to100(.data$rolling3_fantasy_points) +
          0.25 * qb_wow_percent_rank_0to100(.data$season_to_date_fantasy_points_per_game)
      ),
      current_opportunity_score = (
        0.35 * qb_wow_percent_rank_0to100(.data$rolling5_opportunities) +
          0.25 * qb_wow_percent_rank_0to100(.data$rolling3_opportunities) +
          0.20 * qb_wow_percent_rank_0to100(.data$rolling5_team_opp_share) +
          0.10 * qb_wow_percent_rank_0to100(.data$rolling5_carries) +
          0.10 * qb_wow_percent_rank_0to100(.data$rolling5_targets)
      ),
      current_receiving_score = (
        0.35 * qb_wow_percent_rank_0to100(.data$rolling5_targets) +
          0.25 * qb_wow_percent_rank_0to100(.data$rolling5_team_target_share) +
          0.20 * qb_wow_percent_rank_0to100(.data$rolling5_routes) +
          0.20 * qb_wow_percent_rank_0to100(.data$rolling5_team_route_share)
      ),
      current_predictability_score = (
        0.35 * qb_wow_percent_rank_0to100(.data$rolling5_opportunities_sd, higher_is_better = FALSE) +
          0.25 * qb_wow_percent_rank_0to100(.data$rolling5_fantasy_points_sd, higher_is_better = FALSE) +
          0.20 * qb_wow_percent_rank_0to100(.data$rolling5_routes_sd, higher_is_better = FALSE) +
          0.20 * qb_wow_percent_rank_0to100(.data$games_with_8plus_opp_recent_rate)
      ),
      current_momentum_score = (
        0.30 * qb_wow_percent_rank_0to100(.data$trend_opportunities_3v5) +
          0.25 * qb_wow_percent_rank_0to100(.data$trend_routes_3v5) +
          0.20 * qb_wow_percent_rank_0to100(.data$trend_targets_3v5) +
          0.15 * qb_wow_percent_rank_0to100(.data$trend_carries_3v5) +
          0.10 * qb_wow_percent_rank_0to100(.data$trend_fantasy_points_3v5)
      ),
      current_td_context_score = (
        0.45 * qb_wow_percent_rank_0to100(.data$rolling5_total_td) +
          0.30 * qb_wow_percent_rank_0to100(.data$rolling5_team_opp_share) +
          0.25 * qb_wow_percent_rank_0to100(.data$td_share_context)
      ),
      age_development_score = qb_wow_row_mean(
        rb_wow_age_window_score(.data$age),
        qb_wow_percent_rank_0to100(.data$games_played_to_date),
        qb_wow_percent_rank_0to100(.data$depth_order_current, higher_is_better = FALSE)
      ),
      role_security_component_0to100 = qb_wow_row_mean(
        qb_wow_percent_rank_0to100(.data$rolling5_team_opp_share),
        qb_wow_percent_rank_0to100(.data$rolling5_carries),
        qb_wow_percent_rank_0to100(.data$rolling5_targets),
        qb_wow_percent_rank_0to100(.data$depth_order_current, higher_is_better = FALSE)
      ),
      inseason_omfg_component = (
        0.36 * .data$current_production_score +
          0.24 * .data$current_opportunity_score +
          0.13 * .data$current_receiving_score +
          0.10 * .data$current_predictability_score +
          0.10 * .data$current_momentum_score +
          0.04 * .data$current_td_context_score +
          0.03 * .data$age_development_score
      ),
      preseason_anchor_score_raw = dplyr::case_when(
        .data$has_prior_season_stats ~
          0.45 * dplyr::coalesce(.data$prior_season_production_score, 0) +
          0.20 * dplyr::coalesce(.data$career_production_score, 0) +
          0.15 * dplyr::coalesce(.data$wow_anchor_rank_component, 0) +
          0.10 * dplyr::coalesce(.data$role_security_component_0to100, 0) +
          0.10 * dplyr::coalesce(.data$draft_day_score_0to100, 50),
        .data$has_career_stats ~
          0.55 * dplyr::coalesce(.data$career_production_score, 0) +
          0.15 * dplyr::coalesce(.data$wow_anchor_rank_component, 0) +
          0.15 * dplyr::coalesce(.data$role_security_component_0to100, 0) +
          0.15 * dplyr::coalesce(.data$draft_day_score_0to100, 50),
        TRUE ~
          0.40 * dplyr::coalesce(.data$wow_anchor_rank_component, 50) +
          0.30 * dplyr::coalesce(.data$role_security_component_0to100, 50) +
          0.30 * dplyr::coalesce(.data$draft_day_score_0to100, 50)
      ),
      preseason_anchor_score = dplyr::if_else(.data$is_true_rookie, pmin(.data$preseason_anchor_score_raw, 78), .data$preseason_anchor_score_raw),
      rb_in_season_omfg_score = pmin(100, pmax(0,
                                               dplyr::if_else(
                                                 .data$week == 1L,
                                                 .data$preseason_anchor_score,
                                                 .data$preseason_weight * .data$preseason_anchor_score + (1 - .data$preseason_weight) * .data$inseason_omfg_component
                                               )
      )),
      omfg_delta_from_preseason = .data$rb_in_season_omfg_score - .data$preseason_anchor_score,
      omfg_trend_3w = .data$rb_in_season_omfg_score - dplyr::lag(.data$rb_in_season_omfg_score, 3),
      role_trend_score_raw =
        0.35 * dplyr::coalesce(.data$trend_opportunities_3v5, 0) +
        0.25 * dplyr::coalesce(.data$trend_routes_3v5, 0) +
        0.25 * dplyr::coalesce(.data$trend_targets_3v5, 0) +
        0.15 * dplyr::coalesce(.data$trend_carries_3v5, 0),
      role_stability_score_raw =
        -0.30 * dplyr::coalesce(.data$rolling5_opportunities_sd, 0) +
        -0.25 * dplyr::coalesce(.data$rolling5_routes_sd, 0) +
        -0.20 * dplyr::coalesce(.data$rolling5_fantasy_points_sd, 0) +
        0.25 * dplyr::coalesce(.data$games_with_8plus_opp_recent_rate, 0),
      role_trend_score = qb_wow_percent_rank_0to100(.data$role_trend_score_raw),
      role_stability_score = qb_wow_percent_rank_0to100(.data$role_stability_score_raw),
      ros_role_modifier = pmin(1.25, pmax(0.75,
                                          1 +
                                            rb_wow_centered_rank(.data$omfg_delta_from_preseason) * 0.06 +
                                            rb_wow_centered_rank(.data$omfg_trend_3w) * 0.04 +
                                            rb_wow_centered_rank(.data$role_trend_score) * 0.04 +
                                            rb_wow_centered_rank(.data$role_stability_score) * 0.03
      )),
      base_projection_seed = dplyr::coalesce(
        0.45 * .data$season_to_date_fantasy_points_per_game +
          0.35 * .data$rolling3_fantasy_points +
          0.20 * .data$rolling5_fantasy_points,
        .data$season_to_date_fantasy_points_per_game,
        .data$rolling3_fantasy_points,
        .data$rolling5_fantasy_points,
        safe_numeric(.data$half_ppr_points)
      ),
      weekly_projected_fp_before_matchup = .data$base_projection_seed *
        .data$ros_role_modifier *
        pmin(1.18, pmax(0.88,
                        1 +
                          rb_wow_centered_rank(.data$current_opportunity_score) * 0.10 +
                          rb_wow_centered_rank(.data$current_receiving_score) * 0.05
        )),
      rb_matchup_ease_score = qb_wow_row_mean(
        qb_wow_percent_rank_0to100(.data$trailing5_rb_fp_allowed),
        qb_wow_percent_rank_0to100(.data$trailing5_rb_opp_allowed),
        qb_wow_percent_rank_0to100(.data$trailing5_rb_targets_allowed),
        qb_wow_percent_rank_0to100(.data$trailing5_rb_routes_allowed)
      ),
      defense_matchup_multiplier = pmin(1.08, pmax(0.92, 1 + rb_wow_centered_rank(.data$rb_matchup_ease_score) * 0.08)),
      weekly_projected_fp_after_matchup = .data$weekly_projected_fp_before_matchup * dplyr::coalesce(.data$defense_matchup_multiplier, 1),
      weekly_projected_fp_rank_component = qb_wow_percent_rank_0to100(.data$weekly_projected_fp_after_matchup),
      injury_replacement_flag = as.integer(
        !is.na(.data$report_status) &
          !(.data$report_status %in% c("Active", "Healthy"))
      ),
      rb_weekly_board_score = qb_wow_row_mean(
        .data$weekly_projected_fp_rank_component,
        .data$rb_in_season_omfg_score,
        qb_wow_percent_rank_0to100(.data$rb_wow_anchor_fp),
        .data$current_opportunity_score,
        .data$role_stability_score
      ),
      rb_wow_final_score = dplyr::if_else(
        .data$week == 1L,
        .data$rb_weekly_board_score,
        (
          0.35 * dplyr::coalesce(.data$rb_weekly_board_score, 0) +
            0.25 * dplyr::coalesce(.data$rb_in_season_omfg_score, 0) +
            0.20 * dplyr::coalesce(.data$weekly_projected_fp_rank_component, 0) +
            0.10 * dplyr::coalesce(.data$current_receiving_score, 0) +
            0.10 * dplyr::coalesce(.data$role_trend_score, 0)
        ) / (
          0.35 * as.numeric(is.finite(.data$rb_weekly_board_score)) +
            0.25 * as.numeric(is.finite(.data$rb_in_season_omfg_score)) +
            0.20 * as.numeric(is.finite(.data$weekly_projected_fp_rank_component)) +
            0.10 * as.numeric(is.finite(.data$current_receiving_score)) +
            0.10 * as.numeric(is.finite(.data$role_trend_score))
        )
      )
    ) |>
    dplyr::group_by(.data$season, .data$week) |>
    dplyr::arrange(dplyr::desc(.data$rb_wow_final_score), .data$player, .by_group = TRUE) |>
    dplyr::mutate(
      rb_wow_rank = dplyr::row_number(),
      rb_wow_tier = dplyr::case_when(
        .data$rb_wow_rank <= 5 ~ "Tier 1",
        .data$rb_wow_rank <= 12 ~ "Tier 2",
        .data$rb_wow_rank <= 24 ~ "Tier 3",
        .data$rb_wow_rank <= 36 ~ "Tier 4",
        TRUE ~ "Tier 5"
      )
    ) |>
    dplyr::ungroup() |>
    dplyr::arrange(.data$season, .data$week, .data$rb_wow_rank)
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "rb_wow_feature_overlay_2021_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_rb_wow_board_summary <- function(rb_wow_board, write_output = TRUE) {
  load_model_core_packages()
  
  week_metrics <- rb_wow_board |>
    dplyr::group_by(.data$season, .data$week) |>
    dplyr::summarise(
      n = sum(is.finite(.data$rb_wow_rank) & is.finite(.data$target_week_fp)),
      spearman = {
        keep <- is.finite(.data$rb_wow_rank) & is.finite(.data$target_week_fp)
        if (sum(keep) > 1) {
          suppressWarnings(stats::cor(-.data$rb_wow_rank[keep], .data$target_week_fp[keep], method = "spearman"))
        } else {
          NA_real_
        }
      },
      .groups = "drop"
    ) |>
    dplyr::mutate(
      predicts_week = .data$week + 1L,
      is_scorable = as.integer(.data$n > 1 & is.finite(.data$spearman))
    )
  
  summary_out <- week_metrics |>
    dplyr::group_by(.data$season) |>
    dplyr::summarise(
      weeks_total = dplyr::n(),
      weeks = sum(.data$is_scorable, na.rm = TRUE),
      scorable_weeks = sum(.data$is_scorable, na.rm = TRUE),
      avg_spearman = if (sum(.data$is_scorable, na.rm = TRUE) > 0) {
        mean(.data$spearman[.data$is_scorable == 1L], na.rm = TRUE)
      } else {
        NA_real_
      },
      median_spearman = if (sum(.data$is_scorable, na.rm = TRUE) > 0) {
        stats::median(.data$spearman[.data$is_scorable == 1L], na.rm = TRUE)
      } else {
        NA_real_
      },
      min_spearman = if (sum(.data$is_scorable, na.rm = TRUE) > 0) {
        min(.data$spearman[.data$is_scorable == 1L], na.rm = TRUE)
      } else {
        NA_real_
      },
      max_spearman = if (sum(.data$is_scorable, na.rm = TRUE) > 0) {
        max(.data$spearman[.data$is_scorable == 1L], na.rm = TRUE)
      } else {
        NA_real_
      },
      weeks_over_0 = sum(.data$spearman[.data$is_scorable == 1L] > 0, na.rm = TRUE),
      weeks_over_030 = sum(.data$spearman[.data$is_scorable == 1L] >= 0.30, na.rm = TRUE),
      weeks_over_040 = sum(.data$spearman[.data$is_scorable == 1L] >= 0.40, na.rm = TRUE),
      .groups = "drop"
    ) |>
    dplyr::arrange(.data$season)
  
  if (write_output) {
    utils::write.csv(
      week_metrics,
      file.path(model_paths$wow_output_dir, "rb_wow_board_metrics_2021_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    utils::write.csv(
      summary_out,
      file.path(model_paths$wow_output_dir, "rb_wow_board_summary_2021_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    week_metrics = week_metrics,
    summary = summary_out
  )
}

build_rb_wow_final_export <- function(rb_wow_board, write_output = TRUE) {
  load_model_core_packages()
  
  out <- rb_wow_board |>
    dplyr::transmute(
      season = .data$season,
      week = .data$week,
      predicts_week = .data$week + 1L,
      rank = .data$rb_wow_rank,
      tier = .data$rb_wow_tier,
      player = .data$player,
      team = .data$team,
      opponent = .data$opponent,
      depth_team = .data$depth_team,
      report_status = .data$report_status,
      practice_status = .data$practice_status,
      final_score = .data$rb_wow_final_score,
      weekly_board_score = .data$rb_weekly_board_score,
      in_season_omfg = .data$rb_in_season_omfg_score,
      anchor_fp = .data$rb_wow_anchor_fp,
      projected_fp = .data$weekly_projected_fp_after_matchup,
      role_trend_score = .data$role_trend_score,
      role_stability_score = .data$role_stability_score,
      ros_role_modifier = .data$ros_role_modifier,
      defense_matchup_multiplier = .data$defense_matchup_multiplier,
      injury_replacement_flag = .data$injury_replacement_flag,
      actual_next_week_fp = .data$target_week_fp
    ) |>
    dplyr::arrange(.data$season, .data$week, .data$rank)
  
  if (write_output) {
    utils::write.csv(
      out,
      file.path(model_paths$wow_output_dir, "rb_wow_final_export_2021_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

run_rb_wow_board_rebuild <- function(write_output = TRUE) {
  load_model_core_packages()
  
  rb_wow_board <- build_rb_wow_feature_overlay_table(write_output = write_output)
  rb_wow_board_summary <- build_rb_wow_board_summary(rb_wow_board, write_output = write_output)
  rb_wow_final_export <- build_rb_wow_final_export(rb_wow_board, write_output = write_output)
  
  list(
    board = rb_wow_board,
    board_summary = rb_wow_board_summary,
    final_export = rb_wow_final_export
  )
}

wr_wow_handoff <- get_handoff_spec("WR", "week_over_week")

wr_half_ppr_points_formula <- function(receiving_yards, receptions, total_td, rush_yards = 0) {
  receiving_yards <- safe_numeric(receiving_yards)
  receptions <- safe_numeric(receptions)
  total_td <- safe_numeric(total_td)
  rush_yards <- safe_numeric(rush_yards)
  
  receiving_yards[!is.finite(receiving_yards)] <- 0
  receptions[!is.finite(receptions)] <- 0
  total_td[!is.finite(total_td)] <- 0
  rush_yards[!is.finite(rush_yards)] <- 0
  
  receiving_yards / 10 +
    receptions * 0.5 +
    total_td * 6 +
    rush_yards / 10
}

wr_wow_age_window_score <- function(age_vec) {
  age_vec <- safe_numeric(age_vec)
  out <- 100 - pmin(abs(age_vec - 27) * 7, 100)
  out[!is.finite(age_vec)] <- NA_real_
  out
}

wr_wow_centered_rank <- function(x, higher_is_better = TRUE) {
  (qb_wow_percent_rank_0to100(x, higher_is_better = higher_is_better) - 50) / 50
}

build_wr_clean_weekly_master <- function(write_output = FALSE, output_dir = model_paths$foundation_output_dir) {
  load_model_core_packages()
  
  wr_raw <- load_position_hybrid("WR")
  
  wr_weekly <- wr_raw |>
    dplyr::transmute(
      season = .data$season,
      week = .data$week,
      game_number = .data$game_number,
      player = .data$player_name,
      player_key = .data$player_key,
      team = .data$team,
      opponent = .data$opponent_team,
      position = .data$position,
      depth_team = .data$depth_team_num,
      wr_depth_role = pick_first_existing_character(wr_raw, c("WR_Depth_Role")),
      draft_day = pick_first_existing_character(wr_raw, c("Draft_Day")),
      report_status = pick_first_existing_character(wr_raw, c("report_status")),
      practice_primary_injury = pick_first_existing_character(wr_raw, c("practice_primary_injury")),
      practice_secondary_injury = pick_first_existing_character(wr_raw, c("practice_secondary_injury")),
      practice_status = pick_first_existing_character(wr_raw, c("practice_status")),
      birth_date = pick_first_existing_character(wr_raw, c("birth_date")),
      rookie_year = .data$rookie_year_num,
      age = .data$age_num,
      routes = pick_first_existing_numeric(wr_raw, c("RTE", "RTE_ply")),
      route_pct = pick_first_existing_numeric(wr_raw, c("RTE_PCT")),
      targets_primary = pick_first_existing_numeric(wr_raw, c("TGT_ply")),
      targets_fallback = pick_first_existing_numeric(wr_raw, c("TGT")),
      team_total_targets_source = pick_first_existing_numeric(wr_raw, c("TM_TGT", "TGT_team")),
      receptions = pick_first_existing_numeric(wr_raw, c("REC", "REC_ply")),
      receiving_yards = pick_first_existing_numeric(wr_raw, c("YDS", "YDS_ply")),
      receiving_td = pick_first_existing_numeric(wr_raw, c("TD", "TD_ply")),
      receiving_yards_per_game_source = pick_first_existing_numeric(wr_raw, c("RecYDS_G")),
      air_yards = pick_first_existing_numeric(wr_raw, c("AY", "AY_ply")),
      air_yards_share = pick_first_existing_numeric(wr_raw, c("AY_Share")),
      adot = pick_first_existing_numeric(wr_raw, c("aDOT", "aDOT_ply")),
      targets_per_route_source = pick_first_existing_numeric(wr_raw, c("TPRR")),
      catch_rate_source = pick_first_existing_numeric(wr_raw, c("Catch_Rate")),
      yards_per_route_source = pick_first_existing_numeric(wr_raw, c("YPRR")),
      yards_per_target_source = pick_first_existing_numeric(wr_raw, c("YPT")),
      yards_per_reception_source = pick_first_existing_numeric(wr_raw, c("YPR")),
      yac_total = pick_first_existing_numeric(wr_raw, c("YAC")),
      yac_per_reception_source = pick_first_existing_numeric(wr_raw, c("YAC_REC")),
      yaco_rec = pick_first_existing_numeric(wr_raw, c("YACO_rec", "YACO_REC")),
      team_rec_yards_share = pick_first_existing_numeric(wr_raw, c("TM_RecYDS_PCT")),
      team_rec_td_share = pick_first_existing_numeric(wr_raw, c("TM_Rec_TD_PCT", "TM_RecTD_PCT")),
      first_read_targets = pick_first_existing_numeric(wr_raw, c("X1READ")),
      first_read_target_share = pick_first_existing_numeric(wr_raw, c("X1READ_Rec_PCT", "X1READ_PCT")),
      receiving_first_downs = pick_first_existing_numeric(wr_raw, c("X1D_rec")),
      first_downs_per_route_source = pick_first_existing_numeric(wr_raw, c("X1D_RR")),
      end_zone_targets = pick_first_existing_numeric(wr_raw, c("EZTGT")),
      end_zone_tds = pick_first_existing_numeric(wr_raw, c("EZTD")),
      drops = pick_first_existing_numeric(wr_raw, c("DRP")),
      drop_pct = pick_first_existing_numeric(wr_raw, c("DROP_PCT", "DRP_RATE")),
      catchable_targets = pick_first_existing_numeric(wr_raw, c("CTGT")),
      catchable_tgt_pct = pick_first_existing_numeric(wr_raw, c("Catchable_TGT_PCT", "Catchable_TGT_Rate", "CTGT_RATE")),
      designed_targets = pick_first_existing_numeric(wr_raw, c("DESIGN")),
      design_pct = pick_first_existing_numeric(wr_raw, c("DESIGN_PCT", "DESIGN_RATE")),
      contested_targets = pick_first_existing_numeric(wr_raw, c("CT")),
      contested_catches = pick_first_existing_numeric(wr_raw, c("CC")),
      contested_catch_pct = pick_first_existing_numeric(wr_raw, c("Contested_Catch_PCT", "Contested_Catch_Rate", "CC_RATE")),
      hero_targets = pick_first_existing_numeric(wr_raw, c("HERO")),
      target_rate = pick_first_existing_numeric(wr_raw, c("RATE", "RATE_rec")),
      threat_score = pick_first_existing_numeric(wr_raw, c("THREAT")),
      yptoe = pick_first_existing_numeric(wr_raw, c("YPTOE")),
      wide_rte_pct = pick_first_existing_numeric(wr_raw, c("WIDE_RTE_PCT")),
      slot_rte_pct = pick_first_existing_numeric(wr_raw, c("SLOT_RTE_PCT")),
      inline_rte_pct = pick_first_existing_numeric(wr_raw, c("INLINE_RTE_PCT")),
      backfield_rte_pct = pick_first_existing_numeric(wr_raw, c("BACK_RTE_PCT")),
      rush_attempts = pick_first_existing_numeric(wr_raw, c("CAR", "CAR_ply")),
      rush_yards = pick_first_existing_numeric(wr_raw, c("YDS_rush", "YDS_rush_ply")),
      rush_td = pick_first_existing_numeric(wr_raw, c("TD_rush", "TD_rush_ply")),
      fantasy_points_source = dplyr::coalesce(
        pick_first_existing_numeric(wr_raw, c("fantasyPts")),
        pick_first_existing_numeric(wr_raw, c("FP_rec")),
        pick_first_existing_numeric(wr_raw, c("FP_G_rec")),
        pick_first_existing_numeric(wr_raw, c("FP_G"))
      ),
      source_file = pick_first_existing_character(wr_raw, c("dataset_file"))
    ) |>
    dplyr::filter(!is.na(.data$season), !is.na(.data$week), .data$week >= 1, .data$week <= 18) |>
    dplyr::mutate(
      team = normalize_team_abbr(.data$team),
      opponent = normalize_team_abbr(.data$opponent),
      targets = dplyr::if_else(
        !is.na(.data$targets_primary) & .data$targets_primary > 0,
        .data$targets_primary,
        dplyr::coalesce(.data$targets_fallback, 0)
      ),
      team_total_targets = dplyr::coalesce(.data$team_total_targets_source, 0),
      total_td = dplyr::coalesce(.data$receiving_td, 0) + dplyr::coalesce(.data$rush_td, 0),
      scrimmage_yards = dplyr::coalesce(.data$receiving_yards, 0) + dplyr::coalesce(.data$rush_yards, 0),
      half_ppr_points = wr_half_ppr_points_formula(
        .data$receiving_yards,
        .data$receptions,
        .data$total_td,
        .data$rush_yards
      ),
      fantasy_points_calc = dplyr::coalesce(.data$half_ppr_points, .data$fantasy_points_source),
      targets_per_route = dplyr::coalesce(.data$targets_per_route_source, safe_div(.data$targets, .data$routes)),
      catch_rate = dplyr::coalesce(.data$catch_rate_source, 100 * safe_div(.data$receptions, .data$targets)),
      receiving_yards_per_game = dplyr::coalesce(.data$receiving_yards_per_game_source, .data$receiving_yards),
      yards_per_route = dplyr::coalesce(.data$yards_per_route_source, safe_div(.data$receiving_yards, .data$routes)),
      yards_per_target = dplyr::coalesce(.data$yards_per_target_source, safe_div(.data$receiving_yards, .data$targets)),
      yards_per_reception = dplyr::coalesce(.data$yards_per_reception_source, safe_div(.data$receiving_yards, .data$receptions)),
      yac_per_reception = dplyr::coalesce(.data$yac_per_reception_source, safe_div(.data$yac_total, .data$receptions)),
      air_yards_per_target = safe_div(.data$air_yards, .data$targets),
      first_downs_per_route = dplyr::coalesce(.data$first_downs_per_route_source, safe_div(.data$receiving_first_downs, .data$routes)),
      first_downs_per_target = safe_div(.data$receiving_first_downs, .data$targets),
      first_reads_per_target = safe_div(.data$first_read_targets, .data$targets),
      end_zone_target_rate = safe_div(.data$end_zone_targets, .data$targets),
      td_per_target = safe_div(.data$receiving_td, .data$targets),
      wr_model_eligible = .data$position == "WR",
      regular_season_flag = TRUE
    ) |>
    dplyr::select(
      -dplyr::any_of(c(
        "targets_primary", "targets_fallback", "team_total_targets_source", "receiving_yards_per_game_source",
        "targets_per_route_source", "catch_rate_source", "yards_per_route_source", "yards_per_target_source",
        "yards_per_reception_source", "yac_per_reception_source", "first_downs_per_route_source"
      ))
    ) |>
    dplyr::arrange(.data$season, .data$week, .data$team, .data$player)
  
  duplicate_keys <- wr_weekly |>
    dplyr::count(.data$season, .data$week, .data$player_key, name = "dup_n") |>
    dplyr::filter(.data$dup_n > 1)
  
  if (nrow(duplicate_keys) > 0) {
    conflict_columns <- c(
      "team", "opponent", "position", "routes", "targets", "receptions",
      "receiving_yards", "receiving_td", "air_yards", "end_zone_targets",
      "first_read_targets", "receiving_first_downs", "rush_attempts",
      "rush_yards", "rush_td", "total_td", "half_ppr_points"
    )
    conflicting_keys <- wr_weekly |>
      dplyr::semi_join(duplicate_keys, by = c("season", "week", "player_key")) |>
      dplyr::group_by(.data$season, .data$week, .data$player_key) |>
      dplyr::summarise(
        conflict = any(vapply(
          dplyr::pick(dplyr::all_of(conflict_columns)),
          function(x) dplyr::n_distinct(x, na.rm = FALSE) > 1L,
          logical(1)
        )),
        .groups = "drop"
      ) |>
      dplyr::filter(.data$conflict)
    
    if (nrow(conflicting_keys) > 0) {
      stop(
        paste0(
          "WR clean weekly master has ", nrow(conflicting_keys),
          " conflicting player-week duplicates; inspect the hybrid source before modeling."
        ),
        call. = FALSE
      )
    }
  }
  
  completeness_columns <- c(
    "routes", "targets", "receptions", "receiving_yards", "receiving_td",
    "air_yards", "end_zone_targets", "first_read_targets",
    "receiving_first_downs", "rush_attempts", "rush_yards", "rush_td",
    "half_ppr_points", "depth_team", "opponent"
  )
  wr_weekly <- wr_weekly |>
    dplyr::mutate(
      .wr_row_completeness = rowSums(!is.na(dplyr::pick(dplyr::all_of(completeness_columns))))
    ) |>
    dplyr::arrange(
      .data$season, .data$week, .data$player_key,
      dplyr::desc(.data$.wr_row_completeness),
      dplyr::desc(!is.na(.data$source_file) & .data$source_file != "")
    ) |>
    dplyr::distinct(.data$season, .data$week, .data$player_key, .keep_all = TRUE) |>
    dplyr::select(-dplyr::all_of(".wr_row_completeness"))
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      wr_weekly,
      file.path(output_dir, "wr_clean_weekly_master_2021_2025_regular.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  wr_weekly
}

build_wr_team_week_opportunity_table <- function(
    wr_weekly = build_wr_clean_weekly_master(),
    write_output = FALSE,
    output_dir = model_paths$foundation_output_dir
) {
  load_model_core_packages()
  
  out <- wr_weekly |>
    dplyr::filter(.data$wr_model_eligible) |>
    dplyr::group_by(.data$season, .data$week, .data$team) |>
    dplyr::summarise(
      team_wr_targets = sum(.data$targets, na.rm = TRUE),
      team_wr_receptions = sum(.data$receptions, na.rm = TRUE),
      team_wr_routes = sum(.data$routes, na.rm = TRUE),
      team_wr_receiving_yards = sum(.data$receiving_yards, na.rm = TRUE),
      team_wr_air_yards = sum(.data$air_yards, na.rm = TRUE),
      team_wr_first_reads = sum(.data$first_read_targets, na.rm = TRUE),
      team_wr_first_downs = sum(.data$receiving_first_downs, na.rm = TRUE),
      team_wr_end_zone_targets = sum(.data$end_zone_targets, na.rm = TRUE),
      team_wr_total_td = sum(.data$total_td, na.rm = TRUE),
      team_wr_half_ppr = sum(.data$half_ppr_points, na.rm = TRUE),
      .groups = "drop"
    )
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "wr_team_week_opportunity_2021_2025_regular.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_wr_player_share_table <- function(
    wr_weekly = build_wr_clean_weekly_master(),
    team_week = build_wr_team_week_opportunity_table(wr_weekly),
    write_output = FALSE,
    output_dir = model_paths$foundation_output_dir
) {
  load_model_core_packages()
  
  out <- wr_weekly |>
    dplyr::left_join(team_week, by = c("season", "week", "team")) |>
    dplyr::mutate(
      team_target_share = safe_div(.data$targets, .data$team_wr_targets),
      team_rec_share = safe_div(.data$receptions, .data$team_wr_receptions),
      team_route_share = safe_div(.data$routes, .data$team_wr_routes),
      team_air_share = safe_div(.data$air_yards, .data$team_wr_air_yards),
      team_first_read_share = safe_div(.data$first_read_targets, .data$team_wr_first_reads),
      team_first_down_share = safe_div(.data$receiving_first_downs, .data$team_wr_first_downs),
      team_end_zone_target_share = safe_div(.data$end_zone_targets, .data$team_wr_end_zone_targets),
      team_fantasy_share = safe_div(.data$half_ppr_points, .data$team_wr_half_ppr),
      starter_flag = dplyr::if_else(!is.na(.data$depth_team) & .data$depth_team <= 1, 1L, 0L)
    )
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "wr_player_share_table_2021_2025_regular.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_wr_team_context_base <- function(
    wr_share = build_wr_player_share_table(write_output = FALSE),
    write_output = FALSE,
    output_dir = model_paths$wow_output_dir
) {
  load_model_core_packages()
  
  out <- wr_share |>
    dplyr::distinct(
      .data$season,
      .data$week,
      .data$team,
      .data$team_wr_targets,
      .data$team_wr_receptions,
      .data$team_wr_routes,
      .data$team_wr_receiving_yards,
      .data$team_wr_air_yards,
      .data$team_wr_first_reads,
      .data$team_wr_first_downs,
      .data$team_wr_end_zone_targets,
      .data$team_wr_total_td,
      .data$team_wr_half_ppr
    ) |>
    dplyr::arrange(.data$team, .data$season, .data$week) |>
    dplyr::group_by(.data$team, .data$season) |>
    dplyr::mutate(
      team_games_played_to_date = dplyr::row_number(),
      season_to_date_team_wr_half_ppr_pg = cumsum(dplyr::coalesce(.data$team_wr_half_ppr, 0)) / team_games_played_to_date,
      rolling4_team_wr_half_ppr = rolling_mean_vec(.data$team_wr_half_ppr, 4),
      rolling6_team_wr_half_ppr = rolling_mean_vec(.data$team_wr_half_ppr, 6),
      rolling4_team_wr_targets = rolling_mean_vec(.data$team_wr_targets, 4),
      rolling6_team_wr_targets = rolling_mean_vec(.data$team_wr_targets, 6),
      rolling4_team_wr_routes = rolling_mean_vec(.data$team_wr_routes, 4),
      rolling6_team_wr_routes = rolling_mean_vec(.data$team_wr_routes, 6),
      rolling4_team_wr_air_yards = rolling_mean_vec(.data$team_wr_air_yards, 4),
      rolling6_team_wr_air_yards = rolling_mean_vec(.data$team_wr_air_yards, 6),
      rolling4_team_wr_first_reads = rolling_mean_vec(.data$team_wr_first_reads, 4),
      rolling6_team_wr_first_reads = rolling_mean_vec(.data$team_wr_first_reads, 6),
      rolling4_team_wr_first_downs = rolling_mean_vec(.data$team_wr_first_downs, 4),
      rolling6_team_wr_first_downs = rolling_mean_vec(.data$team_wr_first_downs, 6),
      rolling4_team_wr_end_zone_targets = rolling_mean_vec(.data$team_wr_end_zone_targets, 4),
      rolling6_team_wr_end_zone_targets = rolling_mean_vec(.data$team_wr_end_zone_targets, 6),
      rolling4_team_wr_total_td = rolling_mean_vec(.data$team_wr_total_td, 4),
      rolling6_team_wr_total_td = rolling_mean_vec(.data$team_wr_total_td, 6)
    ) |>
    dplyr::ungroup()
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "wr_team_context_base_2021_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_wr_weekly_feature_base <- function(write_output = FALSE, output_dir = model_paths$wow_output_dir) {
  load_model_core_packages()
  
  wr_share <- build_wr_player_share_table(write_output = FALSE)
  wr_team_context <- build_wr_team_context_base(wr_share, write_output = write_output, output_dir = output_dir)
  
  out <- wr_share |>
    dplyr::filter(.data$wr_model_eligible) |>
    dplyr::left_join(
      wr_team_context,
      by = c("season", "week", "team", "team_wr_targets", "team_wr_receptions", "team_wr_routes",
             "team_wr_receiving_yards", "team_wr_air_yards", "team_wr_first_reads",
             "team_wr_first_downs", "team_wr_end_zone_targets", "team_wr_total_td", "team_wr_half_ppr")
    ) |>
    dplyr::arrange(.data$player_key, .data$season, .data$week) |>
    dplyr::group_by(.data$player_key, .data$season) |>
    dplyr::mutate(
      feature_week = .data$week,
      next_week = .data$week + 1L,
      next_week_opponent = dplyr::lead(.data$opponent),
      next_week_fantasy_points = dplyr::lead(.data$half_ppr_points),
      next_week_targets = dplyr::lead(.data$targets),
      next_week_routes = dplyr::lead(.data$routes),
      next_week_receiving_yards = dplyr::lead(.data$receiving_yards),
      next_week_total_td = dplyr::lead(.data$total_td),
      next_week_air_yards = dplyr::lead(.data$air_yards),
      next_week_first_read_targets = dplyr::lead(.data$first_read_targets),
      next_week_first_downs = dplyr::lead(.data$receiving_first_downs),
      games_played_to_date = dplyr::row_number(),
      season_to_date_fantasy_points = cumsum(dplyr::coalesce(.data$half_ppr_points, 0)),
      season_to_date_fantasy_points_per_game = season_to_date_fantasy_points / games_played_to_date,
      season_to_date_targets_per_game = cumsum(dplyr::coalesce(.data$targets, 0)) / games_played_to_date,
      season_to_date_routes_per_game = cumsum(dplyr::coalesce(.data$routes, 0)) / games_played_to_date,
      season_to_date_air_yards_per_game = cumsum(dplyr::coalesce(.data$air_yards, 0)) / games_played_to_date,
      season_to_date_first_reads_per_game = cumsum(dplyr::coalesce(.data$first_read_targets, 0)) / games_played_to_date,
      season_to_date_first_downs_per_game = cumsum(dplyr::coalesce(.data$receiving_first_downs, 0)) / games_played_to_date,
      season_to_date_receiving_yards_per_game = cumsum(dplyr::coalesce(.data$receiving_yards, 0)) / games_played_to_date,
      rolling4_fantasy_points = rolling_mean_vec(.data$half_ppr_points, 4),
      rolling6_fantasy_points = rolling_mean_vec(.data$half_ppr_points, 6),
      rolling4_targets = rolling_mean_vec(.data$targets, 4),
      rolling6_targets = rolling_mean_vec(.data$targets, 6),
      rolling4_routes = rolling_mean_vec(.data$routes, 4),
      rolling6_routes = rolling_mean_vec(.data$routes, 6),
      rolling4_receiving_yards = rolling_mean_vec(.data$receiving_yards, 4),
      rolling6_receiving_yards = rolling_mean_vec(.data$receiving_yards, 6),
      rolling4_air_yards = rolling_mean_vec(.data$air_yards, 4),
      rolling6_air_yards = rolling_mean_vec(.data$air_yards, 6),
      rolling4_first_reads = rolling_mean_vec(.data$first_read_targets, 4),
      rolling6_first_reads = rolling_mean_vec(.data$first_read_targets, 6),
      rolling4_first_downs = rolling_mean_vec(.data$receiving_first_downs, 4),
      rolling6_first_downs = rolling_mean_vec(.data$receiving_first_downs, 6),
      rolling4_end_zone_targets = rolling_mean_vec(.data$end_zone_targets, 4),
      rolling6_end_zone_targets = rolling_mean_vec(.data$end_zone_targets, 6),
      rolling4_total_td = rolling_mean_vec(.data$total_td, 4),
      rolling6_total_td = rolling_mean_vec(.data$total_td, 6),
      rolling4_target_share = rolling_mean_vec(.data$team_target_share, 4),
      rolling6_target_share = rolling_mean_vec(.data$team_target_share, 6),
      rolling4_route_share = rolling_mean_vec(.data$team_route_share, 4),
      rolling6_route_share = rolling_mean_vec(.data$team_route_share, 6),
      rolling4_air_share = rolling_mean_vec(.data$team_air_share, 4),
      rolling6_air_share = rolling_mean_vec(.data$team_air_share, 6),
      rolling4_first_read_share = rolling_mean_vec(.data$team_first_read_share, 4),
      rolling6_first_read_share = rolling_mean_vec(.data$team_first_read_share, 6),
      rolling4_first_down_share = rolling_mean_vec(.data$team_first_down_share, 4),
      rolling6_first_down_share = rolling_mean_vec(.data$team_first_down_share, 6),
      rolling4_fantasy_share = rolling_mean_vec(.data$team_fantasy_share, 4),
      rolling6_fantasy_share = rolling_mean_vec(.data$team_fantasy_share, 6),
      rolling4_targets_per_route = rolling_mean_vec(.data$targets_per_route, 4),
      rolling6_targets_per_route = rolling_mean_vec(.data$targets_per_route, 6),
      rolling4_yards_per_route = rolling_mean_vec(.data$yards_per_route, 4),
      rolling6_yards_per_route = rolling_mean_vec(.data$yards_per_route, 6),
      rolling4_yards_per_target = rolling_mean_vec(.data$yards_per_target, 4),
      rolling6_yards_per_target = rolling_mean_vec(.data$yards_per_target, 6),
      rolling4_first_downs_per_target = rolling_mean_vec(.data$first_downs_per_target, 4),
      rolling6_first_downs_per_target = rolling_mean_vec(.data$first_downs_per_target, 6),
      rolling4_air_yards_per_target = rolling_mean_vec(.data$air_yards_per_target, 4),
      rolling6_air_yards_per_target = rolling_mean_vec(.data$air_yards_per_target, 6),
      rolling4_catch_rate = rolling_mean_vec(.data$catch_rate, 4),
      rolling6_catch_rate = rolling_mean_vec(.data$catch_rate, 6),
      rolling4_target_rate = rolling_mean_vec(.data$target_rate, 4),
      rolling6_target_rate = rolling_mean_vec(.data$target_rate, 6),
      rolling6_fantasy_points_sd = rolling_sd_vec(.data$half_ppr_points, 6),
      rolling6_targets_sd = rolling_sd_vec(.data$targets, 6),
      rolling6_routes_sd = rolling_sd_vec(.data$routes, 6),
      recent_5plus_target_flag = as.numeric(dplyr::coalesce(.data$targets, 0) >= 5),
      recent_8plus_target_flag = as.numeric(dplyr::coalesce(.data$targets, 0) >= 8),
      games_with_5plus_targets_recent_rate = rolling_mean_vec(.data$recent_5plus_target_flag, 6),
      games_with_8plus_targets_recent_rate = rolling_mean_vec(.data$recent_8plus_target_flag, 6),
      trend_fantasy_points_4v6 = rolling4_fantasy_points - rolling6_fantasy_points,
      trend_targets_4v6 = rolling4_targets - rolling6_targets,
      trend_routes_4v6 = rolling4_routes - rolling6_routes,
      trend_air_yards_4v6 = rolling4_air_yards - rolling6_air_yards,
      trend_first_reads_4v6 = rolling4_first_reads - rolling6_first_reads,
      trend_first_downs_4v6 = rolling4_first_downs - rolling6_first_downs,
      trend_target_share_4v6 = rolling4_target_share - rolling6_target_share,
      trend_route_share_4v6 = rolling4_route_share - rolling6_route_share,
      trend_air_share_4v6 = rolling4_air_share - rolling6_air_share,
      depth_order_current = .data$depth_team,
      target_week_fp = .data$next_week_fantasy_points
    ) |>
    dplyr::ungroup()
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "wr_weekly_feature_base_2021_2025_regular.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_wr_wow_inputs <- function(write_output = FALSE) {
  load_model_core_packages()
  
  wr_weekly_feature_base <- build_wr_weekly_feature_base(write_output = write_output)
  
  out <- list(
    position = "WR",
    mode = "week_over_week",
    handoff = wr_wow_handoff,
    handoff_text = read_text_from_handoff(wr_wow_handoff),
    weekly_base = build_wow_weekly_base("WR"),
    wr_weekly_feature_base = wr_weekly_feature_base,
    next_steps = c(
      "Use the WR weekly feature base as the no-leakage input table for week-ahead training and ranking.",
      "Keep QB context and defense matchup as weekly pool and range modifiers, not core OMFG inputs.",
      "Build calibrated WR weekly ranges and finish probabilities from the projected weekly board."
    )
  )
  
  if (write_output) {
    out$output_paths <- c(
      wr_weekly_base = write_wow_weekly_base("WR"),
      wr_weekly_feature_base = file.path(model_paths$wow_output_dir, "wr_weekly_feature_base_2021_2025_regular.csv"),
      wr_team_context_base = file.path(model_paths$wow_output_dir, "wr_team_context_base_2021_2025.csv")
    )
  }
  
  out
}

make_wr_wow_output_manifest <- function(wr_wow_result) {
  output_paths <- unname(wr_wow_result$output_paths %||% character())
  output_labels <- names(wr_wow_result$output_paths %||% character())
  
  data.frame(
    output_name = output_labels,
    output_path = output_paths,
    exists = file.exists(output_paths),
    stringsAsFactors = FALSE
  )
}

run_wr_wow_pipeline <- function(write_output = TRUE) {
  load_model_core_packages()
  
  dir.create(model_paths$wow_output_dir, recursive = TRUE, showWarnings = FALSE)
  
  wr_wow_result <- build_wr_wow_inputs(write_output = write_output)
  wr_wow_board_rebuild <- run_wr_wow_board_rebuild(write_output = write_output)
  
  output_paths <- c(
    wr_wow_result$output_paths %||% character(),
    wr_wow_feature_overlay = file.path(model_paths$wow_output_dir, "wr_wow_feature_overlay_2021_2025.csv"),
    wr_wow_board_metrics = file.path(model_paths$wow_output_dir, "wr_wow_board_metrics_2021_2025.csv"),
    wr_wow_board_summary = file.path(model_paths$wow_output_dir, "wr_wow_board_summary_2021_2025.csv"),
    wr_wow_final_export = file.path(model_paths$wow_output_dir, "wr_wow_final_export_2021_2025.csv")
  )
  
  wr_wow_result$output_paths <- output_paths
  output_manifest <- make_wr_wow_output_manifest(wr_wow_result)
  
  list(
    result = wr_wow_result,
    board = wr_wow_board_rebuild$board,
    board_summary = wr_wow_board_rebuild$board_summary,
    final_export = wr_wow_board_rebuild$final_export,
    output_manifest = output_manifest
  )
}

build_wr_prior_season_week1_summary <- function(wr_wow_feature_base) {
  load_model_core_packages()
  
  season_summary <- wr_wow_feature_base |>
    dplyr::mutate(
      player_key = as.character(.data$player_key),
      season = suppressWarnings(as.integer(.data$season)),
      half_ppr_points = suppressWarnings(as.numeric(.data$half_ppr_points)),
      targets = suppressWarnings(as.numeric(.data$targets)),
      routes = suppressWarnings(as.numeric(.data$routes)),
      receiving_yards = suppressWarnings(as.numeric(.data$receiving_yards)),
      air_yards = suppressWarnings(as.numeric(.data$air_yards)),
      first_read_targets = suppressWarnings(as.numeric(.data$first_read_targets)),
      receiving_first_downs = suppressWarnings(as.numeric(.data$receiving_first_downs)),
      total_td = suppressWarnings(as.numeric(.data$total_td))
    ) |>
    dplyr::group_by(.data$player_key, .data$season) |>
    dplyr::summarise(
      season_games = sum(is.finite(.data$half_ppr_points)),
      season_ppg = ifelse(season_games > 0, mean(.data$half_ppr_points, na.rm = TRUE), NA_real_),
      season_total_fp = sum(.data$half_ppr_points, na.rm = TRUE),
      season_targets_pg = ifelse(season_games > 0, mean(.data$targets, na.rm = TRUE), NA_real_),
      season_routes_pg = ifelse(season_games > 0, mean(.data$routes, na.rm = TRUE), NA_real_),
      season_receiving_yards_pg = ifelse(season_games > 0, mean(.data$receiving_yards, na.rm = TRUE), NA_real_),
      season_air_yards_pg = ifelse(season_games > 0, mean(.data$air_yards, na.rm = TRUE), NA_real_),
      season_first_reads_pg = ifelse(season_games > 0, mean(.data$first_read_targets, na.rm = TRUE), NA_real_),
      season_first_downs_pg = ifelse(season_games > 0, mean(.data$receiving_first_downs, na.rm = TRUE), NA_real_),
      season_total_td_pg = ifelse(season_games > 0, mean(.data$total_td, na.rm = TRUE), NA_real_),
      .groups = "drop"
    )
  
  prior_summary <- season_summary |>
    dplyr::transmute(
      player_key = .data$player_key,
      season = .data$season + 1L,
      prior_season_games = .data$season_games,
      prior_season_ppg = .data$season_ppg,
      prior_season_total_fp = .data$season_total_fp,
      prior_season_targets_pg = .data$season_targets_pg,
      prior_season_routes_pg = .data$season_routes_pg,
      prior_season_receiving_yards_pg = .data$season_receiving_yards_pg,
      prior_season_air_yards_pg = .data$season_air_yards_pg,
      prior_season_first_reads_pg = .data$season_first_reads_pg,
      prior_season_first_downs_pg = .data$season_first_downs_pg,
      prior_season_total_td_pg = .data$season_total_td_pg
    )
  
  target_rows <- season_summary |>
    dplyr::distinct(.data$player_key, .data$season)
  
  career_summary <- lapply(seq_len(nrow(target_rows)), function(i) {
    player_key_i <- target_rows$player_key[[i]]
    season_i <- target_rows$season[[i]]
    
    hist <- season_summary |>
      dplyr::filter(.data$player_key == player_key_i, .data$season < season_i, .data$season_games > 0)
    
    if (nrow(hist) == 0) {
      return(data.frame(
        player_key = player_key_i,
        season = season_i,
        career_games = NA_real_,
        career_seasons = NA_real_,
        career_ppg = NA_real_,
        career_total_fp = NA_real_,
        career_targets_pg = NA_real_,
        career_routes_pg = NA_real_,
        career_receiving_yards_pg = NA_real_,
        career_air_yards_pg = NA_real_,
        career_first_reads_pg = NA_real_,
        career_first_downs_pg = NA_real_,
        career_total_td_pg = NA_real_,
        last_active_season = NA_real_,
        years_since_last_active = NA_real_,
        stringsAsFactors = FALSE
      ))
    }
    
    total_games <- sum(hist$season_games, na.rm = TRUE)
    total_fp <- sum(hist$season_total_fp, na.rm = TRUE)
    last_active <- max(hist$season, na.rm = TRUE)
    
    data.frame(
      player_key = player_key_i,
      season = season_i,
      career_games = total_games,
      career_seasons = nrow(hist),
      career_ppg = ifelse(total_games > 0, total_fp / total_games, NA_real_),
      career_total_fp = total_fp,
      career_targets_pg = stats::weighted.mean(hist$season_targets_pg, w = pmax(hist$season_games, 1), na.rm = TRUE),
      career_routes_pg = stats::weighted.mean(hist$season_routes_pg, w = pmax(hist$season_games, 1), na.rm = TRUE),
      career_receiving_yards_pg = stats::weighted.mean(hist$season_receiving_yards_pg, w = pmax(hist$season_games, 1), na.rm = TRUE),
      career_air_yards_pg = stats::weighted.mean(hist$season_air_yards_pg, w = pmax(hist$season_games, 1), na.rm = TRUE),
      career_first_reads_pg = stats::weighted.mean(hist$season_first_reads_pg, w = pmax(hist$season_games, 1), na.rm = TRUE),
      career_first_downs_pg = stats::weighted.mean(hist$season_first_downs_pg, w = pmax(hist$season_games, 1), na.rm = TRUE),
      career_total_td_pg = stats::weighted.mean(hist$season_total_td_pg, w = pmax(hist$season_games, 1), na.rm = TRUE),
      last_active_season = last_active,
      years_since_last_active = season_i - last_active,
      stringsAsFactors = FALSE
    )
  }) |>
    dplyr::bind_rows()
  
  target_rows |>
    dplyr::left_join(prior_summary, by = c("player_key", "season")) |>
    dplyr::left_join(career_summary, by = c("player_key", "season"))
}

build_wr_wow_qb_context <- function() {
  load_model_core_packages()
  
  qb_clean <- build_qb_clean_weekly_master(write_output = FALSE)
  
  qb_clean |>
    dplyr::group_by(.data$season, .data$week, .data$team) |>
    dplyr::arrange(
      dplyr::desc(dplyr::coalesce(.data$pass_attempts, 0)),
      dplyr::desc(dplyr::coalesce(.data$fantasy_points_calc, 0)),
      .data$player,
      .by_group = TRUE
    ) |>
    dplyr::slice(1) |>
    dplyr::ungroup() |>
    dplyr::arrange(.data$team, .data$season, .data$week) |>
    dplyr::group_by(.data$team, .data$season) |>
    dplyr::mutate(
      lead_qb_changed_flag = as.integer(.data$player_key != dplyr::lag(.data$player_key) & !is.na(dplyr::lag(.data$player_key))),
      rolling3_lead_qb_pass_attempts = rolling_mean_vec(.data$pass_attempts, 3),
      rolling3_lead_qb_pass_yards = rolling_mean_vec(.data$pass_yards, 3),
      rolling3_lead_qb_pass_td = rolling_mean_vec(.data$pass_td, 3),
      rolling3_lead_qb_any_a = rolling_mean_vec(.data$any_a, 3),
      rolling3_lead_qb_fp = rolling_mean_vec(.data$fantasy_points_calc, 3)
    ) |>
    dplyr::ungroup() |>
    dplyr::transmute(
      season = .data$season,
      feature_week = .data$week,
      team = .data$team,
      lead_qb_player = .data$player,
      lead_qb_player_key = .data$player_key,
      lead_qb_depth_team = .data$depth_team,
      lead_qb_report_status = .data$report_status,
      lead_qb_pass_attempts = .data$pass_attempts,
      lead_qb_pass_yards = .data$pass_yards,
      lead_qb_pass_td = .data$pass_td,
      lead_qb_any_a = .data$any_a,
      lead_qb_fp = .data$fantasy_points_calc,
      lead_qb_changed_flag = .data$lead_qb_changed_flag,
      rolling3_lead_qb_pass_attempts = .data$rolling3_lead_qb_pass_attempts,
      rolling3_lead_qb_pass_yards = .data$rolling3_lead_qb_pass_yards,
      rolling3_lead_qb_pass_td = .data$rolling3_lead_qb_pass_td,
      rolling3_lead_qb_any_a = .data$rolling3_lead_qb_any_a,
      rolling3_lead_qb_fp = .data$rolling3_lead_qb_fp
    )
}

build_wr_wow_defense_context <- function(wr_wow_feature_base) {
  load_model_core_packages()
  
  wr_wow_feature_base |>
    dplyr::group_by(feature_week = .data$week, season = .data$season, defense_team = .data$opponent) |>
    dplyr::summarise(
      wr_fp_allowed = sum(.data$half_ppr_points, na.rm = TRUE),
      wr_targets_allowed = sum(.data$targets, na.rm = TRUE),
      wr_routes_allowed = sum(.data$routes, na.rm = TRUE),
      wr_receiving_yards_allowed = sum(.data$receiving_yards, na.rm = TRUE),
      wr_air_yards_allowed = sum(.data$air_yards, na.rm = TRUE),
      wr_first_reads_allowed = sum(.data$first_read_targets, na.rm = TRUE),
      wr_first_downs_allowed = sum(.data$receiving_first_downs, na.rm = TRUE),
      wr_end_zone_targets_allowed = sum(.data$end_zone_targets, na.rm = TRUE),
      wr_td_allowed = sum(.data$total_td, na.rm = TRUE),
      .groups = "drop"
    ) |>
    dplyr::arrange(.data$defense_team, .data$season, .data$feature_week) |>
    dplyr::group_by(.data$defense_team, .data$season) |>
    dplyr::mutate(
      trailing3_wr_fp_allowed = rolling_mean_vec(.data$wr_fp_allowed, 3),
      trailing5_wr_fp_allowed = rolling_mean_vec(.data$wr_fp_allowed, 5),
      trailing5_wr_targets_allowed = rolling_mean_vec(.data$wr_targets_allowed, 5),
      trailing5_wr_routes_allowed = rolling_mean_vec(.data$wr_routes_allowed, 5),
      trailing5_wr_receiving_yards_allowed = rolling_mean_vec(.data$wr_receiving_yards_allowed, 5),
      trailing5_wr_air_yards_allowed = rolling_mean_vec(.data$wr_air_yards_allowed, 5),
      trailing5_wr_first_reads_allowed = rolling_mean_vec(.data$wr_first_reads_allowed, 5),
      trailing5_wr_first_downs_allowed = rolling_mean_vec(.data$wr_first_downs_allowed, 5),
      trailing5_wr_end_zone_targets_allowed = rolling_mean_vec(.data$wr_end_zone_targets_allowed, 5),
      trailing5_wr_td_allowed = rolling_mean_vec(.data$wr_td_allowed, 5)
    ) |>
    dplyr::ungroup()
}

build_wr_wow_feature_overlay_table <- function(wr_wow_feature_base = NULL, write_output = TRUE, output_dir = model_paths$wow_output_dir) {
  load_model_core_packages()
  
  if (is.null(wr_wow_feature_base)) {
    wr_wow_feature_base <- build_wr_weekly_feature_base(write_output = FALSE)
  }
  
  wr_prior_season_summary <- build_wr_prior_season_week1_summary(wr_wow_feature_base)
  wr_qb_context <- build_wr_wow_qb_context()
  wr_defense_context <- build_wr_wow_defense_context(wr_wow_feature_base)
  
  out <- wr_wow_feature_base |>
    dplyr::left_join(wr_prior_season_summary, by = c("player_key", "season")) |>
    dplyr::left_join(wr_qb_context, by = c("season", "feature_week", "team")) |>
    dplyr::left_join(wr_defense_context, by = c("season", "feature_week", "next_week_opponent" = "defense_team")) |>
    dplyr::mutate(
      season = suppressWarnings(as.integer(.data$season)),
      week = suppressWarnings(as.integer(.data$week)),
      feature_week = suppressWarnings(as.integer(.data$feature_week)),
      next_week = suppressWarnings(as.integer(.data$next_week)),
      depth_team = suppressWarnings(as.numeric(.data$depth_team)),
      age = suppressWarnings(as.numeric(.data$age)),
      rookie_year = suppressWarnings(as.numeric(.data$rookie_year)),
      target_week_fp = suppressWarnings(as.numeric(.data$target_week_fp)),
      wr_wow_anchor_fp = dplyr::coalesce(
        safe_numeric(.data$season_to_date_fantasy_points_per_game),
        safe_numeric(.data$rolling4_fantasy_points),
        safe_numeric(.data$rolling6_fantasy_points),
        safe_numeric(.data$half_ppr_points)
      ),
      preseason_weight = dplyr::case_when(
        .data$week <= 1L ~ 0.55,
        .data$week == 2L ~ 0.42,
        .data$week == 3L ~ 0.32,
        .data$week == 4L ~ 0.24,
        .data$week == 5L ~ 0.18,
        TRUE ~ 0.12
      ),
      has_prior_season_stats = is.finite(.data$prior_season_ppg) & .data$prior_season_games >= 4,
      has_career_stats = is.finite(.data$career_ppg) & .data$career_games >= 4,
      is_true_rookie = is.finite(.data$rookie_year) & .data$rookie_year >= .data$season,
      draft_day_score_0to100 = qb_draft_day_score_0to100(.data$draft_day),
      td_context_raw = safe_div(.data$rolling6_total_td, .data$rolling6_targets),
      first_read_quality_raw = safe_div(.data$rolling6_first_reads, .data$rolling6_targets),
      first_down_quality_raw = safe_div(.data$rolling6_first_downs, .data$rolling6_targets),
      air_priority_raw = safe_div(.data$rolling6_air_yards, .data$rolling6_targets),
      efficiency_reliability_raw = qb_wow_row_mean(.data$rolling6_targets, .data$rolling6_routes)
    ) |>
    dplyr::group_by(.data$season, .data$feature_week) |>
    dplyr::mutate(
      wow_anchor_rank_component = qb_wow_percent_rank_0to100(.data$wr_wow_anchor_fp),
      prior_season_production_score = qb_wow_row_mean(
        qb_wow_percent_rank_0to100(.data$prior_season_ppg),
        qb_wow_percent_rank_0to100(.data$prior_season_total_fp),
        qb_wow_percent_rank_0to100(.data$prior_season_targets_pg),
        qb_wow_percent_rank_0to100(.data$prior_season_routes_pg),
        qb_wow_percent_rank_0to100(.data$prior_season_receiving_yards_pg),
        qb_wow_percent_rank_0to100(.data$prior_season_air_yards_pg),
        qb_wow_percent_rank_0to100(.data$prior_season_first_reads_pg),
        qb_wow_percent_rank_0to100(.data$prior_season_first_downs_pg),
        qb_wow_percent_rank_0to100(.data$prior_season_total_td_pg)
      ),
      career_production_score = qb_wow_row_mean(
        qb_wow_percent_rank_0to100(.data$career_ppg),
        qb_wow_percent_rank_0to100(.data$career_total_fp),
        qb_wow_percent_rank_0to100(.data$career_targets_pg),
        qb_wow_percent_rank_0to100(.data$career_routes_pg),
        qb_wow_percent_rank_0to100(.data$career_receiving_yards_pg),
        qb_wow_percent_rank_0to100(.data$career_air_yards_pg),
        qb_wow_percent_rank_0to100(.data$career_first_reads_pg),
        qb_wow_percent_rank_0to100(.data$career_first_downs_pg),
        qb_wow_percent_rank_0to100(.data$career_total_td_pg)
      ),
      volume_role_component_0to100 = (
        0.22 * qb_wow_percent_rank_0to100(.data$rolling4_targets) +
          0.18 * qb_wow_percent_rank_0to100(.data$rolling6_targets) +
          0.16 * qb_wow_percent_rank_0to100(.data$rolling4_routes) +
          0.14 * qb_wow_percent_rank_0to100(.data$rolling6_routes) +
          0.15 * qb_wow_percent_rank_0to100(.data$rolling4_target_share) +
          0.15 * qb_wow_percent_rank_0to100(.data$rolling4_route_share)
      ),
      first_down_role_component_0to100 = (
        0.20 * qb_wow_percent_rank_0to100(.data$rolling4_first_downs) +
          0.15 * qb_wow_percent_rank_0to100(.data$rolling6_first_downs) +
          0.20 * qb_wow_percent_rank_0to100(.data$rolling4_first_reads) +
          0.15 * qb_wow_percent_rank_0to100(.data$rolling6_first_reads) +
          0.15 * qb_wow_percent_rank_0to100(.data$rolling4_first_read_share) +
          0.15 * qb_wow_percent_rank_0to100(.data$rolling4_first_down_share)
      ),
      recent_stability_component_0to100 = (
        0.25 * qb_wow_percent_rank_0to100(.data$rolling6_fantasy_points_sd, higher_is_better = FALSE) +
          0.20 * qb_wow_percent_rank_0to100(.data$rolling6_targets_sd, higher_is_better = FALSE) +
          0.15 * qb_wow_percent_rank_0to100(.data$rolling6_routes_sd, higher_is_better = FALSE) +
          0.20 * qb_wow_percent_rank_0to100(.data$games_with_5plus_targets_recent_rate) +
          0.20 * qb_wow_percent_rank_0to100(.data$games_with_8plus_targets_recent_rate)
      ),
      priority_air_component_0to100 = (
        0.22 * qb_wow_percent_rank_0to100(.data$rolling4_air_yards) +
          0.18 * qb_wow_percent_rank_0to100(.data$rolling6_air_yards) +
          0.18 * qb_wow_percent_rank_0to100(.data$rolling4_air_share) +
          0.12 * qb_wow_percent_rank_0to100(.data$rolling6_air_share) +
          0.15 * qb_wow_percent_rank_0to100(.data$rolling4_end_zone_targets) +
          0.15 * qb_wow_percent_rank_0to100(.data$air_priority_raw)
      ),
      role_momentum_component_0to100 = (
        0.22 * qb_wow_percent_rank_0to100(.data$trend_targets_4v6) +
          0.18 * qb_wow_percent_rank_0to100(.data$trend_routes_4v6) +
          0.16 * qb_wow_percent_rank_0to100(.data$trend_first_reads_4v6) +
          0.16 * qb_wow_percent_rank_0to100(.data$trend_first_downs_4v6) +
          0.14 * qb_wow_percent_rank_0to100(.data$trend_air_share_4v6) +
          0.14 * qb_wow_percent_rank_0to100(.data$trend_fantasy_points_4v6)
      ),
      shrunk_efficiency_component_0to100 = (
        0.20 * qb_wow_percent_rank_0to100(.data$rolling6_yards_per_route) +
          0.20 * qb_wow_percent_rank_0to100(.data$rolling6_yards_per_target) +
          0.20 * qb_wow_percent_rank_0to100(.data$rolling6_catch_rate) +
          0.20 * qb_wow_percent_rank_0to100(.data$rolling6_first_downs_per_target) +
          0.20 * qb_wow_percent_rank_0to100(.data$efficiency_reliability_raw)
      ),
      td_redzone_component_0to100 = (
        0.35 * qb_wow_percent_rank_0to100(.data$rolling6_total_td) +
          0.25 * qb_wow_percent_rank_0to100(.data$rolling6_end_zone_targets) +
          0.20 * qb_wow_percent_rank_0to100(.data$td_context_raw) +
          0.20 * qb_wow_percent_rank_0to100(.data$team_rec_td_share)
      ),
      wr_weekly_omfg_raw = (
        0.25 * .data$volume_role_component_0to100 +
          0.20 * .data$first_down_role_component_0to100 +
          0.20 * .data$recent_stability_component_0to100 +
          0.175 * .data$priority_air_component_0to100 +
          0.075 * .data$role_momentum_component_0to100 +
          0.05 * .data$shrunk_efficiency_component_0to100 +
          0.05 * .data$td_redzone_component_0to100
      ),
      wr_weekly_omfg_historical_core = pmin(100, pmax(0,
                                                      (.data$wr_weekly_omfg_raw - 10.693704755969726) /
                                                        (86.5094651511017 - 10.693704755969726) * 100
      )),
      qb_context_quality_score = qb_wow_row_mean(
        qb_wow_percent_rank_0to100(.data$rolling3_lead_qb_pass_attempts),
        qb_wow_percent_rank_0to100(.data$rolling3_lead_qb_pass_yards),
        qb_wow_percent_rank_0to100(.data$rolling3_lead_qb_pass_td),
        qb_wow_percent_rank_0to100(.data$rolling3_lead_qb_any_a),
        qb_wow_percent_rank_0to100(.data$rolling3_lead_qb_fp),
        qb_wow_percent_rank_0to100(.data$lead_qb_changed_flag, higher_is_better = FALSE)
      ),
      role_security_component_0to100 = qb_wow_row_mean(
        qb_wow_percent_rank_0to100(.data$rolling4_target_share),
        qb_wow_percent_rank_0to100(.data$rolling4_route_share),
        qb_wow_percent_rank_0to100(.data$rolling4_targets),
        qb_wow_percent_rank_0to100(.data$rolling4_routes),
        qb_wow_percent_rank_0to100(.data$depth_order_current, higher_is_better = FALSE)
      ),
      age_development_component_0to100 = qb_wow_row_mean(
        wr_wow_age_window_score(.data$age),
        qb_wow_percent_rank_0to100(.data$games_played_to_date),
        qb_wow_percent_rank_0to100(.data$depth_order_current, higher_is_better = FALSE)
      ),
      preseason_anchor_score_raw = dplyr::case_when(
        .data$has_prior_season_stats ~
          0.42 * dplyr::coalesce(.data$prior_season_production_score, 0) +
          0.18 * dplyr::coalesce(.data$career_production_score, 0) +
          0.18 * dplyr::coalesce(.data$wow_anchor_rank_component, 0) +
          0.12 * dplyr::coalesce(.data$role_security_component_0to100, 0) +
          0.10 * dplyr::coalesce(.data$draft_day_score_0to100, 50),
        .data$has_career_stats ~
          0.48 * dplyr::coalesce(.data$career_production_score, 0) +
          0.20 * dplyr::coalesce(.data$wow_anchor_rank_component, 0) +
          0.17 * dplyr::coalesce(.data$role_security_component_0to100, 0) +
          0.15 * dplyr::coalesce(.data$draft_day_score_0to100, 50),
        TRUE ~
          0.35 * dplyr::coalesce(.data$wow_anchor_rank_component, 50) +
          0.25 * dplyr::coalesce(.data$role_security_component_0to100, 50) +
          0.20 * dplyr::coalesce(.data$age_development_component_0to100, 50) +
          0.20 * dplyr::coalesce(.data$draft_day_score_0to100, 50)
      ),
      preseason_anchor_score = dplyr::if_else(.data$is_true_rookie, pmin(.data$preseason_anchor_score_raw, 80), .data$preseason_anchor_score_raw),
      wr_in_season_omfg_score = pmin(100, pmax(0,
                                               dplyr::if_else(
                                                 .data$week == 1L,
                                                 .data$preseason_anchor_score,
                                                 .data$preseason_weight * .data$preseason_anchor_score + (1 - .data$preseason_weight) * .data$wr_weekly_omfg_historical_core
                                               )
      )),
      qb_context_modifier = pmin(1.08, pmax(0.90,
                                            1 +
                                              wr_wow_centered_rank(.data$qb_context_quality_score) * 0.08 -
                                              dplyr::coalesce(.data$lead_qb_changed_flag, 0) * 0.04
      )),
      wr_weekly_projection_context_score = pmin(100, pmax(0,
                                                          .data$wr_in_season_omfg_score * .data$qb_context_modifier
      )),
      team_wr_pool_seed = dplyr::coalesce(
        0.55 * .data$rolling4_team_wr_half_ppr +
          0.30 * .data$rolling6_team_wr_half_ppr +
          0.15 * .data$season_to_date_team_wr_half_ppr_pg,
        .data$rolling4_team_wr_half_ppr,
        .data$rolling6_team_wr_half_ppr,
        .data$season_to_date_team_wr_half_ppr_pg,
        .data$team_wr_half_ppr
      ),
      wr_matchup_ease_score = qb_wow_row_mean(
        qb_wow_percent_rank_0to100(.data$trailing5_wr_fp_allowed),
        qb_wow_percent_rank_0to100(.data$trailing5_wr_targets_allowed),
        qb_wow_percent_rank_0to100(.data$trailing5_wr_routes_allowed),
        qb_wow_percent_rank_0to100(.data$trailing5_wr_air_yards_allowed),
        qb_wow_percent_rank_0to100(.data$trailing5_wr_first_reads_allowed),
        qb_wow_percent_rank_0to100(.data$trailing5_wr_first_downs_allowed),
        qb_wow_percent_rank_0to100(.data$trailing5_wr_td_allowed)
      ),
      matchup_modifier = pmin(1.05, pmax(0.95, 1 + wr_wow_centered_rank(.data$wr_matchup_ease_score) * 0.05)),
      role_state_uncertainty_flag = as.integer(
        (!is.na(.data$report_status) & !(.data$report_status %in% c("Active", "Healthy"))) |
          (!is.na(.data$practice_status) & !(.data$practice_status %in% c("Full", "Healthy")))
      ),
      allocation_weight_raw = pmax(0.01,
                                   (
                                     0.28 * dplyr::coalesce(.data$rolling4_target_share, .data$rolling6_target_share, 0) +
                                       0.20 * dplyr::coalesce(.data$rolling4_route_share, .data$rolling6_route_share, 0) +
                                       0.16 * dplyr::coalesce(.data$rolling4_air_share, .data$rolling6_air_share, 0) +
                                       0.14 * dplyr::coalesce(.data$rolling4_first_read_share, .data$rolling6_first_read_share, 0) +
                                       0.12 * dplyr::coalesce(.data$rolling4_first_down_share, .data$rolling6_first_down_share, 0) +
                                       0.10 * dplyr::coalesce(.data$rolling4_fantasy_share, .data$rolling6_fantasy_share, 0)
                                   ) *
                                     pmin(1.22, pmax(0.78,
                                                     1 +
                                                       wr_wow_centered_rank(.data$wr_in_season_omfg_score) * 0.12 +
                                                       wr_wow_centered_rank(.data$role_momentum_component_0to100) * 0.05 +
                                                       wr_wow_centered_rank(.data$role_security_component_0to100) * 0.05 -
                                                       dplyr::coalesce(.data$role_state_uncertainty_flag, 0) * 0.06
                                     ))
      ),
      team_wr_pool_after_context = .data$team_wr_pool_seed * .data$qb_context_modifier * .data$matchup_modifier
    ) |>
    dplyr::mutate(
      allocation_weight_sum = stats::ave(
        dplyr::coalesce(.data$allocation_weight_raw, 0),
        interaction(.data$season, .data$feature_week, .data$team, drop = TRUE),
        FUN = function(x) sum(x, na.rm = TRUE)
      ),
      player_allocation_share = ifelse(
        is.finite(.data$allocation_weight_sum) & .data$allocation_weight_sum > 0,
        .data$allocation_weight_raw / .data$allocation_weight_sum,
        NA_real_
      ),
      weekly_central_projection = dplyr::coalesce(.data$team_wr_pool_after_context, .data$team_wr_pool_seed) * .data$player_allocation_share,
      uncertainty_component_0to100 = qb_wow_row_mean(
        qb_wow_percent_rank_0to100(.data$rolling6_fantasy_points_sd),
        qb_wow_percent_rank_0to100(.data$rolling6_targets_sd),
        qb_wow_percent_rank_0to100(.data$rolling6_routes_sd),
        qb_wow_percent_rank_0to100(.data$role_state_uncertainty_flag),
        qb_wow_percent_rank_0to100(.data$lead_qb_changed_flag),
        qb_wow_percent_rank_0to100(.data$depth_order_current)
      ),
      weekly_role_class = dplyr::case_when(
        dplyr::coalesce(.data$player_allocation_share, 0) >= 0.24 | dplyr::coalesce(.data$rolling4_target_share, 0) >= 0.24 ~ "Alpha",
        dplyr::coalesce(.data$player_allocation_share, 0) >= 0.17 | dplyr::coalesce(.data$rolling4_target_share, 0) >= 0.17 ~ "Core",
        dplyr::coalesce(.data$player_allocation_share, 0) >= 0.10 | dplyr::coalesce(.data$rolling4_target_share, 0) >= 0.10 ~ "Flex",
        dplyr::coalesce(.data$player_allocation_share, 0) >= 0.05 ~ "Fragile",
        TRUE ~ "Contingent"
      ),
      lower_tail_base = dplyr::case_when(
        .data$weekly_role_class == "Alpha" ~ 0.38,
        .data$weekly_role_class == "Core" ~ 0.48,
        .data$weekly_role_class == "Flex" ~ 0.62,
        .data$weekly_role_class == "Fragile" ~ 0.80,
        TRUE ~ 0.92
      ),
      upper_tail_base = dplyr::case_when(
        .data$weekly_role_class == "Alpha" ~ 0.62,
        .data$weekly_role_class == "Core" ~ 0.70,
        .data$weekly_role_class == "Flex" ~ 0.86,
        .data$weekly_role_class == "Fragile" ~ 1.02,
        TRUE ~ 1.18
      ),
      uncertainty_multiplier = 0.85 + dplyr::coalesce(.data$uncertainty_component_0to100, 50) / 100 * 0.50,
      weekly_p50_projection = .data$weekly_central_projection,
      weekly_p25_projection = pmax(0, .data$weekly_central_projection * (1 - .data$lower_tail_base * 0.55 * .data$uncertainty_multiplier)),
      weekly_p10_projection = pmax(0, .data$weekly_central_projection * (1 - .data$lower_tail_base * .data$uncertainty_multiplier)),
      weekly_p75_projection = .data$weekly_central_projection * (1 + .data$upper_tail_base * 0.50 * .data$uncertainty_multiplier),
      weekly_p90_projection = .data$weekly_central_projection * (1 + .data$upper_tail_base * .data$uncertainty_multiplier),
      weekly_average_range_score = (0.15 * .data$weekly_p25_projection) + (0.55 * .data$weekly_p50_projection) + (0.30 * .data$weekly_p75_projection)
    ) |>
    dplyr::mutate(
      week_projection_sd = stats::sd(.data$weekly_central_projection, na.rm = TRUE),
      week_scale = pmax(1.25, dplyr::coalesce(.data$week_projection_sd, 1.25) * 0.30),
      cutoff_top5 = dplyr::nth(sort(.data$weekly_central_projection, decreasing = TRUE), pmin(5L, dplyr::n())),
      cutoff_top12 = dplyr::nth(sort(.data$weekly_central_projection, decreasing = TRUE), pmin(12L, dplyr::n())),
      cutoff_top24 = dplyr::nth(sort(.data$weekly_central_projection, decreasing = TRUE), pmin(24L, dplyr::n())),
      cutoff_top36 = dplyr::nth(sort(.data$weekly_central_projection, decreasing = TRUE), pmin(36L, dplyr::n())),
      cutoff_top48 = dplyr::nth(sort(.data$weekly_central_projection, decreasing = TRUE), pmin(48L, dplyr::n())),
      probability_top5 = stats::plogis((.data$weekly_central_projection - .data$cutoff_top5) / .data$week_scale),
      probability_top12 = stats::plogis((.data$weekly_central_projection - .data$cutoff_top12) / .data$week_scale),
      probability_top24 = stats::plogis((.data$weekly_central_projection - .data$cutoff_top24) / .data$week_scale),
      probability_top36 = stats::plogis((.data$weekly_central_projection - .data$cutoff_top36) / .data$week_scale),
      probability_top48 = stats::plogis((.data$weekly_central_projection - .data$cutoff_top48) / .data$week_scale),
      weekly_central_projection_rank = qb_wow_percent_rank_0to100(.data$weekly_central_projection),
      weekly_average_range_rank = qb_wow_percent_rank_0to100(.data$weekly_average_range_score),
      wr_anchor_rank_component = qb_wow_percent_rank_0to100(.data$wr_wow_anchor_fp),
      wr_weekly_board_score = qb_wow_row_mean(
        .data$weekly_central_projection_rank,
        .data$weekly_average_range_rank,
        .data$wr_anchor_rank_component,
        .data$wr_weekly_projection_context_score,
        .data$volume_role_component_0to100,
        .data$first_down_role_component_0to100,
        .data$priority_air_component_0to100
      ),
      week1_score_num =
        0.25 * dplyr::coalesce(.data$preseason_anchor_score, 0) +
        0.20 * dplyr::coalesce(.data$wr_weekly_projection_context_score, 0) +
        0.15 * dplyr::coalesce(.data$weekly_central_projection_rank, 0) +
        0.15 * dplyr::coalesce(.data$weekly_average_range_rank, 0) +
        0.15 * dplyr::coalesce(.data$role_security_component_0to100, 0) +
        0.10 * dplyr::coalesce(.data$age_development_component_0to100, 0),
      week1_score_den =
        0.25 * as.numeric(is.finite(.data$preseason_anchor_score)) +
        0.20 * as.numeric(is.finite(.data$wr_weekly_projection_context_score)) +
        0.15 * as.numeric(is.finite(.data$weekly_central_projection_rank)) +
        0.15 * as.numeric(is.finite(.data$weekly_average_range_rank)) +
        0.15 * as.numeric(is.finite(.data$role_security_component_0to100)) +
        0.10 * as.numeric(is.finite(.data$age_development_component_0to100)),
      later_score_num =
        0.30 * dplyr::coalesce(.data$wr_weekly_board_score, 0) +
        0.22 * dplyr::coalesce(.data$wr_weekly_projection_context_score, 0) +
        0.18 * dplyr::coalesce(.data$weekly_central_projection_rank, 0) +
        0.10 * dplyr::coalesce(.data$weekly_average_range_rank, 0) +
        0.10 * (dplyr::coalesce(.data$probability_top24, 0) * 100) +
        0.10 * dplyr::coalesce(.data$role_momentum_component_0to100, 0),
      later_score_den =
        0.30 * as.numeric(is.finite(.data$wr_weekly_board_score)) +
        0.22 * as.numeric(is.finite(.data$wr_weekly_projection_context_score)) +
        0.18 * as.numeric(is.finite(.data$weekly_central_projection_rank)) +
        0.10 * as.numeric(is.finite(.data$weekly_average_range_rank)) +
        0.10 * as.numeric(is.finite(.data$probability_top24)) +
        0.10 * as.numeric(is.finite(.data$role_momentum_component_0to100)),
      wr_wow_final_score = dplyr::if_else(
        .data$week <= 1L,
        dplyr::if_else(.data$week1_score_den > 0, .data$week1_score_num / .data$week1_score_den, NA_real_),
        dplyr::if_else(.data$later_score_den > 0, .data$later_score_num / .data$later_score_den, NA_real_)
      )
    ) |>
    dplyr::group_by(.data$season, .data$feature_week) |>
    dplyr::arrange(dplyr::desc(.data$wr_wow_final_score), .data$player, .by_group = TRUE) |>
    dplyr::mutate(
      weekly_role_rank = dplyr::min_rank(dplyr::desc(.data$player_allocation_share)),
      wr_wow_rank = dplyr::row_number(),
      wr_wow_tier = dplyr::case_when(
        .data$wr_wow_rank <= 6 ~ "Tier 1",
        .data$wr_wow_rank <= 12 ~ "Tier 2",
        .data$wr_wow_rank <= 24 ~ "Tier 3",
        .data$wr_wow_rank <= 36 ~ "Tier 4",
        .data$wr_wow_rank <= 48 ~ "Tier 5",
        TRUE ~ "Tier 6"
      ),
      replacement_starter_flag = as.integer(!is.na(.data$depth_order_current) & .data$depth_order_current <= 2 & dplyr::coalesce(.data$trend_route_share_4v6, 0) > 0.02),
      starter_return_flag = as.integer(!is.na(.data$report_status) & .data$report_status %in% c("Questionable", "Doubtful") & dplyr::coalesce(.data$weekly_role_class, "") %in% c("Alpha", "Core")),
      high_variance_rotation_flag = as.integer(.data$weekly_role_class %in% c("Fragile", "Contingent") | dplyr::coalesce(.data$uncertainty_component_0to100, 0) >= 70),
      review_flags = trimws(paste(
        ifelse(.data$lead_qb_changed_flag == 1, "QB change", ""),
        ifelse(.data$role_state_uncertainty_flag == 1, "Injury/ramp", ""),
        ifelse(.data$replacement_starter_flag == 1, "Replacement starter", ""),
        ifelse(.data$starter_return_flag == 1, "Starter return", ""),
        ifelse(.data$high_variance_rotation_flag == 1, "High variance", "")
      ))
    ) |>
    dplyr::ungroup() |>
    dplyr::arrange(.data$season, .data$feature_week, .data$wr_wow_rank)
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "wr_wow_feature_overlay_2021_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_wr_wow_board_summary <- function(wr_wow_board, write_output = TRUE) {
  load_model_core_packages()
  
  week_metrics <- wr_wow_board |>
    dplyr::group_by(.data$season, .data$feature_week) |>
    dplyr::summarise(
      n = sum(is.finite(.data$wr_wow_rank) & is.finite(.data$target_week_fp)),
      spearman = {
        keep <- is.finite(.data$wr_wow_rank) & is.finite(.data$target_week_fp)
        if (sum(keep) > 1) {
          suppressWarnings(stats::cor(-.data$wr_wow_rank[keep], .data$target_week_fp[keep], method = "spearman"))
        } else {
          NA_real_
        }
      },
      .groups = "drop"
    ) |>
    dplyr::mutate(
      predicts_week = .data$feature_week + 1L,
      is_scorable = as.integer(.data$n > 1 & is.finite(.data$spearman))
    )
  
  summary_out <- week_metrics |>
    dplyr::group_by(.data$season) |>
    dplyr::summarise(
      weeks_total = dplyr::n(),
      weeks = sum(.data$is_scorable, na.rm = TRUE),
      scorable_weeks = sum(.data$is_scorable, na.rm = TRUE),
      avg_spearman = if (sum(.data$is_scorable, na.rm = TRUE) > 0) {
        mean(.data$spearman[.data$is_scorable == 1L], na.rm = TRUE)
      } else {
        NA_real_
      },
      median_spearman = if (sum(.data$is_scorable, na.rm = TRUE) > 0) {
        stats::median(.data$spearman[.data$is_scorable == 1L], na.rm = TRUE)
      } else {
        NA_real_
      },
      min_spearman = if (sum(.data$is_scorable, na.rm = TRUE) > 0) {
        min(.data$spearman[.data$is_scorable == 1L], na.rm = TRUE)
      } else {
        NA_real_
      },
      max_spearman = if (sum(.data$is_scorable, na.rm = TRUE) > 0) {
        max(.data$spearman[.data$is_scorable == 1L], na.rm = TRUE)
      } else {
        NA_real_
      },
      weeks_over_0 = sum(.data$spearman[.data$is_scorable == 1L] > 0, na.rm = TRUE),
      weeks_over_030 = sum(.data$spearman[.data$is_scorable == 1L] >= 0.30, na.rm = TRUE),
      weeks_over_040 = sum(.data$spearman[.data$is_scorable == 1L] >= 0.40, na.rm = TRUE),
      .groups = "drop"
    ) |>
    dplyr::arrange(.data$season)
  
  if (write_output) {
    utils::write.csv(
      week_metrics,
      file.path(model_paths$wow_output_dir, "wr_wow_board_metrics_2021_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    utils::write.csv(
      summary_out,
      file.path(model_paths$wow_output_dir, "wr_wow_board_summary_2021_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    week_metrics = week_metrics,
    summary = summary_out
  )
}

build_wr_wow_final_export <- function(wr_wow_board, write_output = TRUE) {
  load_model_core_packages()
  
  out <- wr_wow_board |>
    dplyr::transmute(
      season = .data$season,
      week = .data$feature_week,
      predicts_week = .data$next_week,
      rank = .data$wr_wow_rank,
      tier = .data$wr_wow_tier,
      player = .data$player,
      team = .data$team,
      opponent = .data$next_week_opponent,
      depth_team = .data$depth_team,
      report_status = .data$report_status,
      practice_status = .data$practice_status,
      weekly_role_class = .data$weekly_role_class,
      weekly_role_rank = .data$weekly_role_rank,
      final_score = .data$wr_wow_final_score,
      weekly_board_score = .data$wr_weekly_board_score,
      in_season_omfg = .data$wr_in_season_omfg_score,
      weekly_omfg_core = .data$wr_weekly_omfg_historical_core,
      weekly_omfg_projection_context = .data$wr_weekly_projection_context_score,
      anchor_fp = .data$wr_wow_anchor_fp,
      projected_fp = .data$weekly_central_projection,
      p10_injury_tail = .data$weekly_p10_projection,
      p25_probable_floor = .data$weekly_p25_projection,
      p50_median = .data$weekly_p50_projection,
      p75_probable_ceiling = .data$weekly_p75_projection,
      p90_spike_ceiling = .data$weekly_p90_projection,
      average_range_score = .data$weekly_average_range_score,
      probability_top5 = .data$probability_top5,
      probability_top12 = .data$probability_top12,
      probability_top24 = .data$probability_top24,
      probability_top36 = .data$probability_top36,
      probability_top48 = .data$probability_top48,
      qb_context_modifier = .data$qb_context_modifier,
      matchup_modifier = .data$matchup_modifier,
      player_allocation_share = .data$player_allocation_share,
      role_state_uncertainty_flag = .data$role_state_uncertainty_flag,
      replacement_starter_flag = .data$replacement_starter_flag,
      starter_return_flag = .data$starter_return_flag,
      high_variance_rotation_flag = .data$high_variance_rotation_flag,
      review_flags = .data$review_flags,
      actual_next_week_fp = .data$target_week_fp
    ) |>
    dplyr::arrange(.data$season, .data$week, .data$rank)
  
  if (write_output) {
    utils::write.csv(
      out,
      file.path(model_paths$wow_output_dir, "wr_wow_final_export_2021_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

run_wr_wow_board_rebuild <- function(write_output = TRUE) {
  load_model_core_packages()
  
  wr_wow_board <- build_wr_wow_feature_overlay_table(write_output = write_output)
  wr_wow_board_summary <- build_wr_wow_board_summary(wr_wow_board, write_output = write_output)
  wr_wow_final_export <- build_wr_wow_final_export(wr_wow_board, write_output = write_output)
  
  list(
    board = wr_wow_board,
    board_summary = wr_wow_board_summary,
    final_export = wr_wow_final_export
  )
}

te_wow_handoff <- get_handoff_spec("TE", "week_over_week")

te_half_ppr_points_formula <- function(receiving_yards, receptions, total_td, rush_yards = 0) {
  receiving_yards <- safe_numeric(receiving_yards)
  receptions <- safe_numeric(receptions)
  total_td <- safe_numeric(total_td)
  rush_yards <- safe_numeric(rush_yards)
  
  receiving_yards[!is.finite(receiving_yards)] <- 0
  receptions[!is.finite(receptions)] <- 0
  total_td[!is.finite(total_td)] <- 0
  rush_yards[!is.finite(rush_yards)] <- 0
  
  receiving_yards / 10 +
    receptions * 0.5 +
    total_td * 6 +
    rush_yards / 10
}

te_wow_age_window_score <- function(age_vec) {
  age_vec <- safe_numeric(age_vec)
  out <- 100 - pmin(abs(age_vec - 27) * 7, 100)
  out[!is.finite(age_vec)] <- NA_real_
  out
}

te_wow_centered_rank <- function(x, higher_is_better = TRUE) {
  (qb_wow_percent_rank_0to100(x, higher_is_better = higher_is_better) - 50) / 50
}

build_te_clean_weekly_master <- function(write_output = FALSE, output_dir = model_paths$foundation_output_dir) {
  load_model_core_packages()
  
  te_raw <- load_position_hybrid("TE")
  
  te_weekly <- te_raw |>
    dplyr::transmute(
      season = .data$season,
      week = .data$week,
      game_number = .data$game_number,
      player = .data$player_name,
      player_key = .data$player_key,
      team = .data$team,
      opponent = .data$opponent_team,
      position = .data$position,
      depth_team = .data$depth_team_num,
      te_depth_role = pick_first_existing_character(te_raw, c("TE_Depth_Role")),
      draft_day = pick_first_existing_character(te_raw, c("Draft_Day")),
      report_status = pick_first_existing_character(te_raw, c("report_status")),
      practice_primary_injury = pick_first_existing_character(te_raw, c("practice_primary_injury")),
      practice_secondary_injury = pick_first_existing_character(te_raw, c("practice_secondary_injury")),
      practice_status = pick_first_existing_character(te_raw, c("practice_status")),
      birth_date = pick_first_existing_character(te_raw, c("birth_date")),
      rookie_year = .data$rookie_year_num,
      age = .data$age_num,
      routes = pick_first_existing_numeric(te_raw, c("RTE", "RTE_ply")),
      route_pct = pick_first_existing_numeric(te_raw, c("RTE_PCT")),
      targets_primary = pick_first_existing_numeric(te_raw, c("TGT_ply")),
      targets_fallback = pick_first_existing_numeric(te_raw, c("TGT")),
      team_total_targets_source = pick_first_existing_numeric(te_raw, c("TM_TGT", "TGT_team")),
      receptions = pick_first_existing_numeric(te_raw, c("REC", "REC_ply")),
      receiving_yards = pick_first_existing_numeric(te_raw, c("YDS", "YDS_ply")),
      receiving_td = pick_first_existing_numeric(te_raw, c("TD", "TD_ply")),
      receiving_yards_per_game_source = pick_first_existing_numeric(te_raw, c("RecYDS_G")),
      air_yards = pick_first_existing_numeric(te_raw, c("AY", "AY_ply")),
      air_yards_share = pick_first_existing_numeric(te_raw, c("AY_Share")),
      adot = pick_first_existing_numeric(te_raw, c("aDOT", "aDOT_ply")),
      targets_per_route_source = pick_first_existing_numeric(te_raw, c("TPRR")),
      catch_rate_source = pick_first_existing_numeric(te_raw, c("Catch_Rate")),
      yards_per_route_source = pick_first_existing_numeric(te_raw, c("YPRR")),
      yards_per_target_source = pick_first_existing_numeric(te_raw, c("YPT")),
      yards_per_reception_source = pick_first_existing_numeric(te_raw, c("YPR")),
      yac_total = pick_first_existing_numeric(te_raw, c("YAC")),
      yac_per_reception_source = pick_first_existing_numeric(te_raw, c("YAC_REC")),
      yaco_rec = pick_first_existing_numeric(te_raw, c("YACO_rec", "YACO_REC")),
      team_rec_yards_share = pick_first_existing_numeric(te_raw, c("TM_RecYDS_PCT")),
      team_rec_td_share = pick_first_existing_numeric(te_raw, c("TM_Rec_TD_PCT", "TM_RecTD_PCT")),
      first_read_targets = pick_first_existing_numeric(te_raw, c("X1READ")),
      first_read_target_share = pick_first_existing_numeric(te_raw, c("X1READ_Rec_PCT", "X1READ_PCT")),
      receiving_first_downs = pick_first_existing_numeric(te_raw, c("X1D_rec")),
      first_downs_per_route_source = pick_first_existing_numeric(te_raw, c("X1D_RR")),
      end_zone_targets = pick_first_existing_numeric(te_raw, c("EZTGT")),
      end_zone_tds = pick_first_existing_numeric(te_raw, c("EZTD")),
      drops = pick_first_existing_numeric(te_raw, c("DRP")),
      drop_pct = pick_first_existing_numeric(te_raw, c("DROP_PCT", "DRP_RATE")),
      catchable_targets = pick_first_existing_numeric(te_raw, c("CTGT")),
      catchable_tgt_pct = pick_first_existing_numeric(te_raw, c("Catchable_TGT_PCT", "Catchable_TGT_Rate", "CTGT_RATE")),
      designed_targets = pick_first_existing_numeric(te_raw, c("DESIGN")),
      design_pct = pick_first_existing_numeric(te_raw, c("DESIGN_PCT", "DESIGN_RATE")),
      contested_targets = pick_first_existing_numeric(te_raw, c("CT")),
      contested_catches = pick_first_existing_numeric(te_raw, c("CC")),
      contested_catch_pct = pick_first_existing_numeric(te_raw, c("Contested_Catch_PCT", "Contested_Catch_Rate", "CC_RATE")),
      hero_targets = pick_first_existing_numeric(te_raw, c("HERO")),
      target_rate = pick_first_existing_numeric(te_raw, c("RATE", "RATE_rec")),
      threat_score = pick_first_existing_numeric(te_raw, c("THREAT")),
      yptoe = pick_first_existing_numeric(te_raw, c("YPTOE")),
      wide_rte_pct = pick_first_existing_numeric(te_raw, c("WIDE_RTE_PCT")),
      slot_rte_pct = pick_first_existing_numeric(te_raw, c("SLOT_RTE_PCT")),
      inline_rte_pct = pick_first_existing_numeric(te_raw, c("INLINE_RTE_PCT")),
      backfield_rte_pct = pick_first_existing_numeric(te_raw, c("BACK_RTE_PCT")),
      rush_attempts = pick_first_existing_numeric(te_raw, c("CAR", "CAR_ply")),
      rush_yards = pick_first_existing_numeric(te_raw, c("YDS_rush", "YDS_rush_ply")),
      rush_td = pick_first_existing_numeric(te_raw, c("TD_rush", "TD_rush_ply")),
      fantasy_points_source = dplyr::coalesce(
        pick_first_existing_numeric(te_raw, c("fantasyPts")),
        pick_first_existing_numeric(te_raw, c("FP_rec")),
        pick_first_existing_numeric(te_raw, c("FP_G_rec")),
        pick_first_existing_numeric(te_raw, c("FP_G"))
      ),
      source_file = pick_first_existing_character(te_raw, c("dataset_file"))
    ) |>
    dplyr::filter(!is.na(.data$season), !is.na(.data$week), .data$week >= 1, .data$week <= 18) |>
    dplyr::mutate(
      team = normalize_team_abbr(.data$team),
      opponent = normalize_team_abbr(.data$opponent),
      targets = dplyr::if_else(
        !is.na(.data$targets_primary) & .data$targets_primary > 0,
        .data$targets_primary,
        dplyr::coalesce(.data$targets_fallback, 0)
      ),
      team_total_targets = dplyr::coalesce(.data$team_total_targets_source, 0),
      total_td = dplyr::coalesce(.data$receiving_td, 0) + dplyr::coalesce(.data$rush_td, 0),
      scrimmage_yards = dplyr::coalesce(.data$receiving_yards, 0) + dplyr::coalesce(.data$rush_yards, 0),
      half_ppr_points = te_half_ppr_points_formula(
        .data$receiving_yards,
        .data$receptions,
        .data$total_td,
        .data$rush_yards
      ),
      fantasy_points_calc = dplyr::coalesce(.data$half_ppr_points, .data$fantasy_points_source),
      targets_per_route = dplyr::coalesce(.data$targets_per_route_source, safe_div(.data$targets, .data$routes)),
      catch_rate = dplyr::coalesce(.data$catch_rate_source, 100 * safe_div(.data$receptions, .data$targets)),
      receiving_yards_per_game = dplyr::coalesce(.data$receiving_yards_per_game_source, .data$receiving_yards),
      yards_per_route = dplyr::coalesce(.data$yards_per_route_source, safe_div(.data$receiving_yards, .data$routes)),
      yards_per_target = dplyr::coalesce(.data$yards_per_target_source, safe_div(.data$receiving_yards, .data$targets)),
      yards_per_reception = dplyr::coalesce(.data$yards_per_reception_source, safe_div(.data$receiving_yards, .data$receptions)),
      yac_per_reception = dplyr::coalesce(.data$yac_per_reception_source, safe_div(.data$yac_total, .data$receptions)),
      air_yards_per_target = safe_div(.data$air_yards, .data$targets),
      first_downs_per_route = dplyr::coalesce(.data$first_downs_per_route_source, safe_div(.data$receiving_first_downs, .data$routes)),
      first_downs_per_target = safe_div(.data$receiving_first_downs, .data$targets),
      first_reads_per_target = safe_div(.data$first_read_targets, .data$targets),
      end_zone_target_rate = safe_div(.data$end_zone_targets, .data$targets),
      td_per_target = safe_div(.data$receiving_td, .data$targets),
      te_model_eligible = .data$position == "TE",
      regular_season_flag = TRUE
    ) |>
    dplyr::select(
      -dplyr::any_of(c(
        "targets_primary", "targets_fallback", "team_total_targets_source", "receiving_yards_per_game_source",
        "targets_per_route_source", "catch_rate_source", "yards_per_route_source", "yards_per_target_source",
        "yards_per_reception_source", "yac_per_reception_source", "first_downs_per_route_source"
      ))
    ) |>
    dplyr::arrange(.data$season, .data$week, .data$team, .data$player)
  
  duplicate_keys <- te_weekly |>
    dplyr::count(.data$season, .data$week, .data$player_key, name = "dup_n") |>
    dplyr::filter(.data$dup_n > 1)
  
  if (nrow(duplicate_keys) > 0) {
    conflict_columns <- c(
      "team", "opponent", "position", "routes", "targets", "receptions",
      "receiving_yards", "receiving_td", "air_yards", "end_zone_targets",
      "first_read_targets", "receiving_first_downs", "rush_attempts",
      "rush_yards", "rush_td", "total_td", "half_ppr_points"
    )
    conflicting_keys <- te_weekly |>
      dplyr::semi_join(duplicate_keys, by = c("season", "week", "player_key")) |>
      dplyr::group_by(.data$season, .data$week, .data$player_key) |>
      dplyr::summarise(
        conflict = any(vapply(
          dplyr::pick(dplyr::all_of(conflict_columns)),
          function(x) dplyr::n_distinct(x, na.rm = FALSE) > 1L,
          logical(1)
        )),
        .groups = "drop"
      ) |>
      dplyr::filter(.data$conflict)
    
    if (nrow(conflicting_keys) > 0) {
      stop(
        paste0(
          "TE clean weekly master has ", nrow(conflicting_keys),
          " conflicting player-week duplicates; inspect the hybrid source before modeling."
        ),
        call. = FALSE
      )
    }
  }
  
  completeness_columns <- c(
    "routes", "targets", "receptions", "receiving_yards", "receiving_td",
    "air_yards", "end_zone_targets", "first_read_targets",
    "receiving_first_downs", "rush_attempts", "rush_yards", "rush_td",
    "half_ppr_points", "depth_team", "opponent"
  )
  te_weekly <- te_weekly |>
    dplyr::mutate(
      .te_row_completeness = rowSums(!is.na(dplyr::pick(dplyr::all_of(completeness_columns))))
    ) |>
    dplyr::arrange(
      .data$season, .data$week, .data$player_key,
      dplyr::desc(.data$.te_row_completeness),
      dplyr::desc(!is.na(.data$source_file) & .data$source_file != "")
    ) |>
    dplyr::distinct(.data$season, .data$week, .data$player_key, .keep_all = TRUE) |>
    dplyr::select(-dplyr::all_of(".te_row_completeness"))
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      te_weekly,
      file.path(output_dir, "te_clean_weekly_master_2021_2025_regular.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  te_weekly
}

build_te_team_week_opportunity_table <- function(
    te_weekly = build_te_clean_weekly_master(),
    write_output = FALSE,
    output_dir = model_paths$foundation_output_dir
) {
  load_model_core_packages()
  
  out <- te_weekly |>
    dplyr::filter(.data$te_model_eligible) |>
    dplyr::group_by(.data$season, .data$week, .data$team) |>
    dplyr::summarise(
      team_te_targets = sum(.data$targets, na.rm = TRUE),
      team_te_receptions = sum(.data$receptions, na.rm = TRUE),
      team_te_routes = sum(.data$routes, na.rm = TRUE),
      team_te_receiving_yards = sum(.data$receiving_yards, na.rm = TRUE),
      team_te_air_yards = sum(.data$air_yards, na.rm = TRUE),
      team_te_first_reads = sum(.data$first_read_targets, na.rm = TRUE),
      team_te_first_downs = sum(.data$receiving_first_downs, na.rm = TRUE),
      team_te_end_zone_targets = sum(.data$end_zone_targets, na.rm = TRUE),
      team_te_total_td = sum(.data$total_td, na.rm = TRUE),
      team_te_half_ppr = sum(.data$half_ppr_points, na.rm = TRUE),
      .groups = "drop"
    )
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "te_team_week_opportunity_2021_2025_regular.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_te_player_share_table <- function(
    te_weekly = build_te_clean_weekly_master(),
    team_week = build_te_team_week_opportunity_table(te_weekly),
    write_output = FALSE,
    output_dir = model_paths$foundation_output_dir
) {
  load_model_core_packages()
  
  out <- te_weekly |>
    dplyr::left_join(team_week, by = c("season", "week", "team")) |>
    dplyr::mutate(
      team_target_share = safe_div(.data$targets, .data$team_te_targets),
      team_rec_share = safe_div(.data$receptions, .data$team_te_receptions),
      team_route_share = safe_div(.data$routes, .data$team_te_routes),
      team_air_share = safe_div(.data$air_yards, .data$team_te_air_yards),
      team_first_read_share = safe_div(.data$first_read_targets, .data$team_te_first_reads),
      team_first_down_share = safe_div(.data$receiving_first_downs, .data$team_te_first_downs),
      team_end_zone_target_share = safe_div(.data$end_zone_targets, .data$team_te_end_zone_targets),
      team_fantasy_share = safe_div(.data$half_ppr_points, .data$team_te_half_ppr),
      starter_flag = dplyr::if_else(!is.na(.data$depth_team) & .data$depth_team <= 1, 1L, 0L)
    )
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "te_player_share_table_2021_2025_regular.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_te_team_context_base <- function(
    te_share = build_te_player_share_table(write_output = FALSE),
    write_output = FALSE,
    output_dir = model_paths$wow_output_dir
) {
  load_model_core_packages()
  
  out <- te_share |>
    dplyr::distinct(
      .data$season,
      .data$week,
      .data$team,
      .data$team_te_targets,
      .data$team_te_receptions,
      .data$team_te_routes,
      .data$team_te_receiving_yards,
      .data$team_te_air_yards,
      .data$team_te_first_reads,
      .data$team_te_first_downs,
      .data$team_te_end_zone_targets,
      .data$team_te_total_td,
      .data$team_te_half_ppr
    ) |>
    dplyr::arrange(.data$team, .data$season, .data$week) |>
    dplyr::group_by(.data$team, .data$season) |>
    dplyr::mutate(
      team_games_played_to_date = dplyr::row_number(),
      season_to_date_team_te_half_ppr_pg = cumsum(dplyr::coalesce(.data$team_te_half_ppr, 0)) / team_games_played_to_date,
      rolling4_team_te_half_ppr = rolling_mean_vec(.data$team_te_half_ppr, 4),
      rolling6_team_te_half_ppr = rolling_mean_vec(.data$team_te_half_ppr, 6),
      rolling4_team_te_targets = rolling_mean_vec(.data$team_te_targets, 4),
      rolling6_team_te_targets = rolling_mean_vec(.data$team_te_targets, 6),
      rolling4_team_te_routes = rolling_mean_vec(.data$team_te_routes, 4),
      rolling6_team_te_routes = rolling_mean_vec(.data$team_te_routes, 6),
      rolling4_team_te_air_yards = rolling_mean_vec(.data$team_te_air_yards, 4),
      rolling6_team_te_air_yards = rolling_mean_vec(.data$team_te_air_yards, 6),
      rolling4_team_te_first_reads = rolling_mean_vec(.data$team_te_first_reads, 4),
      rolling6_team_te_first_reads = rolling_mean_vec(.data$team_te_first_reads, 6),
      rolling4_team_te_first_downs = rolling_mean_vec(.data$team_te_first_downs, 4),
      rolling6_team_te_first_downs = rolling_mean_vec(.data$team_te_first_downs, 6),
      rolling4_team_te_end_zone_targets = rolling_mean_vec(.data$team_te_end_zone_targets, 4),
      rolling6_team_te_end_zone_targets = rolling_mean_vec(.data$team_te_end_zone_targets, 6),
      rolling4_team_te_total_td = rolling_mean_vec(.data$team_te_total_td, 4),
      rolling6_team_te_total_td = rolling_mean_vec(.data$team_te_total_td, 6)
    ) |>
    dplyr::ungroup()
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "te_team_context_base_2021_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_te_weekly_feature_base <- function(write_output = FALSE, output_dir = model_paths$wow_output_dir) {
  load_model_core_packages()
  
  te_share <- build_te_player_share_table(write_output = FALSE)
  te_team_context <- build_te_team_context_base(te_share, write_output = write_output, output_dir = output_dir)
  
  out <- te_share |>
    dplyr::filter(.data$te_model_eligible) |>
    dplyr::left_join(
      te_team_context,
      by = c("season", "week", "team", "team_te_targets", "team_te_receptions", "team_te_routes",
             "team_te_receiving_yards", "team_te_air_yards", "team_te_first_reads",
             "team_te_first_downs", "team_te_end_zone_targets", "team_te_total_td", "team_te_half_ppr")
    ) |>
    dplyr::arrange(.data$player_key, .data$season, .data$week) |>
    dplyr::group_by(.data$player_key, .data$season) |>
    dplyr::mutate(
      feature_week = .data$week,
      next_week = .data$week + 1L,
      next_week_opponent = dplyr::lead(.data$opponent),
      next_week_fantasy_points = dplyr::lead(.data$half_ppr_points),
      next_week_targets = dplyr::lead(.data$targets),
      next_week_routes = dplyr::lead(.data$routes),
      next_week_receiving_yards = dplyr::lead(.data$receiving_yards),
      next_week_total_td = dplyr::lead(.data$total_td),
      next_week_air_yards = dplyr::lead(.data$air_yards),
      next_week_first_read_targets = dplyr::lead(.data$first_read_targets),
      next_week_first_downs = dplyr::lead(.data$receiving_first_downs),
      games_played_to_date = dplyr::row_number(),
      season_to_date_fantasy_points = cumsum(dplyr::coalesce(.data$half_ppr_points, 0)),
      season_to_date_fantasy_points_per_game = season_to_date_fantasy_points / games_played_to_date,
      season_to_date_targets_per_game = cumsum(dplyr::coalesce(.data$targets, 0)) / games_played_to_date,
      season_to_date_routes_per_game = cumsum(dplyr::coalesce(.data$routes, 0)) / games_played_to_date,
      season_to_date_air_yards_per_game = cumsum(dplyr::coalesce(.data$air_yards, 0)) / games_played_to_date,
      season_to_date_first_reads_per_game = cumsum(dplyr::coalesce(.data$first_read_targets, 0)) / games_played_to_date,
      season_to_date_first_downs_per_game = cumsum(dplyr::coalesce(.data$receiving_first_downs, 0)) / games_played_to_date,
      season_to_date_receiving_yards_per_game = cumsum(dplyr::coalesce(.data$receiving_yards, 0)) / games_played_to_date,
      rolling4_fantasy_points = rolling_mean_vec(.data$half_ppr_points, 4),
      rolling6_fantasy_points = rolling_mean_vec(.data$half_ppr_points, 6),
      rolling4_targets = rolling_mean_vec(.data$targets, 4),
      rolling6_targets = rolling_mean_vec(.data$targets, 6),
      rolling4_routes = rolling_mean_vec(.data$routes, 4),
      rolling6_routes = rolling_mean_vec(.data$routes, 6),
      rolling4_receiving_yards = rolling_mean_vec(.data$receiving_yards, 4),
      rolling6_receiving_yards = rolling_mean_vec(.data$receiving_yards, 6),
      rolling4_air_yards = rolling_mean_vec(.data$air_yards, 4),
      rolling6_air_yards = rolling_mean_vec(.data$air_yards, 6),
      rolling4_first_reads = rolling_mean_vec(.data$first_read_targets, 4),
      rolling6_first_reads = rolling_mean_vec(.data$first_read_targets, 6),
      rolling4_first_downs = rolling_mean_vec(.data$receiving_first_downs, 4),
      rolling6_first_downs = rolling_mean_vec(.data$receiving_first_downs, 6),
      rolling4_end_zone_targets = rolling_mean_vec(.data$end_zone_targets, 4),
      rolling6_end_zone_targets = rolling_mean_vec(.data$end_zone_targets, 6),
      rolling4_total_td = rolling_mean_vec(.data$total_td, 4),
      rolling6_total_td = rolling_mean_vec(.data$total_td, 6),
      rolling4_target_share = rolling_mean_vec(.data$team_target_share, 4),
      rolling6_target_share = rolling_mean_vec(.data$team_target_share, 6),
      rolling4_route_share = rolling_mean_vec(.data$team_route_share, 4),
      rolling6_route_share = rolling_mean_vec(.data$team_route_share, 6),
      rolling4_air_share = rolling_mean_vec(.data$team_air_share, 4),
      rolling6_air_share = rolling_mean_vec(.data$team_air_share, 6),
      rolling4_first_read_share = rolling_mean_vec(.data$team_first_read_share, 4),
      rolling6_first_read_share = rolling_mean_vec(.data$team_first_read_share, 6),
      rolling4_first_down_share = rolling_mean_vec(.data$team_first_down_share, 4),
      rolling6_first_down_share = rolling_mean_vec(.data$team_first_down_share, 6),
      rolling4_fantasy_share = rolling_mean_vec(.data$team_fantasy_share, 4),
      rolling6_fantasy_share = rolling_mean_vec(.data$team_fantasy_share, 6),
      rolling4_targets_per_route = rolling_mean_vec(.data$targets_per_route, 4),
      rolling6_targets_per_route = rolling_mean_vec(.data$targets_per_route, 6),
      rolling4_yards_per_route = rolling_mean_vec(.data$yards_per_route, 4),
      rolling6_yards_per_route = rolling_mean_vec(.data$yards_per_route, 6),
      rolling4_yards_per_target = rolling_mean_vec(.data$yards_per_target, 4),
      rolling6_yards_per_target = rolling_mean_vec(.data$yards_per_target, 6),
      rolling4_first_downs_per_target = rolling_mean_vec(.data$first_downs_per_target, 4),
      rolling6_first_downs_per_target = rolling_mean_vec(.data$first_downs_per_target, 6),
      rolling4_air_yards_per_target = rolling_mean_vec(.data$air_yards_per_target, 4),
      rolling6_air_yards_per_target = rolling_mean_vec(.data$air_yards_per_target, 6),
      rolling4_catch_rate = rolling_mean_vec(.data$catch_rate, 4),
      rolling6_catch_rate = rolling_mean_vec(.data$catch_rate, 6),
      rolling4_target_rate = rolling_mean_vec(.data$target_rate, 4),
      rolling6_target_rate = rolling_mean_vec(.data$target_rate, 6),
      rolling6_fantasy_points_sd = rolling_sd_vec(.data$half_ppr_points, 6),
      rolling6_targets_sd = rolling_sd_vec(.data$targets, 6),
      rolling6_routes_sd = rolling_sd_vec(.data$routes, 6),
      recent_5plus_target_flag = as.numeric(dplyr::coalesce(.data$targets, 0) >= 5),
      recent_8plus_target_flag = as.numeric(dplyr::coalesce(.data$targets, 0) >= 8),
      games_with_5plus_targets_recent_rate = rolling_mean_vec(.data$recent_5plus_target_flag, 6),
      games_with_8plus_targets_recent_rate = rolling_mean_vec(.data$recent_8plus_target_flag, 6),
      trend_fantasy_points_4v6 = rolling4_fantasy_points - rolling6_fantasy_points,
      trend_targets_4v6 = rolling4_targets - rolling6_targets,
      trend_routes_4v6 = rolling4_routes - rolling6_routes,
      trend_air_yards_4v6 = rolling4_air_yards - rolling6_air_yards,
      trend_first_reads_4v6 = rolling4_first_reads - rolling6_first_reads,
      trend_first_downs_4v6 = rolling4_first_downs - rolling6_first_downs,
      trend_target_share_4v6 = rolling4_target_share - rolling6_target_share,
      trend_route_share_4v6 = rolling4_route_share - rolling6_route_share,
      trend_air_share_4v6 = rolling4_air_share - rolling6_air_share,
      depth_order_current = .data$depth_team,
      target_week_fp = .data$next_week_fantasy_points
    ) |>
    dplyr::ungroup()
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "te_weekly_feature_base_2021_2025_regular.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_te_wow_inputs <- function(write_output = FALSE) {
  load_model_core_packages()
  
  te_weekly_feature_base <- build_te_weekly_feature_base(write_output = write_output)
  
  out <- list(
    position = "TE",
    mode = "week_over_week",
    handoff = te_wow_handoff,
    handoff_text = read_text_from_handoff(te_wow_handoff),
    weekly_base = build_wow_weekly_base("TE"),
    te_weekly_feature_base = te_weekly_feature_base,
    next_steps = c(
      "Use the TE weekly feature base as the no-leakage input table for week-ahead training and ranking.",
      "Keep QB context and defense matchup as weekly pool and range modifiers, not core OMFG inputs.",
      "Build calibrated TE weekly ranges and finish probabilities from the projected weekly board."
    )
  )
  
  if (write_output) {
    out$output_paths <- c(
      te_weekly_base = write_wow_weekly_base("TE"),
      te_weekly_feature_base = file.path(model_paths$wow_output_dir, "te_weekly_feature_base_2021_2025_regular.csv"),
      te_team_context_base = file.path(model_paths$wow_output_dir, "te_team_context_base_2021_2025.csv")
    )
  }
  
  out
}

make_te_wow_output_manifest <- function(te_wow_result) {
  output_paths <- unname(te_wow_result$output_paths %||% character())
  output_labels <- names(te_wow_result$output_paths %||% character())
  
  data.frame(
    output_name = output_labels,
    output_path = output_paths,
    exists = file.exists(output_paths),
    stringsAsFactors = FALSE
  )
}

run_te_wow_pipeline <- function(write_output = TRUE) {
  load_model_core_packages()
  
  dir.create(model_paths$wow_output_dir, recursive = TRUE, showWarnings = FALSE)
  
  te_wow_result <- build_te_wow_inputs(write_output = write_output)
  te_wow_board_rebuild <- run_te_wow_board_rebuild(write_output = write_output)
  
  output_paths <- c(
    te_wow_result$output_paths %||% character(),
    te_wow_feature_overlay = file.path(model_paths$wow_output_dir, "te_wow_feature_overlay_2021_2025.csv"),
    te_wow_board_metrics = file.path(model_paths$wow_output_dir, "te_wow_board_metrics_2021_2025.csv"),
    te_wow_board_summary = file.path(model_paths$wow_output_dir, "te_wow_board_summary_2021_2025.csv"),
    te_wow_final_export = file.path(model_paths$wow_output_dir, "te_wow_final_export_2021_2025.csv")
  )
  
  te_wow_result$output_paths <- output_paths
  output_manifest <- make_te_wow_output_manifest(te_wow_result)
  
  list(
    result = te_wow_result,
    board = te_wow_board_rebuild$board,
    board_summary = te_wow_board_rebuild$board_summary,
    final_export = te_wow_board_rebuild$final_export,
    output_manifest = output_manifest
  )
}

build_te_prior_season_week1_summary <- function(te_wow_feature_base) {
  load_model_core_packages()
  
  season_summary <- te_wow_feature_base |>
    dplyr::mutate(
      player_key = as.character(.data$player_key),
      season = suppressWarnings(as.integer(.data$season)),
      half_ppr_points = suppressWarnings(as.numeric(.data$half_ppr_points)),
      targets = suppressWarnings(as.numeric(.data$targets)),
      routes = suppressWarnings(as.numeric(.data$routes)),
      receiving_yards = suppressWarnings(as.numeric(.data$receiving_yards)),
      air_yards = suppressWarnings(as.numeric(.data$air_yards)),
      first_read_targets = suppressWarnings(as.numeric(.data$first_read_targets)),
      receiving_first_downs = suppressWarnings(as.numeric(.data$receiving_first_downs)),
      total_td = suppressWarnings(as.numeric(.data$total_td))
    ) |>
    dplyr::group_by(.data$player_key, .data$season) |>
    dplyr::summarise(
      season_games = sum(is.finite(.data$half_ppr_points)),
      season_ppg = ifelse(season_games > 0, mean(.data$half_ppr_points, na.rm = TRUE), NA_real_),
      season_total_fp = sum(.data$half_ppr_points, na.rm = TRUE),
      season_targets_pg = ifelse(season_games > 0, mean(.data$targets, na.rm = TRUE), NA_real_),
      season_routes_pg = ifelse(season_games > 0, mean(.data$routes, na.rm = TRUE), NA_real_),
      season_receiving_yards_pg = ifelse(season_games > 0, mean(.data$receiving_yards, na.rm = TRUE), NA_real_),
      season_air_yards_pg = ifelse(season_games > 0, mean(.data$air_yards, na.rm = TRUE), NA_real_),
      season_first_reads_pg = ifelse(season_games > 0, mean(.data$first_read_targets, na.rm = TRUE), NA_real_),
      season_first_downs_pg = ifelse(season_games > 0, mean(.data$receiving_first_downs, na.rm = TRUE), NA_real_),
      season_total_td_pg = ifelse(season_games > 0, mean(.data$total_td, na.rm = TRUE), NA_real_),
      .groups = "drop"
    )
  
  prior_summary <- season_summary |>
    dplyr::transmute(
      player_key = .data$player_key,
      season = .data$season + 1L,
      prior_season_games = .data$season_games,
      prior_season_ppg = .data$season_ppg,
      prior_season_total_fp = .data$season_total_fp,
      prior_season_targets_pg = .data$season_targets_pg,
      prior_season_routes_pg = .data$season_routes_pg,
      prior_season_receiving_yards_pg = .data$season_receiving_yards_pg,
      prior_season_air_yards_pg = .data$season_air_yards_pg,
      prior_season_first_reads_pg = .data$season_first_reads_pg,
      prior_season_first_downs_pg = .data$season_first_downs_pg,
      prior_season_total_td_pg = .data$season_total_td_pg
    )
  
  target_rows <- season_summary |>
    dplyr::distinct(.data$player_key, .data$season)
  
  career_summary <- lapply(seq_len(nrow(target_rows)), function(i) {
    player_key_i <- target_rows$player_key[[i]]
    season_i <- target_rows$season[[i]]
    
    hist <- season_summary |>
      dplyr::filter(.data$player_key == player_key_i, .data$season < season_i, .data$season_games > 0)
    
    if (nrow(hist) == 0) {
      return(data.frame(
        player_key = player_key_i,
        season = season_i,
        career_games = NA_real_,
        career_seasons = NA_real_,
        career_ppg = NA_real_,
        career_total_fp = NA_real_,
        career_targets_pg = NA_real_,
        career_routes_pg = NA_real_,
        career_receiving_yards_pg = NA_real_,
        career_air_yards_pg = NA_real_,
        career_first_reads_pg = NA_real_,
        career_first_downs_pg = NA_real_,
        career_total_td_pg = NA_real_,
        last_active_season = NA_real_,
        years_since_last_active = NA_real_,
        stringsAsFactors = FALSE
      ))
    }
    
    total_games <- sum(hist$season_games, na.rm = TRUE)
    total_fp <- sum(hist$season_total_fp, na.rm = TRUE)
    last_active <- max(hist$season, na.rm = TRUE)
    
    data.frame(
      player_key = player_key_i,
      season = season_i,
      career_games = total_games,
      career_seasons = nrow(hist),
      career_ppg = ifelse(total_games > 0, total_fp / total_games, NA_real_),
      career_total_fp = total_fp,
      career_targets_pg = stats::weighted.mean(hist$season_targets_pg, w = pmax(hist$season_games, 1), na.rm = TRUE),
      career_routes_pg = stats::weighted.mean(hist$season_routes_pg, w = pmax(hist$season_games, 1), na.rm = TRUE),
      career_receiving_yards_pg = stats::weighted.mean(hist$season_receiving_yards_pg, w = pmax(hist$season_games, 1), na.rm = TRUE),
      career_air_yards_pg = stats::weighted.mean(hist$season_air_yards_pg, w = pmax(hist$season_games, 1), na.rm = TRUE),
      career_first_reads_pg = stats::weighted.mean(hist$season_first_reads_pg, w = pmax(hist$season_games, 1), na.rm = TRUE),
      career_first_downs_pg = stats::weighted.mean(hist$season_first_downs_pg, w = pmax(hist$season_games, 1), na.rm = TRUE),
      career_total_td_pg = stats::weighted.mean(hist$season_total_td_pg, w = pmax(hist$season_games, 1), na.rm = TRUE),
      last_active_season = last_active,
      years_since_last_active = season_i - last_active,
      stringsAsFactors = FALSE
    )
  }) |>
    dplyr::bind_rows()
  
  target_rows |>
    dplyr::left_join(prior_summary, by = c("player_key", "season")) |>
    dplyr::left_join(career_summary, by = c("player_key", "season"))
}

build_te_wow_qb_context <- function() {
  load_model_core_packages()
  
  qb_clean <- build_qb_clean_weekly_master(write_output = FALSE)
  
  qb_clean |>
    dplyr::group_by(.data$season, .data$week, .data$team) |>
    dplyr::arrange(
      dplyr::desc(dplyr::coalesce(.data$pass_attempts, 0)),
      dplyr::desc(dplyr::coalesce(.data$fantasy_points_calc, 0)),
      .data$player,
      .by_group = TRUE
    ) |>
    dplyr::slice(1) |>
    dplyr::ungroup() |>
    dplyr::arrange(.data$team, .data$season, .data$week) |>
    dplyr::group_by(.data$team, .data$season) |>
    dplyr::mutate(
      lead_qb_changed_flag = as.integer(.data$player_key != dplyr::lag(.data$player_key) & !is.na(dplyr::lag(.data$player_key))),
      rolling3_lead_qb_pass_attempts = rolling_mean_vec(.data$pass_attempts, 3),
      rolling3_lead_qb_pass_yards = rolling_mean_vec(.data$pass_yards, 3),
      rolling3_lead_qb_pass_td = rolling_mean_vec(.data$pass_td, 3),
      rolling3_lead_qb_any_a = rolling_mean_vec(.data$any_a, 3),
      rolling3_lead_qb_fp = rolling_mean_vec(.data$fantasy_points_calc, 3)
    ) |>
    dplyr::ungroup() |>
    dplyr::transmute(
      season = .data$season,
      feature_week = .data$week,
      team = .data$team,
      lead_qb_player = .data$player,
      lead_qb_player_key = .data$player_key,
      lead_qb_depth_team = .data$depth_team,
      lead_qb_report_status = .data$report_status,
      lead_qb_pass_attempts = .data$pass_attempts,
      lead_qb_pass_yards = .data$pass_yards,
      lead_qb_pass_td = .data$pass_td,
      lead_qb_any_a = .data$any_a,
      lead_qb_fp = .data$fantasy_points_calc,
      lead_qb_changed_flag = .data$lead_qb_changed_flag,
      rolling3_lead_qb_pass_attempts = .data$rolling3_lead_qb_pass_attempts,
      rolling3_lead_qb_pass_yards = .data$rolling3_lead_qb_pass_yards,
      rolling3_lead_qb_pass_td = .data$rolling3_lead_qb_pass_td,
      rolling3_lead_qb_any_a = .data$rolling3_lead_qb_any_a,
      rolling3_lead_qb_fp = .data$rolling3_lead_qb_fp
    )
}

build_te_wow_defense_context <- function(te_wow_feature_base) {
  load_model_core_packages()
  
  te_wow_feature_base |>
    dplyr::group_by(feature_week = .data$week, season = .data$season, defense_team = .data$opponent) |>
    dplyr::summarise(
      te_fp_allowed = sum(.data$half_ppr_points, na.rm = TRUE),
      te_targets_allowed = sum(.data$targets, na.rm = TRUE),
      te_routes_allowed = sum(.data$routes, na.rm = TRUE),
      te_receiving_yards_allowed = sum(.data$receiving_yards, na.rm = TRUE),
      te_air_yards_allowed = sum(.data$air_yards, na.rm = TRUE),
      te_first_reads_allowed = sum(.data$first_read_targets, na.rm = TRUE),
      te_first_downs_allowed = sum(.data$receiving_first_downs, na.rm = TRUE),
      te_end_zone_targets_allowed = sum(.data$end_zone_targets, na.rm = TRUE),
      te_td_allowed = sum(.data$total_td, na.rm = TRUE),
      .groups = "drop"
    ) |>
    dplyr::arrange(.data$defense_team, .data$season, .data$feature_week) |>
    dplyr::group_by(.data$defense_team, .data$season) |>
    dplyr::mutate(
      trailing3_te_fp_allowed = rolling_mean_vec(.data$te_fp_allowed, 3),
      trailing5_te_fp_allowed = rolling_mean_vec(.data$te_fp_allowed, 5),
      trailing5_te_targets_allowed = rolling_mean_vec(.data$te_targets_allowed, 5),
      trailing5_te_routes_allowed = rolling_mean_vec(.data$te_routes_allowed, 5),
      trailing5_te_receiving_yards_allowed = rolling_mean_vec(.data$te_receiving_yards_allowed, 5),
      trailing5_te_air_yards_allowed = rolling_mean_vec(.data$te_air_yards_allowed, 5),
      trailing5_te_first_reads_allowed = rolling_mean_vec(.data$te_first_reads_allowed, 5),
      trailing5_te_first_downs_allowed = rolling_mean_vec(.data$te_first_downs_allowed, 5),
      trailing5_te_end_zone_targets_allowed = rolling_mean_vec(.data$te_end_zone_targets_allowed, 5),
      trailing5_te_td_allowed = rolling_mean_vec(.data$te_td_allowed, 5)
    ) |>
    dplyr::ungroup()
}

build_te_wow_feature_overlay_table <- function(te_wow_feature_base = NULL, write_output = TRUE, output_dir = model_paths$wow_output_dir) {
  load_model_core_packages()
  
  if (is.null(te_wow_feature_base)) {
    te_wow_feature_base <- build_te_weekly_feature_base(write_output = FALSE)
  }
  
  te_prior_season_summary <- build_te_prior_season_week1_summary(te_wow_feature_base)
  te_qb_context <- build_te_wow_qb_context()
  te_defense_context <- build_te_wow_defense_context(te_wow_feature_base)
  
  out <- te_wow_feature_base |>
    dplyr::left_join(te_prior_season_summary, by = c("player_key", "season")) |>
    dplyr::left_join(te_qb_context, by = c("season", "feature_week", "team")) |>
    dplyr::left_join(te_defense_context, by = c("season", "feature_week", "next_week_opponent" = "defense_team")) |>
    dplyr::mutate(
      draft_day_score_0to100 = qb_draft_day_score_0to100(.data$draft_day),
      is_true_rookie = !is.na(.data$rookie_year) & (.data$season == .data$rookie_year),
      has_prior_season_stats = is.finite(.data$prior_season_games) & .data$prior_season_games > 0,
      has_career_stats = is.finite(.data$career_games) & .data$career_games > 0,
      te_wow_anchor_fp = dplyr::coalesce(
        .data$rolling4_fantasy_points,
        .data$rolling6_fantasy_points,
        .data$season_to_date_fantasy_points_per_game,
        .data$prior_season_ppg,
        .data$career_ppg
      ),
      efficiency_reliability_raw = qb_wow_row_mean(.data$rolling6_targets, .data$rolling6_routes),
      air_priority_raw = dplyr::coalesce(
        0.55 * .data$rolling4_air_share + 0.45 * .data$rolling6_air_share,
        .data$rolling4_air_share,
        .data$rolling6_air_share
      ),
      td_context_raw = dplyr::coalesce(
        0.60 * .data$rolling6_end_zone_targets + 0.40 * .data$rolling6_total_td,
        .data$rolling6_end_zone_targets,
        .data$rolling6_total_td
      ),
      wow_anchor_rank_component = qb_wow_percent_rank_0to100(.data$te_wow_anchor_fp),
      prior_season_production_score = qb_wow_row_mean(
        qb_wow_percent_rank_0to100(.data$prior_season_ppg),
        qb_wow_percent_rank_0to100(.data$prior_season_total_fp),
        qb_wow_percent_rank_0to100(.data$prior_season_targets_pg),
        qb_wow_percent_rank_0to100(.data$prior_season_routes_pg),
        qb_wow_percent_rank_0to100(.data$prior_season_receiving_yards_pg),
        qb_wow_percent_rank_0to100(.data$prior_season_air_yards_pg),
        qb_wow_percent_rank_0to100(.data$prior_season_first_reads_pg),
        qb_wow_percent_rank_0to100(.data$prior_season_first_downs_pg),
        qb_wow_percent_rank_0to100(.data$prior_season_total_td_pg)
      ),
      career_production_score = qb_wow_row_mean(
        qb_wow_percent_rank_0to100(.data$career_ppg),
        qb_wow_percent_rank_0to100(.data$career_total_fp),
        qb_wow_percent_rank_0to100(.data$career_targets_pg),
        qb_wow_percent_rank_0to100(.data$career_routes_pg),
        qb_wow_percent_rank_0to100(.data$career_receiving_yards_pg),
        qb_wow_percent_rank_0to100(.data$career_air_yards_pg),
        qb_wow_percent_rank_0to100(.data$career_first_reads_pg),
        qb_wow_percent_rank_0to100(.data$career_first_downs_pg),
        qb_wow_percent_rank_0to100(.data$career_total_td_pg)
      ),
      workload_opportunity_component_0to100 =
        0.22 * qb_wow_percent_rank_0to100(.data$rolling4_targets) +
        0.18 * qb_wow_percent_rank_0to100(.data$rolling6_targets) +
        0.16 * qb_wow_percent_rank_0to100(.data$rolling4_routes) +
        0.14 * qb_wow_percent_rank_0to100(.data$rolling6_routes) +
        0.15 * qb_wow_percent_rank_0to100(.data$rolling4_target_share) +
        0.15 * qb_wow_percent_rank_0to100(.data$rolling4_route_share),
      receiving_role_component_0to100 =
        0.20 * qb_wow_percent_rank_0to100(.data$rolling4_first_downs) +
        0.15 * qb_wow_percent_rank_0to100(.data$rolling6_first_downs) +
        0.20 * qb_wow_percent_rank_0to100(.data$rolling4_first_reads) +
        0.15 * qb_wow_percent_rank_0to100(.data$rolling6_first_reads) +
        0.15 * qb_wow_percent_rank_0to100(.data$rolling4_first_read_share) +
        0.15 * qb_wow_percent_rank_0to100(.data$rolling4_first_down_share),
      weekly_stability_component_0to100 =
        0.25 * qb_wow_percent_rank_0to100(.data$rolling6_fantasy_points_sd, higher_is_better = FALSE) +
        0.20 * qb_wow_percent_rank_0to100(.data$rolling6_targets_sd, higher_is_better = FALSE) +
        0.15 * qb_wow_percent_rank_0to100(.data$rolling6_routes_sd, higher_is_better = FALSE) +
        0.20 * qb_wow_percent_rank_0to100(.data$games_with_5plus_targets_recent_rate) +
        0.20 * qb_wow_percent_rank_0to100(.data$games_with_8plus_targets_recent_rate),
      priority_air_component_0to100 =
        0.22 * qb_wow_percent_rank_0to100(.data$rolling4_air_yards) +
        0.18 * qb_wow_percent_rank_0to100(.data$rolling6_air_yards) +
        0.18 * qb_wow_percent_rank_0to100(.data$rolling4_air_share) +
        0.12 * qb_wow_percent_rank_0to100(.data$rolling6_air_share) +
        0.15 * qb_wow_percent_rank_0to100(.data$rolling4_end_zone_targets) +
        0.15 * qb_wow_percent_rank_0to100(.data$air_priority_raw),
      role_momentum_component_0to100 =
        0.22 * qb_wow_percent_rank_0to100(.data$trend_targets_4v6) +
        0.18 * qb_wow_percent_rank_0to100(.data$trend_routes_4v6) +
        0.16 * qb_wow_percent_rank_0to100(.data$trend_first_reads_4v6) +
        0.16 * qb_wow_percent_rank_0to100(.data$trend_first_downs_4v6) +
        0.14 * qb_wow_percent_rank_0to100(.data$trend_air_share_4v6) +
        0.14 * qb_wow_percent_rank_0to100(.data$trend_fantasy_points_4v6),
      efficiency_sustainability_component_0to100 =
        0.20 * qb_wow_percent_rank_0to100(.data$rolling6_yards_per_route) +
        0.20 * qb_wow_percent_rank_0to100(.data$rolling6_yards_per_target) +
        0.20 * qb_wow_percent_rank_0to100(.data$rolling6_catch_rate) +
        0.20 * qb_wow_percent_rank_0to100(.data$rolling6_first_downs_per_target) +
        0.20 * qb_wow_percent_rank_0to100(.data$efficiency_reliability_raw),
      td_context_component_0to100 =
        0.35 * qb_wow_percent_rank_0to100(.data$rolling6_total_td) +
        0.25 * qb_wow_percent_rank_0to100(.data$rolling6_end_zone_targets) +
        0.20 * qb_wow_percent_rank_0to100(.data$td_context_raw) +
        0.20 * qb_wow_percent_rank_0to100(.data$team_rec_td_share),
      age_development_component_0to100 = qb_wow_row_mean(
        te_wow_age_window_score(.data$age),
        qb_wow_percent_rank_0to100(.data$games_played_to_date),
        qb_wow_percent_rank_0to100(.data$depth_order_current, higher_is_better = FALSE)
      ),
      production_component_0to100 = qb_wow_row_mean(
        qb_wow_percent_rank_0to100(.data$rolling4_fantasy_points),
        qb_wow_percent_rank_0to100(.data$rolling6_fantasy_points),
        qb_wow_percent_rank_0to100(.data$season_to_date_fantasy_points_per_game),
        qb_wow_percent_rank_0to100(.data$rolling4_receiving_yards),
        qb_wow_percent_rank_0to100(.data$rolling4_total_td)
      ),
      qb_context_quality_score = qb_wow_row_mean(
        qb_wow_percent_rank_0to100(.data$rolling3_lead_qb_pass_attempts),
        qb_wow_percent_rank_0to100(.data$rolling3_lead_qb_pass_yards),
        qb_wow_percent_rank_0to100(.data$rolling3_lead_qb_pass_td),
        qb_wow_percent_rank_0to100(.data$rolling3_lead_qb_any_a),
        qb_wow_percent_rank_0to100(.data$rolling3_lead_qb_fp),
        qb_wow_percent_rank_0to100(.data$lead_qb_changed_flag, higher_is_better = FALSE)
      ),
      role_security_component_0to100 = qb_wow_row_mean(
        qb_wow_percent_rank_0to100(.data$rolling4_target_share),
        qb_wow_percent_rank_0to100(.data$rolling4_route_share),
        qb_wow_percent_rank_0to100(.data$rolling4_targets),
        qb_wow_percent_rank_0to100(.data$rolling4_routes),
        qb_wow_percent_rank_0to100(.data$depth_order_current, higher_is_better = FALSE)
      ),
      preseason_weight = dplyr::case_when(
        .data$week <= 1L ~ 1.00,
        .data$week == 2L ~ 0.72,
        .data$week == 3L ~ 0.52,
        .data$week == 4L ~ 0.36,
        .data$week == 5L ~ 0.24,
        TRUE ~ 0.12
      ),
      te_preseason_omfg_score = dplyr::case_when(
        .data$has_prior_season_stats ~
          0.32 * dplyr::coalesce(.data$prior_season_production_score, 0) +
          0.18 * dplyr::coalesce(.data$career_production_score, 0) +
          0.18 * dplyr::coalesce(.data$wow_anchor_rank_component, 0) +
          0.12 * dplyr::coalesce(.data$role_security_component_0to100, 0) +
          0.10 * dplyr::coalesce(.data$age_development_component_0to100, 0) +
          0.10 * dplyr::coalesce(.data$draft_day_score_0to100, 50),
        .data$has_career_stats ~
          0.48 * dplyr::coalesce(.data$career_production_score, 0) +
          0.20 * dplyr::coalesce(.data$wow_anchor_rank_component, 0) +
          0.17 * dplyr::coalesce(.data$role_security_component_0to100, 0) +
          0.15 * dplyr::coalesce(.data$draft_day_score_0to100, 50),
        TRUE ~
          0.35 * dplyr::coalesce(.data$wow_anchor_rank_component, 50) +
          0.25 * dplyr::coalesce(.data$role_security_component_0to100, 50) +
          0.20 * dplyr::coalesce(.data$age_development_component_0to100, 50) +
          0.20 * dplyr::coalesce(.data$draft_day_score_0to100, 50)
      ),
      te_production_anchor_historical_scaled = dplyr::case_when(
        .data$has_prior_season_stats ~
          0.55 * dplyr::coalesce(.data$prior_season_production_score, 0) +
          0.45 * dplyr::coalesce(.data$career_production_score, 0),
        .data$has_career_stats ~ dplyr::coalesce(.data$career_production_score, 0),
        TRUE ~ dplyr::coalesce(.data$wow_anchor_rank_component, 50)
      ),
      te_anchor_board_score = qb_wow_row_mean(
        .data$te_production_anchor_historical_scaled,
        .data$te_preseason_omfg_score,
        qb_wow_percent_rank_0to100(.data$te_wow_anchor_fp)
      ),
      te_weekly_omfg_historical_core = qb_wow_row_mean(
        .data$te_anchor_board_score,
        .data$production_component_0to100,
        .data$workload_opportunity_component_0to100,
        .data$receiving_role_component_0to100,
        .data$weekly_stability_component_0to100,
        .data$priority_air_component_0to100,
        .data$role_momentum_component_0to100,
        .data$efficiency_sustainability_component_0to100,
        .data$td_context_component_0to100
      ),
      preseason_anchor_score_raw = dplyr::case_when(
        .data$has_prior_season_stats ~
          0.42 * dplyr::coalesce(.data$prior_season_production_score, 0) +
          0.18 * dplyr::coalesce(.data$career_production_score, 0) +
          0.18 * dplyr::coalesce(.data$wow_anchor_rank_component, 0) +
          0.12 * dplyr::coalesce(.data$role_security_component_0to100, 0) +
          0.10 * dplyr::coalesce(.data$draft_day_score_0to100, 50),
        .data$has_career_stats ~
          0.48 * dplyr::coalesce(.data$career_production_score, 0) +
          0.20 * dplyr::coalesce(.data$wow_anchor_rank_component, 0) +
          0.17 * dplyr::coalesce(.data$role_security_component_0to100, 0) +
          0.15 * dplyr::coalesce(.data$draft_day_score_0to100, 50),
        TRUE ~
          0.35 * dplyr::coalesce(.data$wow_anchor_rank_component, 50) +
          0.25 * dplyr::coalesce(.data$role_security_component_0to100, 50) +
          0.20 * dplyr::coalesce(.data$age_development_component_0to100, 50) +
          0.20 * dplyr::coalesce(.data$draft_day_score_0to100, 50)
      ),
      preseason_anchor_score = dplyr::if_else(.data$is_true_rookie, pmin(.data$preseason_anchor_score_raw, 80), .data$preseason_anchor_score_raw),
      te_in_season_omfg_score = pmin(100, pmax(0,
                                               dplyr::if_else(
                                                 .data$week == 1L,
                                                 .data$preseason_anchor_score,
                                                 .data$preseason_weight * .data$preseason_anchor_score + (1 - .data$preseason_weight) * .data$te_weekly_omfg_historical_core
                                               )
      )),
      qb_context_modifier = pmin(1.08, pmax(0.90,
                                            1 +
                                              te_wow_centered_rank(.data$qb_context_quality_score) * 0.08 -
                                              dplyr::coalesce(.data$lead_qb_changed_flag, 0) * 0.04
      )),
      te_weekly_projection_context_score = pmin(100, pmax(0,
                                                          .data$te_in_season_omfg_score * .data$qb_context_modifier
      )),
      team_te_pool_seed = dplyr::coalesce(
        0.55 * .data$rolling4_team_te_half_ppr +
          0.30 * .data$rolling6_team_te_half_ppr +
          0.15 * .data$season_to_date_team_te_half_ppr_pg,
        .data$rolling4_team_te_half_ppr,
        .data$rolling6_team_te_half_ppr,
        .data$season_to_date_team_te_half_ppr_pg,
        .data$team_te_half_ppr
      ),
      te_matchup_ease_score = qb_wow_row_mean(
        qb_wow_percent_rank_0to100(.data$trailing5_te_fp_allowed),
        qb_wow_percent_rank_0to100(.data$trailing5_te_targets_allowed),
        qb_wow_percent_rank_0to100(.data$trailing5_te_routes_allowed),
        qb_wow_percent_rank_0to100(.data$trailing5_te_air_yards_allowed),
        qb_wow_percent_rank_0to100(.data$trailing5_te_first_reads_allowed),
        qb_wow_percent_rank_0to100(.data$trailing5_te_first_downs_allowed),
        qb_wow_percent_rank_0to100(.data$trailing5_te_td_allowed)
      ),
      matchup_modifier = pmin(1.05, pmax(0.95, 1 + te_wow_centered_rank(.data$te_matchup_ease_score) * 0.05)),
      role_state_uncertainty_flag = as.integer(
        (!is.na(.data$report_status) & !(.data$report_status %in% c("Active", "Healthy"))) |
          (!is.na(.data$practice_status) & !(.data$practice_status %in% c("Full", "Healthy")))
      ),
      allocation_weight_raw = pmax(0.01,
                                   (
                                     0.28 * dplyr::coalesce(.data$rolling4_target_share, .data$rolling6_target_share, 0) +
                                       0.20 * dplyr::coalesce(.data$rolling4_route_share, .data$rolling6_route_share, 0) +
                                       0.16 * dplyr::coalesce(.data$rolling4_air_share, .data$rolling6_air_share, 0) +
                                       0.14 * dplyr::coalesce(.data$rolling4_first_read_share, .data$rolling6_first_read_share, 0) +
                                       0.12 * dplyr::coalesce(.data$rolling4_first_down_share, .data$rolling6_first_down_share, 0) +
                                       0.10 * dplyr::coalesce(.data$rolling4_fantasy_share, .data$rolling6_fantasy_share, 0)
                                   ) *
                                     pmin(1.22, pmax(0.78,
                                                     1 +
                                                       te_wow_centered_rank(.data$te_in_season_omfg_score) * 0.12 +
                                                       te_wow_centered_rank(.data$role_momentum_component_0to100) * 0.05 +
                                                       te_wow_centered_rank(.data$role_security_component_0to100) * 0.05 -
                                                       dplyr::coalesce(.data$role_state_uncertainty_flag, 0) * 0.06
                                     ))
      ),
      team_te_pool_after_context = .data$team_te_pool_seed * .data$qb_context_modifier * .data$matchup_modifier
    ) |>
    dplyr::mutate(
      allocation_weight_sum = stats::ave(
        dplyr::coalesce(.data$allocation_weight_raw, 0),
        interaction(.data$season, .data$feature_week, .data$team, drop = TRUE),
        FUN = function(x) sum(x, na.rm = TRUE)
      ),
      player_allocation_share = ifelse(
        is.finite(.data$allocation_weight_sum) & .data$allocation_weight_sum > 0,
        .data$allocation_weight_raw / .data$allocation_weight_sum,
        NA_real_
      ),
      weekly_central_projection = dplyr::coalesce(.data$team_te_pool_after_context, .data$team_te_pool_seed) * .data$player_allocation_share,
      uncertainty_component_0to100 = qb_wow_row_mean(
        qb_wow_percent_rank_0to100(.data$rolling6_fantasy_points_sd),
        qb_wow_percent_rank_0to100(.data$rolling6_targets_sd),
        qb_wow_percent_rank_0to100(.data$rolling6_routes_sd),
        qb_wow_percent_rank_0to100(.data$role_state_uncertainty_flag),
        qb_wow_percent_rank_0to100(.data$lead_qb_changed_flag),
        qb_wow_percent_rank_0to100(.data$depth_order_current)
      ),
      weekly_role_class = dplyr::case_when(
        dplyr::coalesce(.data$player_allocation_share, 0) >= 0.24 | dplyr::coalesce(.data$rolling4_target_share, 0) >= 0.24 ~ "Alpha",
        dplyr::coalesce(.data$player_allocation_share, 0) >= 0.17 | dplyr::coalesce(.data$rolling4_target_share, 0) >= 0.17 ~ "Core",
        dplyr::coalesce(.data$player_allocation_share, 0) >= 0.10 | dplyr::coalesce(.data$rolling4_target_share, 0) >= 0.10 ~ "Flex",
        dplyr::coalesce(.data$player_allocation_share, 0) >= 0.05 ~ "Fragile",
        TRUE ~ "Contingent"
      ),
      lower_tail_base = dplyr::case_when(
        .data$weekly_role_class == "Alpha" ~ 0.38,
        .data$weekly_role_class == "Core" ~ 0.48,
        .data$weekly_role_class == "Flex" ~ 0.62,
        .data$weekly_role_class == "Fragile" ~ 0.80,
        TRUE ~ 0.92
      ),
      upper_tail_base = dplyr::case_when(
        .data$weekly_role_class == "Alpha" ~ 0.62,
        .data$weekly_role_class == "Core" ~ 0.70,
        .data$weekly_role_class == "Flex" ~ 0.86,
        .data$weekly_role_class == "Fragile" ~ 1.02,
        TRUE ~ 1.18
      ),
      uncertainty_multiplier = 0.85 + dplyr::coalesce(.data$uncertainty_component_0to100, 50) / 100 * 0.50,
      weekly_p50_projection = .data$weekly_central_projection,
      weekly_p25_projection = pmax(0, .data$weekly_central_projection * (1 - .data$lower_tail_base * 0.55 * .data$uncertainty_multiplier)),
      weekly_p10_projection = pmax(0, .data$weekly_central_projection * (1 - .data$lower_tail_base * .data$uncertainty_multiplier)),
      weekly_p75_projection = .data$weekly_central_projection * (1 + .data$upper_tail_base * 0.50 * .data$uncertainty_multiplier),
      weekly_p90_projection = .data$weekly_central_projection * (1 + .data$upper_tail_base * .data$uncertainty_multiplier),
      weekly_average_range_score = (0.15 * .data$weekly_p25_projection) + (0.55 * .data$weekly_p50_projection) + (0.30 * .data$weekly_p75_projection)
    ) |>
    dplyr::mutate(
      week_projection_sd = stats::sd(.data$weekly_central_projection, na.rm = TRUE),
      week_scale = pmax(1.25, dplyr::coalesce(.data$week_projection_sd, 1.25) * 0.30),
      cutoff_top5 = dplyr::nth(sort(.data$weekly_central_projection, decreasing = TRUE), pmin(5L, dplyr::n())),
      cutoff_top12 = dplyr::nth(sort(.data$weekly_central_projection, decreasing = TRUE), pmin(12L, dplyr::n())),
      cutoff_top24 = dplyr::nth(sort(.data$weekly_central_projection, decreasing = TRUE), pmin(24L, dplyr::n())),
      cutoff_top36 = dplyr::nth(sort(.data$weekly_central_projection, decreasing = TRUE), pmin(36L, dplyr::n())),
      cutoff_top48 = dplyr::nth(sort(.data$weekly_central_projection, decreasing = TRUE), pmin(48L, dplyr::n())),
      probability_top5 = stats::plogis((.data$weekly_central_projection - .data$cutoff_top5) / .data$week_scale),
      probability_top12 = stats::plogis((.data$weekly_central_projection - .data$cutoff_top12) / .data$week_scale),
      probability_top24 = stats::plogis((.data$weekly_central_projection - .data$cutoff_top24) / .data$week_scale),
      probability_top36 = stats::plogis((.data$weekly_central_projection - .data$cutoff_top36) / .data$week_scale),
      probability_top48 = stats::plogis((.data$weekly_central_projection - .data$cutoff_top48) / .data$week_scale),
      weekly_central_projection_rank = qb_wow_percent_rank_0to100(.data$weekly_central_projection),
      weekly_average_range_rank = qb_wow_percent_rank_0to100(.data$weekly_average_range_score),
      te_anchor_rank_component = qb_wow_percent_rank_0to100(.data$te_wow_anchor_fp),
      te_weekly_board_score = qb_wow_row_mean(
        .data$weekly_central_projection_rank,
        .data$weekly_average_range_rank,
        .data$te_anchor_rank_component,
        .data$te_weekly_projection_context_score,
        .data$workload_opportunity_component_0to100,
        .data$receiving_role_component_0to100,
        .data$priority_air_component_0to100
      ),
      week1_score_num =
        0.25 * dplyr::coalesce(.data$preseason_anchor_score, 0) +
        0.20 * dplyr::coalesce(.data$te_weekly_projection_context_score, 0) +
        0.15 * dplyr::coalesce(.data$weekly_central_projection_rank, 0) +
        0.15 * dplyr::coalesce(.data$weekly_average_range_rank, 0) +
        0.15 * dplyr::coalesce(.data$role_security_component_0to100, 0) +
        0.10 * dplyr::coalesce(.data$age_development_component_0to100, 0),
      week1_score_den =
        0.25 * as.numeric(is.finite(.data$preseason_anchor_score)) +
        0.20 * as.numeric(is.finite(.data$te_weekly_projection_context_score)) +
        0.15 * as.numeric(is.finite(.data$weekly_central_projection_rank)) +
        0.15 * as.numeric(is.finite(.data$weekly_average_range_rank)) +
        0.15 * as.numeric(is.finite(.data$role_security_component_0to100)) +
        0.10 * as.numeric(is.finite(.data$age_development_component_0to100)),
      later_score_num =
        0.30 * dplyr::coalesce(.data$te_weekly_board_score, 0) +
        0.22 * dplyr::coalesce(.data$te_weekly_projection_context_score, 0) +
        0.18 * dplyr::coalesce(.data$weekly_central_projection_rank, 0) +
        0.10 * dplyr::coalesce(.data$weekly_average_range_rank, 0) +
        0.10 * (dplyr::coalesce(.data$probability_top24, 0) * 100) +
        0.10 * dplyr::coalesce(.data$role_momentum_component_0to100, 0),
      later_score_den =
        0.30 * as.numeric(is.finite(.data$te_weekly_board_score)) +
        0.22 * as.numeric(is.finite(.data$te_weekly_projection_context_score)) +
        0.18 * as.numeric(is.finite(.data$weekly_central_projection_rank)) +
        0.10 * as.numeric(is.finite(.data$weekly_average_range_rank)) +
        0.10 * as.numeric(is.finite(.data$probability_top24)) +
        0.10 * as.numeric(is.finite(.data$role_momentum_component_0to100)),
      te_wow_final_score = dplyr::if_else(
        .data$week <= 1L,
        dplyr::if_else(.data$week1_score_den > 0, .data$week1_score_num / .data$week1_score_den, NA_real_),
        dplyr::if_else(.data$later_score_den > 0, .data$later_score_num / .data$later_score_den, NA_real_)
      )
    ) |>
    dplyr::group_by(.data$season, .data$feature_week) |>
    dplyr::arrange(dplyr::desc(.data$te_wow_final_score), .data$player, .by_group = TRUE) |>
    dplyr::mutate(
      weekly_role_rank = dplyr::min_rank(dplyr::desc(.data$player_allocation_share)),
      te_wow_rank = dplyr::row_number(),
      te_wow_tier = dplyr::case_when(
        .data$te_wow_rank <= 6 ~ "Tier 1",
        .data$te_wow_rank <= 12 ~ "Tier 2",
        .data$te_wow_rank <= 24 ~ "Tier 3",
        .data$te_wow_rank <= 36 ~ "Tier 4",
        .data$te_wow_rank <= 48 ~ "Tier 5",
        TRUE ~ "Tier 6"
      ),
      replacement_starter_flag = as.integer(!is.na(.data$depth_order_current) & .data$depth_order_current <= 2 & dplyr::coalesce(.data$trend_route_share_4v6, 0) > 0.02),
      starter_return_flag = as.integer(!is.na(.data$report_status) & .data$report_status %in% c("Questionable", "Doubtful") & dplyr::coalesce(.data$weekly_role_class, "") %in% c("Alpha", "Core")),
      high_variance_rotation_flag = as.integer(.data$weekly_role_class %in% c("Fragile", "Contingent") | dplyr::coalesce(.data$uncertainty_component_0to100, 0) >= 70),
      review_flags = trimws(paste(
        ifelse(.data$lead_qb_changed_flag == 1, "QB change", ""),
        ifelse(.data$role_state_uncertainty_flag == 1, "Injury/ramp", ""),
        ifelse(.data$replacement_starter_flag == 1, "Replacement starter", ""),
        ifelse(.data$starter_return_flag == 1, "Starter return", ""),
        ifelse(.data$high_variance_rotation_flag == 1, "High variance", "")
      ))
    ) |>
    dplyr::ungroup() |>
    dplyr::arrange(.data$season, .data$feature_week, .data$te_wow_rank)
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "te_wow_feature_overlay_2021_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_te_wow_board_summary <- function(te_wow_board, write_output = TRUE) {
  load_model_core_packages()
  
  week_metrics <- te_wow_board |>
    dplyr::group_by(.data$season, .data$feature_week) |>
    dplyr::summarise(
      n = sum(is.finite(.data$te_wow_rank) & is.finite(.data$target_week_fp)),
      spearman = {
        keep <- is.finite(.data$te_wow_rank) & is.finite(.data$target_week_fp)
        if (sum(keep) > 1) {
          suppressWarnings(stats::cor(-.data$te_wow_rank[keep], .data$target_week_fp[keep], method = "spearman"))
        } else {
          NA_real_
        }
      },
      .groups = "drop"
    ) |>
    dplyr::mutate(
      predicts_week = .data$feature_week + 1L,
      is_scorable = as.integer(.data$n > 1 & is.finite(.data$spearman))
    )
  
  summary_out <- week_metrics |>
    dplyr::group_by(.data$season) |>
    dplyr::summarise(
      weeks_total = dplyr::n(),
      weeks = sum(.data$is_scorable, na.rm = TRUE),
      scorable_weeks = sum(.data$is_scorable, na.rm = TRUE),
      avg_spearman = if (sum(.data$is_scorable, na.rm = TRUE) > 0) {
        mean(.data$spearman[.data$is_scorable == 1L], na.rm = TRUE)
      } else {
        NA_real_
      },
      median_spearman = if (sum(.data$is_scorable, na.rm = TRUE) > 0) {
        stats::median(.data$spearman[.data$is_scorable == 1L], na.rm = TRUE)
      } else {
        NA_real_
      },
      min_spearman = if (sum(.data$is_scorable, na.rm = TRUE) > 0) {
        min(.data$spearman[.data$is_scorable == 1L], na.rm = TRUE)
      } else {
        NA_real_
      },
      max_spearman = if (sum(.data$is_scorable, na.rm = TRUE) > 0) {
        max(.data$spearman[.data$is_scorable == 1L], na.rm = TRUE)
      } else {
        NA_real_
      },
      weeks_over_0 = sum(.data$spearman[.data$is_scorable == 1L] > 0, na.rm = TRUE),
      weeks_over_030 = sum(.data$spearman[.data$is_scorable == 1L] >= 0.30, na.rm = TRUE),
      weeks_over_040 = sum(.data$spearman[.data$is_scorable == 1L] >= 0.40, na.rm = TRUE),
      .groups = "drop"
    ) |>
    dplyr::arrange(.data$season)
  
  if (write_output) {
    utils::write.csv(
      week_metrics,
      file.path(model_paths$wow_output_dir, "te_wow_board_metrics_2021_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    utils::write.csv(
      summary_out,
      file.path(model_paths$wow_output_dir, "te_wow_board_summary_2021_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    week_metrics = week_metrics,
    summary = summary_out
  )
}

build_te_wow_final_export <- function(te_wow_board, write_output = TRUE) {
  load_model_core_packages()
  
  out <- te_wow_board |>
    dplyr::transmute(
      season = .data$season,
      week = .data$feature_week,
      predicts_week = .data$next_week,
      rank = .data$te_wow_rank,
      tier = .data$te_wow_tier,
      player = .data$player,
      team = .data$team,
      opponent = .data$next_week_opponent,
      depth_team = .data$depth_team,
      report_status = .data$report_status,
      practice_status = .data$practice_status,
      weekly_role_class = .data$weekly_role_class,
      weekly_role_rank = .data$weekly_role_rank,
      final_score = .data$te_wow_final_score,
      weekly_board_score = .data$te_weekly_board_score,
      in_season_omfg = .data$te_in_season_omfg_score,
      weekly_omfg_core = .data$te_weekly_omfg_historical_core,
      weekly_omfg_projection_context = .data$te_weekly_projection_context_score,
      anchor_fp = .data$te_wow_anchor_fp,
      projected_fp = .data$weekly_central_projection,
      p10_injury_tail = .data$weekly_p10_projection,
      p25_probable_floor = .data$weekly_p25_projection,
      p50_median = .data$weekly_p50_projection,
      p75_probable_ceiling = .data$weekly_p75_projection,
      p90_spike_ceiling = .data$weekly_p90_projection,
      average_range_score = .data$weekly_average_range_score,
      probability_top5 = .data$probability_top5,
      probability_top12 = .data$probability_top12,
      probability_top24 = .data$probability_top24,
      probability_top36 = .data$probability_top36,
      probability_top48 = .data$probability_top48,
      qb_context_modifier = .data$qb_context_modifier,
      matchup_modifier = .data$matchup_modifier,
      player_allocation_share = .data$player_allocation_share,
      role_state_uncertainty_flag = .data$role_state_uncertainty_flag,
      replacement_starter_flag = .data$replacement_starter_flag,
      starter_return_flag = .data$starter_return_flag,
      high_variance_rotation_flag = .data$high_variance_rotation_flag,
      review_flags = .data$review_flags,
      actual_next_week_fp = .data$target_week_fp
    ) |>
    dplyr::arrange(.data$season, .data$week, .data$rank)
  
  if (write_output) {
    utils::write.csv(
      out,
      file.path(model_paths$wow_output_dir, "te_wow_final_export_2021_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

run_te_wow_board_rebuild <- function(write_output = TRUE) {
  load_model_core_packages()
  
  te_wow_board <- build_te_wow_feature_overlay_table(write_output = write_output)
  te_wow_board_summary <- build_te_wow_board_summary(te_wow_board, write_output = write_output)
  te_wow_final_export <- build_te_wow_final_export(te_wow_board, write_output = write_output)
  
  list(
    board = te_wow_board,
    board_summary = te_wow_board_summary,
    final_export = te_wow_final_export
  )
}

k_wow_age_window_score <- function(age_vec) {
  age_vec <- safe_numeric(age_vec)
  out <- 100 - pmin(abs(age_vec - 29) * 7, 100)
  out[!is.finite(age_vec)] <- NA_real_
  out
}

k_wow_centered_rank <- function(x, higher_is_better = TRUE) {
  (qb_wow_percent_rank_0to100(x, higher_is_better = higher_is_better) - 50) / 50
}

k_wow_roof_score_0to100 <- function(roof_vec) {
  roof_chr <- trimws(tolower(as.character(roof_vec)))
  
  dplyr::case_when(
    grepl("dome|indoor|closed", roof_chr) ~ 100,
    grepl("retract", roof_chr) ~ 88,
    grepl("open|outdoor", roof_chr) ~ 62,
    is.na(roof_chr) | roof_chr == "" ~ 68,
    TRUE ~ 70
  )
}

k_wow_surface_score_0to100 <- function(surface_vec) {
  surface_chr <- trimws(tolower(as.character(surface_vec)))
  
  dplyr::case_when(
    grepl("turf|synthetic|artificial", surface_chr) ~ 72,
    grepl("grass|bermuda|kentucky", surface_chr) ~ 60,
    is.na(surface_chr) | surface_chr == "" ~ 64,
    TRUE ~ 65
  )
}

k_wow_weather_score_0to100 <- function(wind_vec, roof_vec) {
  wind_num <- safe_numeric(wind_vec)
  roof_score <- k_wow_roof_score_0to100(roof_vec)
  
  wind_score <- dplyr::case_when(
    !is.finite(wind_num) ~ 66,
    wind_num <= 5 ~ 100,
    wind_num <= 10 ~ 86,
    wind_num <= 15 ~ 72,
    wind_num <= 20 ~ 54,
    wind_num <= 25 ~ 34,
    TRUE ~ 18
  )
  
  ifelse(roof_score >= 95, 100, wind_score)
}

k_wow_spread_context_score_0to100 <- function(spread_vec) {
  spread_abs <- abs(safe_numeric(spread_vec))
  
  dplyr::case_when(
    !is.finite(spread_abs) ~ 56,
    spread_abs <= 1 ~ 100,
    spread_abs <= 3 ~ 92,
    spread_abs <= 5 ~ 84,
    spread_abs <= 7 ~ 74,
    spread_abs <= 10 ~ 60,
    spread_abs <= 14 ~ 42,
    TRUE ~ 24
  )
}

build_k_sos_prior_reference <- function(sos_path = file.path(model_paths$sos_output_dir, "k_sos_final_export_2022_2025.csv")) {
  load_model_core_packages()
  
  empty_out <- data.frame(
    season = integer(),
    player_key = character(),
    k_sos_prior_score = double(),
    k_sos_prior_rank = double(),
    k_sos_anchor_ppg_prior = double(),
    k_sos_anchor_total_prior = double(),
    k_sos_board_score_prior = double(),
    k_sos_production_prior = double(),
    k_sos_volume_prior = double(),
    k_sos_accuracy_prior = double(),
    stringsAsFactors = FALSE
  )
  
  if (!file.exists(sos_path)) {
    return(empty_out)
  }
  
  sos_raw <- read_csv_flexible(sos_path)
  
  if (!all(c("season", "player") %in% names(sos_raw))) {
    return(empty_out)
  }
  
  sos_raw |>
    dplyr::transmute(
      season = safe_integer(.data$season),
      player_key = make_player_key(.data$player),
      k_sos_prior_score = safe_numeric(.data$final_score),
      k_sos_prior_rank = safe_numeric(.data$rank),
      k_sos_anchor_ppg_prior = safe_numeric(.data$anchor_ppg),
      k_sos_anchor_total_prior = safe_numeric(.data$anchor_total_points),
      k_sos_board_score_prior = safe_numeric(.data$board_score),
      k_sos_production_prior = safe_numeric(.data$production),
      k_sos_volume_prior = safe_numeric(.data$volume_opportunity),
      k_sos_accuracy_prior = safe_numeric(.data$accuracy_range)
    ) |>
    dplyr::filter(!is.na(.data$season), !is.na(.data$player_key), .data$player_key != "") |>
    dplyr::distinct(.data$season, .data$player_key, .keep_all = TRUE)
}

build_k_clean_weekly_master <- function(write_output = FALSE, output_dir = model_paths$foundation_output_dir) {
  load_model_core_packages()
  
  k_raw <- load_position_hybrid("K")
  k_team_context <- build_team_week_context_reference()
  
  k_weekly <- k_raw |>
    dplyr::transmute(
      season = .data$season,
      week = .data$week,
      game_number = .data$game_number,
      player = .data$player_name,
      player_key = .data$player_key,
      team = .data$team,
      opponent = .data$opponent_team,
      position = .data$position,
      depth_team = .data$depth_team_num,
      k_depth_role = pick_first_existing_character(k_raw, c("K_Depth_Role")),
      draft_day = pick_first_existing_character(k_raw, c("Draft_Day")),
      report_status = pick_first_existing_character(k_raw, c("report_status")),
      practice_primary_injury = pick_first_existing_character(k_raw, c("practice_primary_injury")),
      practice_secondary_injury = pick_first_existing_character(k_raw, c("practice_secondary_injury")),
      practice_status = pick_first_existing_character(k_raw, c("practice_status")),
      birth_date = pick_first_existing_character(k_raw, c("birth_date")),
      rookie_year = .data$rookie_year_num,
      age = .data$age_num,
      fgm_0_19 = pick_first_existing_numeric(k_raw, c("complete19", "complete_19", "made19", "FGM19", "fgm19")),
      fga_0_19 = pick_first_existing_numeric(k_raw, c("attempt19", "attempt_19", "att19", "FGA19", "fga19")),
      fgm_20_29 = pick_first_existing_numeric(k_raw, c("complete29", "complete_29", "made29", "FGM29", "fgm29")),
      fga_20_29 = pick_first_existing_numeric(k_raw, c("attempt29", "attempt_29", "att29", "FGA29", "fga29")),
      fgm_30_39 = pick_first_existing_numeric(k_raw, c("complete39", "complete_39", "made39", "FGM39", "fgm39")),
      fga_30_39 = pick_first_existing_numeric(k_raw, c("attempt39", "attempt_39", "att39", "FGA39", "fga39")),
      fgm_40_49 = pick_first_existing_numeric(k_raw, c("complete49", "complete_49", "made49", "FGM49", "fgm49")),
      fga_40_49 = pick_first_existing_numeric(k_raw, c("attempt49", "attempt_49", "att49", "FGA49", "fga49")),
      fgm_50_plus = pick_first_existing_numeric(k_raw, c("complete50", "complete_50", "made50", "FGM50", "fgm50")),
      fga_50_plus = pick_first_existing_numeric(k_raw, c("attempt50", "attempt_50", "att50", "FGA50", "fga50")),
      extra_points_made = pick_first_existing_numeric(k_raw, c("epsMade", "epsMade_ply", "xpm", "XPM", "XP_Made")),
      extra_points_attempt = pick_first_existing_numeric(k_raw, c("epsAttempt", "epsAttempt_ply", "xpa", "XPA", "XP_Att")),
      extra_points_pct = pick_first_existing_numeric(k_raw, c("epsPct", "epsPct_ply", "xpPct", "XP_Pct")),
      fantasy_points_source = pick_first_existing_numeric(k_raw, c("fantasyPts", "fantasyPts_ply")),
      game_day = pick_first_existing_character(k_raw, c("gameday_off", "gameday")),
      week_day = pick_first_existing_character(k_raw, c("weekday_off", "weekday")),
      game_time = pick_first_existing_character(k_raw, c("gametime_off", "gametime")),
      team_total_line = pick_first_existing_numeric(k_raw, c("total_line_off", "total_off", "G_total_off")),
      team_spread_line = pick_first_existing_numeric(k_raw, c("spread_line_off", "spread_line")),
      game_temp = pick_first_existing_numeric(k_raw, c("temp_off", "temp")),
      game_wind = pick_first_existing_numeric(k_raw, c("wind_off", "wind")),
      stadium = pick_first_existing_character(k_raw, c("stadium_off", "stadium")),
      roof = pick_first_existing_character(k_raw, c("roof_off", "roof")),
      surface = pick_first_existing_character(k_raw, c("surface_off", "surface")),
      defense_team = pick_first_existing_character(k_raw, c("TM_DEF")),
      defense_name = pick_first_existing_character(k_raw, c("Name_DEF")),
      defense_head_coach = pick_first_existing_character(k_raw, c("Head_Coach_DEF")),
      source_file = pick_first_existing_character(k_raw, c("dataset_file"))
    ) |>
    dplyr::mutate(
      team = normalize_team_abbr(.data$team),
      opponent = normalize_team_abbr(.data$opponent),
      defense_team = normalize_team_abbr(.data$defense_team)
    ) |>
    dplyr::left_join(k_team_context, by = c("season", "week", "team")) |>
    dplyr::mutate(
      opponent = dplyr::coalesce(.data$opponent, .data$opponent_context),
      defense_team = dplyr::coalesce(.data$defense_team, .data$defense_team_context),
      defense_name = dplyr::coalesce(dplyr::na_if(trimws(as.character(.data$defense_name)), ""), .data$defense_name_context),
      defense_head_coach = dplyr::coalesce(dplyr::na_if(trimws(as.character(.data$defense_head_coach)), ""), .data$defense_head_coach_context),
      game_day = dplyr::coalesce(dplyr::na_if(trimws(as.character(.data$game_day)), ""), .data$game_day_context),
      week_day = dplyr::coalesce(dplyr::na_if(trimws(as.character(.data$week_day)), ""), .data$week_day_context),
      game_time = dplyr::coalesce(dplyr::na_if(trimws(as.character(.data$game_time)), ""), .data$game_time_context),
      team_total_line = dplyr::coalesce(.data$team_total_line, .data$team_total_line_context),
      team_spread_line = dplyr::coalesce(.data$team_spread_line, .data$team_spread_line_context),
      game_temp = dplyr::coalesce(.data$game_temp, .data$game_temp_context),
      game_wind = dplyr::coalesce(.data$game_wind, .data$game_wind_context),
      stadium = dplyr::coalesce(dplyr::na_if(trimws(as.character(.data$stadium)), ""), .data$stadium_context),
      roof = dplyr::coalesce(dplyr::na_if(trimws(as.character(.data$roof)), ""), .data$roof_context),
      surface = dplyr::coalesce(dplyr::na_if(trimws(as.character(.data$surface)), ""), .data$surface_context)
    ) |>
    dplyr::select(
      -dplyr::any_of(c(
        "opponent_context",
        "defense_team_context",
        "defense_name_context",
        "defense_head_coach_context",
        "game_day_context",
        "week_day_context",
        "game_time_context",
        "team_total_line_context",
        "team_spread_line_context",
        "game_temp_context",
        "game_wind_context",
        "stadium_context",
        "roof_context",
        "surface_context"
      ))
    ) |>
    dplyr::mutate(
      fgm = dplyr::coalesce(.data$fgm_0_19, 0) +
        dplyr::coalesce(.data$fgm_20_29, 0) +
        dplyr::coalesce(.data$fgm_30_39, 0) +
        dplyr::coalesce(.data$fgm_40_49, 0) +
        dplyr::coalesce(.data$fgm_50_plus, 0),
      fga = dplyr::coalesce(.data$fga_0_19, 0) +
        dplyr::coalesce(.data$fga_20_29, 0) +
        dplyr::coalesce(.data$fga_30_39, 0) +
        dplyr::coalesce(.data$fga_40_49, 0) +
        dplyr::coalesce(.data$fga_50_plus, 0),
      fantasy_points_calc = compute_k_fantasy_points_from_df(k_raw),
      fantasy_points_official = dplyr::coalesce(.data$fantasy_points_source, .data$fantasy_points_calc)
    ) |>
    dplyr::mutate(
      fg_pct = round(safe_div(.data$fgm, .data$fga) * 100, 1),
      starter_flag = dplyr::if_else(!is.na(.data$depth_team) & .data$depth_team <= 1, 1L, 0L)
    ) |>
    dplyr::filter(!is.na(.data$season), !is.na(.data$week), .data$week >= 1, .data$week <= 18) |>
    dplyr::arrange(.data$season, .data$week, .data$team, .data$player)
  
  duplicate_keys <- k_weekly |>
    dplyr::count(.data$season, .data$week, .data$player_key, name = "dup_n") |>
    dplyr::filter(.data$dup_n > 1)
  
  production_columns <- c(
    "fgm_0_19", "fga_0_19", "fgm_20_29", "fga_20_29",
    "fgm_30_39", "fga_30_39", "fgm_40_49", "fga_40_49",
    "fgm_50_plus", "fga_50_plus", "extra_points_made",
    "extra_points_attempt", "fantasy_points_official"
  )
  if (nrow(duplicate_keys) > 0) {
    conflicting_production <- k_weekly |>
      dplyr::semi_join(duplicate_keys, by = c("season", "week", "player_key")) |>
      dplyr::group_by(.data$season, .data$week, .data$player_key) |>
      dplyr::summarise(
        conflict = any(vapply(
          dplyr::pick(dplyr::all_of(production_columns)),
          function(x) dplyr::n_distinct(x, na.rm = FALSE) > 1L,
          logical(1)
        )),
        .groups = "drop"
      ) |>
      dplyr::filter(.data$conflict)
    
    if (nrow(conflicting_production) > 0) {
      stop(
        paste0(
          "K clean weekly master has ", nrow(conflicting_production),
          " player-week duplicates with conflicting kicking production."
        ),
        call. = FALSE
      )
    }
  }
  
  primary_kickers <- k_weekly |>
    dplyr::filter(
      (!is.na(.data$depth_team) & .data$depth_team <= 1) |
        grepl("starter", .data$k_depth_role, ignore.case = TRUE)
    ) |>
    dplyr::filter(dplyr::coalesce(.data$fga, 0) + dplyr::coalesce(.data$extra_points_attempt, 0) > 0) |>
    dplyr::arrange(.data$season, .data$week, .data$team, .data$depth_team, .data$player_key) |>
    dplyr::distinct(.data$season, .data$week, .data$team, .keep_all = TRUE) |>
    dplyr::transmute(season, week, team, primary_kicker_key = .data$player_key)
  
  completeness_columns <- c(
    production_columns, "depth_team", "k_depth_role", "opponent",
    "team_total_line", "team_spread_line", "game_temp", "game_wind"
  )
  k_weekly <- k_weekly |>
    dplyr::left_join(
      primary_kickers,
      by = c("season", "week", "team"),
      relationship = "many-to-one"
    ) |>
    dplyr::mutate(
      .k_competing_primary = as.integer(
        !is.na(.data$primary_kicker_key) & .data$primary_kicker_key != .data$player_key
      ),
      .k_row_completeness = rowSums(!is.na(dplyr::pick(dplyr::all_of(completeness_columns))))
    )
  
  unresolved_team_conflicts <- k_weekly |>
    dplyr::semi_join(duplicate_keys, by = c("season", "week", "player_key")) |>
    dplyr::group_by(.data$season, .data$week, .data$player_key) |>
    dplyr::summarise(
      team_count = dplyr::n_distinct(.data$team),
      best_team_count = dplyr::n_distinct(
        .data$team[.data$.k_competing_primary == min(.data$.k_competing_primary, na.rm = TRUE)]
      ),
      .groups = "drop"
    ) |>
    dplyr::filter(.data$team_count > 1, .data$best_team_count != 1)
  
  if (nrow(unresolved_team_conflicts) > 0) {
    stop(
      paste0(
        "K clean weekly master has ", nrow(unresolved_team_conflicts),
        " cross-team player-week conflicts that cannot be resolved by the primary-kicker depth chart."
      ),
      call. = FALSE
    )
  }
  
  k_weekly <- k_weekly |>
    dplyr::arrange(
      .data$season, .data$week, .data$player_key,
      .data$.k_competing_primary,
      dplyr::desc(.data$.k_row_completeness),
      dplyr::desc(!is.na(.data$source_file) & .data$source_file != "")
    ) |>
    dplyr::distinct(.data$season, .data$week, .data$player_key, .keep_all = TRUE) |>
    dplyr::select(-dplyr::all_of(c("primary_kicker_key", ".k_competing_primary", ".k_row_completeness")))
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      k_weekly,
      file.path(output_dir, "k_clean_weekly_master_2021_2025_regular.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  k_weekly
}

build_k_team_week_opportunity_table <- function(k_weekly = build_k_clean_weekly_master(), write_output = FALSE, output_dir = model_paths$foundation_output_dir) {
  load_model_core_packages()
  
  out <- k_weekly |>
    dplyr::group_by(.data$season, .data$week, .data$team) |>
    dplyr::summarise(
      team_k_games = dplyr::n(),
      team_fga = sum(.data$fga, na.rm = TRUE),
      team_fgm = sum(.data$fgm, na.rm = TRUE),
      team_xpa = sum(.data$extra_points_attempt, na.rm = TRUE),
      team_xpm = sum(.data$extra_points_made, na.rm = TRUE),
      team_fga_40_49 = sum(.data$fga_40_49, na.rm = TRUE),
      team_fgm_40_49 = sum(.data$fgm_40_49, na.rm = TRUE),
      team_fga_50_plus = sum(.data$fga_50_plus, na.rm = TRUE),
      team_fgm_50_plus = sum(.data$fgm_50_plus, na.rm = TRUE),
      team_long_fg_att = sum(dplyr::coalesce(.data$fga_40_49, 0) + dplyr::coalesce(.data$fga_50_plus, 0), na.rm = TRUE),
      team_long_fg_made = sum(dplyr::coalesce(.data$fgm_40_49, 0) + dplyr::coalesce(.data$fgm_50_plus, 0), na.rm = TRUE),
      team_k_fantasy_points = sum(.data$fantasy_points_official, na.rm = TRUE),
      .groups = "drop"
    )
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "k_team_week_opportunity_2021_2025_regular.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_k_player_share_table <- function(
    k_weekly = build_k_clean_weekly_master(),
    team_week = build_k_team_week_opportunity_table(k_weekly),
    write_output = FALSE,
    output_dir = model_paths$foundation_output_dir
) {
  load_model_core_packages()
  
  out <- k_weekly |>
    dplyr::left_join(team_week, by = c("season", "week", "team")) |>
    dplyr::mutate(
      fga_share = safe_div(.data$fga, .data$team_fga),
      fgm_share = safe_div(.data$fgm, .data$team_fgm),
      xpa_share = safe_div(.data$extra_points_attempt, .data$team_xpa),
      xpm_share = safe_div(.data$extra_points_made, .data$team_xpm),
      fantasy_point_share = safe_div(.data$fantasy_points_official, .data$team_k_fantasy_points)
    )
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "k_player_share_table_2021_2025_regular.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_k_weekly_role_usage_table <- function(
    k_share = build_k_player_share_table(),
    write_output = FALSE,
    output_dir = model_paths$foundation_output_dir
) {
  load_model_core_packages()
  
  out <- k_share |>
    dplyr::transmute(
      season,
      week,
      player,
      player_key,
      team,
      opponent,
      depth_team,
      k_depth_role,
      starter_flag,
      report_status,
      practice_primary_injury,
      practice_secondary_injury,
      practice_status,
      draft_day,
      rookie_year,
      age,
      fga,
      fgm,
      fg_pct,
      extra_points_attempt,
      extra_points_made,
      extra_points_pct,
      fga_40_49,
      fgm_40_49,
      fga_50_plus,
      fgm_50_plus,
      fantasy_points_official,
      fga_share,
      fgm_share,
      xpa_share,
      xpm_share,
      fantasy_point_share
    )
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "k_weekly_role_usage_2021_2025_regular.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_k_weekly_feature_base <- function(write_output = FALSE, output_dir = model_paths$wow_output_dir) {
  load_model_core_packages()
  
  k_weekly <- build_k_clean_weekly_master(write_output = write_output)
  k_team_week <- build_k_team_week_opportunity_table(k_weekly = k_weekly, write_output = write_output)
  
  required_team_cols <- c(
    "team_fga", "team_fgm", "team_xpa", "team_xpm",
    "team_long_fg_att", "team_long_fg_made", "team_k_fantasy_points"
  )
  
  if (!all(required_team_cols %in% names(k_team_week))) {
    rebuilt_team_week <- k_weekly |>
      dplyr::group_by(.data$season, .data$week, .data$team) |>
      dplyr::summarise(
        team_fga = sum(.data$fga, na.rm = TRUE),
        team_fgm = sum(.data$fgm, na.rm = TRUE),
        team_xpa = sum(.data$extra_points_attempt, na.rm = TRUE),
        team_xpm = sum(.data$extra_points_made, na.rm = TRUE),
        team_long_fg_att = sum(dplyr::coalesce(.data$fga_40_49, 0) + dplyr::coalesce(.data$fga_50_plus, 0), na.rm = TRUE),
        team_long_fg_made = sum(dplyr::coalesce(.data$fgm_40_49, 0) + dplyr::coalesce(.data$fgm_50_plus, 0), na.rm = TRUE),
        team_k_fantasy_points = sum(.data$fantasy_points_official, na.rm = TRUE),
        .groups = "drop"
      )
    
    k_team_week <- rebuilt_team_week |>
      dplyr::left_join(k_team_week, by = c("season", "week", "team"), suffix = c("", "_old")) |>
      dplyr::mutate(
        team_fga = dplyr::coalesce(.data$team_fga, .data$team_fga_old),
        team_fgm = dplyr::coalesce(.data$team_fgm, .data$team_fgm_old),
        team_xpa = dplyr::coalesce(.data$team_xpa, .data$team_xpa_old),
        team_xpm = dplyr::coalesce(.data$team_xpm, .data$team_xpm_old),
        team_long_fg_att = dplyr::coalesce(.data$team_long_fg_att, .data$team_long_fg_att_old),
        team_long_fg_made = dplyr::coalesce(.data$team_long_fg_made, .data$team_long_fg_made_old),
        team_k_fantasy_points = dplyr::coalesce(.data$team_k_fantasy_points, .data$team_k_fantasy_points_old)
      ) |>
      dplyr::select(-dplyr::ends_with("_old"))
  }
  
  k_team_history <- k_team_week |>
    dplyr::arrange(.data$team, .data$season, .data$week) |>
    dplyr::group_by(.data$team, .data$season) |>
    dplyr::mutate(
      team_games_played_to_date = dplyr::row_number(),
      team_total_kick_ops = dplyr::coalesce(.data$team_fga, 0) + dplyr::coalesce(.data$team_xpa, 0),
      team_fg_settle_rate = safe_div(.data$team_fga, .data$team_total_kick_ops),
      team_xp_share_rate = safe_div(.data$team_xpa, .data$team_total_kick_ops),
      team_season_to_date_fga_pg = cumsum(dplyr::coalesce(.data$team_fga, 0)) / .data$team_games_played_to_date,
      team_season_to_date_xpa_pg = cumsum(dplyr::coalesce(.data$team_xpa, 0)) / .data$team_games_played_to_date,
      team_season_to_date_long_att_pg = cumsum(dplyr::coalesce(.data$team_long_fg_att, 0)) / .data$team_games_played_to_date,
      team_season_to_date_fg_settle_rate = safe_div(
        cumsum(dplyr::coalesce(.data$team_fga, 0)),
        cumsum(dplyr::coalesce(.data$team_fga, 0)) + cumsum(dplyr::coalesce(.data$team_xpa, 0))
      ),
      team_rolling3_fga = rolling_mean_vec(.data$team_fga, 3),
      team_rolling5_fga = rolling_mean_vec(.data$team_fga, 5),
      team_rolling3_xpa = rolling_mean_vec(.data$team_xpa, 3),
      team_rolling5_xpa = rolling_mean_vec(.data$team_xpa, 5),
      team_rolling3_long_att = rolling_mean_vec(.data$team_long_fg_att, 3),
      team_rolling5_long_att = rolling_mean_vec(.data$team_long_fg_att, 5),
      team_rolling3_fg_settle_rate = rolling_mean_vec(.data$team_fg_settle_rate, 3),
      team_rolling5_fg_settle_rate = rolling_mean_vec(.data$team_fg_settle_rate, 5),
      team_rolling3_total_kick_ops = rolling_mean_vec(.data$team_total_kick_ops, 3),
      team_rolling5_total_kick_ops = rolling_mean_vec(.data$team_total_kick_ops, 5),
      team_trend_fga_3v5 = .data$team_rolling3_fga - .data$team_rolling5_fga,
      team_trend_xpa_3v5 = .data$team_rolling3_xpa - .data$team_rolling5_xpa,
      team_trend_fg_settle_3v5 = .data$team_rolling3_fg_settle_rate - .data$team_rolling5_fg_settle_rate
    ) |>
    dplyr::ungroup()
  
  out <- k_weekly |>
    dplyr::left_join(
      k_team_history,
      by = c("season", "week", "team")
    ) |>
    dplyr::arrange(.data$player_key, .data$season, .data$week) |>
    dplyr::group_by(.data$player_key, .data$season) |>
    dplyr::mutate(
      feature_week = .data$week,
      next_week = .data$week + 1L,
      next_week_fantasy_points = dplyr::lead(.data$fantasy_points_official),
      next_week_opponent = dplyr::lead(.data$opponent),
      games_played_to_date = dplyr::row_number(),
      long_fg_attempts = dplyr::coalesce(.data$fga_40_49, 0) + dplyr::coalesce(.data$fga_50_plus, 0),
      long_fg_made = dplyr::coalesce(.data$fgm_40_49, 0) + dplyr::coalesce(.data$fgm_50_plus, 0),
      season_to_date_fantasy_points = cumsum(dplyr::coalesce(.data$fantasy_points_official, 0)),
      season_to_date_fantasy_points_per_game = season_to_date_fantasy_points / games_played_to_date,
      season_to_date_fga_per_game = cumsum(dplyr::coalesce(.data$fga, 0)) / games_played_to_date,
      season_to_date_xpa_per_game = cumsum(dplyr::coalesce(.data$extra_points_attempt, 0)) / games_played_to_date,
      season_to_date_long_att_per_game = cumsum(dplyr::coalesce(.data$long_fg_attempts, 0)) / games_played_to_date,
      season_to_date_long_made_per_game = cumsum(dplyr::coalesce(.data$long_fg_made, 0)) / games_played_to_date,
      season_to_date_long_fg_pct = safe_div(
        cumsum(dplyr::coalesce(.data$long_fg_made, 0)),
        cumsum(dplyr::coalesce(.data$long_fg_attempts, 0))
      ),
      rolling3_fantasy_points = rolling_mean_vec(.data$fantasy_points_official, 3),
      rolling5_fantasy_points = rolling_mean_vec(.data$fantasy_points_official, 5),
      rolling3_fga = rolling_mean_vec(.data$fga, 3),
      rolling5_fga = rolling_mean_vec(.data$fga, 5),
      rolling3_fgm = rolling_mean_vec(.data$fgm, 3),
      rolling5_fgm = rolling_mean_vec(.data$fgm, 5),
      rolling3_xpa = rolling_mean_vec(.data$extra_points_attempt, 3),
      rolling5_xpa = rolling_mean_vec(.data$extra_points_attempt, 5),
      rolling3_xpm = rolling_mean_vec(.data$extra_points_made, 3),
      rolling5_xpm = rolling_mean_vec(.data$extra_points_made, 5),
      rolling3_fg_pct = rolling_mean_vec(.data$fg_pct, 3),
      rolling5_fg_pct = rolling_mean_vec(.data$fg_pct, 5),
      rolling5_xp_pct = rolling_mean_vec(.data$extra_points_pct, 5),
      rolling3_long_att = rolling_mean_vec(.data$long_fg_attempts, 3),
      rolling5_long_att = rolling_mean_vec(.data$long_fg_attempts, 5),
      rolling3_long_made = rolling_mean_vec(.data$long_fg_made, 3),
      rolling5_long_made = rolling_mean_vec(.data$long_fg_made, 5),
      rolling5_long_fg_pct = safe_div(.data$rolling5_long_made, .data$rolling5_long_att),
      rolling5_team_total_line = rolling_mean_vec(.data$team_total_line, 5),
      rolling5_fantasy_points_sd = rolling_sd_vec(.data$fantasy_points_official, 5),
      rolling5_fga_sd = rolling_sd_vec(.data$fga, 5),
      rolling5_xpa_sd = rolling_sd_vec(.data$extra_points_attempt, 5),
      recent_2plus_fga_flag = as.integer(dplyr::coalesce(.data$fga, 0) >= 2),
      recent_3plus_xpa_flag = as.integer(dplyr::coalesce(.data$extra_points_attempt, 0) >= 3),
      games_with_2plus_fga_recent_rate = rolling_mean_vec(.data$recent_2plus_fga_flag, 5),
      games_with_3plus_xpa_recent_rate = rolling_mean_vec(.data$recent_3plus_xpa_flag, 5),
      trend_fantasy_points_3v5 = .data$rolling3_fantasy_points - .data$rolling5_fantasy_points,
      trend_fga_3v5 = .data$rolling3_fga - .data$rolling5_fga,
      trend_xpa_3v5 = .data$rolling3_xpa - .data$rolling5_xpa,
      depth_order_current = .data$depth_team,
      target_week_fp = .data$next_week_fantasy_points
    ) |>
    dplyr::ungroup()
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "k_weekly_feature_base_2021_2025_regular.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_k_wow_inputs <- function(write_output = FALSE) {
  load_model_core_packages()
  
  k_weekly_feature_base <- build_k_weekly_feature_base(write_output = write_output)
  
  out <- list(
    position = "K",
    mode = "week_over_week",
    handoff = NULL,
    handoff_text = NA_character_,
    weekly_base = build_wow_weekly_base("K"),
    k_clean_weekly_master = build_k_clean_weekly_master(write_output = write_output),
    k_weekly_feature_base = k_weekly_feature_base,
    next_steps = c(
      "Use the reconstructed weekly kicking table as the no-leakage base for next-week training.",
      "Blend recent fantasy production, attempt volume, range profile, and matchup allowance into the weekly board.",
      "Layer DST allowance next so the same special-teams framework can cover kickers and team defenses."
    )
  )
  
  if (write_output) {
    out$output_paths <- c(
      k_wow_weekly_base = write_wow_weekly_base("K"),
      k_clean_weekly_master = file.path(model_paths$foundation_output_dir, "k_clean_weekly_master_2021_2025_regular.csv"),
      k_weekly_feature_base = file.path(model_paths$wow_output_dir, "k_weekly_feature_base_2021_2025_regular.csv")
    )
  }
  
  out
}

make_k_wow_output_manifest <- function(k_wow_result) {
  output_paths <- unname(k_wow_result$output_paths %||% character())
  output_labels <- names(k_wow_result$output_paths %||% character())
  
  data.frame(
    output_name = output_labels,
    output_path = output_paths,
    exists = file.exists(output_paths),
    stringsAsFactors = FALSE
  )
}

run_k_wow_pipeline <- function(write_output = TRUE) {
  load_model_core_packages()
  
  dir.create(model_paths$wow_output_dir, recursive = TRUE, showWarnings = FALSE)
  
  k_wow_result <- build_k_wow_inputs(write_output = write_output)
  k_wow_board_rebuild <- run_k_wow_board_rebuild(write_output = write_output)
  
  output_paths <- c(
    k_wow_result$output_paths %||% character(),
    k_wow_feature_overlay = file.path(model_paths$wow_output_dir, "k_wow_feature_overlay_2021_2025.csv"),
    k_wow_board_metrics = file.path(model_paths$wow_output_dir, "k_wow_board_metrics_2021_2025.csv"),
    k_wow_board_summary = file.path(model_paths$wow_output_dir, "k_wow_board_summary_2021_2025.csv"),
    k_wow_final_export = file.path(model_paths$wow_output_dir, "k_wow_final_export_2021_2025.csv")
  )
  
  k_wow_result$output_paths <- output_paths
  output_manifest <- make_k_wow_output_manifest(k_wow_result)
  
  list(
    result = k_wow_result,
    board = k_wow_board_rebuild$board,
    board_summary = k_wow_board_rebuild$board_summary,
    final_export = k_wow_board_rebuild$final_export,
    output_manifest = output_manifest
  )
}

build_k_prior_season_week1_summary <- function(k_wow_feature_base) {
  load_model_core_packages()
  
  season_summary <- k_wow_feature_base |>
    dplyr::mutate(
      player_key = as.character(.data$player_key),
      season = suppressWarnings(as.integer(.data$season)),
      fantasy_points_official = suppressWarnings(as.numeric(.data$fantasy_points_official)),
      fga = suppressWarnings(as.numeric(.data$fga)),
      fgm = suppressWarnings(as.numeric(.data$fgm)),
      extra_points_attempt = suppressWarnings(as.numeric(.data$extra_points_attempt)),
      extra_points_made = suppressWarnings(as.numeric(.data$extra_points_made)),
      long_fg_attempts = suppressWarnings(as.numeric(.data$long_fg_attempts)),
      long_fg_made = suppressWarnings(as.numeric(.data$long_fg_made))
    ) |>
    dplyr::group_by(.data$player_key, .data$season) |>
    dplyr::summarise(
      season_games = sum(is.finite(.data$fantasy_points_official)),
      season_total_fp = sum(.data$fantasy_points_official, na.rm = TRUE),
      season_ppg = safe_div(.data$season_total_fp, .data$season_games),
      season_fga = sum(.data$fga, na.rm = TRUE),
      season_fgm = sum(.data$fgm, na.rm = TRUE),
      season_xpa = sum(.data$extra_points_attempt, na.rm = TRUE),
      season_xpm = sum(.data$extra_points_made, na.rm = TRUE),
      season_long_att = sum(.data$long_fg_attempts, na.rm = TRUE),
      season_long_made = sum(.data$long_fg_made, na.rm = TRUE),
      .groups = "drop"
    ) |>
    dplyr::mutate(
      season_fga_pg = safe_div(.data$season_fga, .data$season_games),
      season_xpa_pg = safe_div(.data$season_xpa, .data$season_games),
      season_fg_pct = round(safe_div(.data$season_fgm, .data$season_fga) * 100, 1),
      season_xp_pct = round(safe_div(.data$season_xpm, .data$season_xpa) * 100, 1),
      season_long_att_pg = safe_div(.data$season_long_att, .data$season_games),
      season_long_made_pg = safe_div(.data$season_long_made, .data$season_games)
    )
  
  prior_summary <- season_summary |>
    dplyr::transmute(
      player_key = .data$player_key,
      season = .data$season + 1L,
      prior_season_games = .data$season_games,
      prior_season_ppg = .data$season_ppg,
      prior_season_total_fp = .data$season_total_fp,
      prior_season_fga_pg = .data$season_fga_pg,
      prior_season_xpa_pg = .data$season_xpa_pg,
      prior_season_fg_pct = .data$season_fg_pct,
      prior_season_xp_pct = .data$season_xp_pct,
      prior_season_long_att_pg = .data$season_long_att_pg,
      prior_season_long_made_pg = .data$season_long_made_pg
    )
  
  target_rows <- season_summary |>
    dplyr::distinct(.data$player_key, .data$season)
  
  career_summary <- lapply(seq_len(nrow(target_rows)), function(i) {
    player_key_i <- target_rows$player_key[[i]]
    season_i <- target_rows$season[[i]]
    
    hist <- season_summary |>
      dplyr::filter(.data$player_key == player_key_i, .data$season < season_i, .data$season_games > 0)
    
    if (nrow(hist) == 0) {
      return(data.frame(
        player_key = player_key_i,
        season = season_i,
        career_games = NA_real_,
        career_seasons = NA_real_,
        career_ppg = NA_real_,
        career_total_fp = NA_real_,
        career_fga_pg = NA_real_,
        career_xpa_pg = NA_real_,
        career_fg_pct = NA_real_,
        career_xp_pct = NA_real_,
        career_long_att_pg = NA_real_,
        career_long_made_pg = NA_real_,
        last_active_season = NA_real_,
        years_since_last_active = NA_real_,
        stringsAsFactors = FALSE
      ))
    }
    
    total_games <- sum(hist$season_games, na.rm = TRUE)
    total_fp <- sum(hist$season_total_fp, na.rm = TRUE)
    total_fga <- sum(hist$season_fga, na.rm = TRUE)
    total_fgm <- sum(hist$season_fgm, na.rm = TRUE)
    total_xpa <- sum(hist$season_xpa, na.rm = TRUE)
    total_xpm <- sum(hist$season_xpm, na.rm = TRUE)
    total_long_att <- sum(hist$season_long_att, na.rm = TRUE)
    total_long_made <- sum(hist$season_long_made, na.rm = TRUE)
    last_active <- max(hist$season, na.rm = TRUE)
    
    data.frame(
      player_key = player_key_i,
      season = season_i,
      career_games = total_games,
      career_seasons = nrow(hist),
      career_ppg = safe_div(total_fp, total_games),
      career_total_fp = total_fp,
      career_fga_pg = safe_div(total_fga, total_games),
      career_xpa_pg = safe_div(total_xpa, total_games),
      career_fg_pct = round(safe_div(total_fgm, total_fga) * 100, 1),
      career_xp_pct = round(safe_div(total_xpm, total_xpa) * 100, 1),
      career_long_att_pg = safe_div(total_long_att, total_games),
      career_long_made_pg = safe_div(total_long_made, total_games),
      last_active_season = last_active,
      years_since_last_active = season_i - last_active,
      stringsAsFactors = FALSE
    )
  }) |>
    dplyr::bind_rows()
  
  target_rows |>
    dplyr::left_join(prior_summary, by = c("player_key", "season")) |>
    dplyr::left_join(career_summary, by = c("player_key", "season"))
}

build_k_wow_defense_context <- function(k_wow_feature_base) {
  load_model_core_packages()
  
  k_wow_feature_base |>
    dplyr::group_by(feature_week = .data$week, season = .data$season, defense_team = .data$opponent) |>
    dplyr::summarise(
      k_fp_allowed = sum(.data$fantasy_points_official, na.rm = TRUE),
      k_fga_allowed = sum(.data$fga, na.rm = TRUE),
      k_xpa_allowed = sum(.data$extra_points_attempt, na.rm = TRUE),
      k_long_att_allowed = sum(.data$long_fg_attempts, na.rm = TRUE),
      .groups = "drop"
    ) |>
    dplyr::arrange(.data$defense_team, .data$season, .data$feature_week) |>
    dplyr::group_by(.data$defense_team, .data$season) |>
    dplyr::mutate(
      trailing3_k_fp_allowed = dplyr::lag(rolling_mean_vec(.data$k_fp_allowed, 3)),
      trailing5_k_fp_allowed = dplyr::lag(rolling_mean_vec(.data$k_fp_allowed, 5)),
      trailing5_k_fga_allowed = dplyr::lag(rolling_mean_vec(.data$k_fga_allowed, 5)),
      trailing5_k_xpa_allowed = dplyr::lag(rolling_mean_vec(.data$k_xpa_allowed, 5)),
      trailing5_k_long_att_allowed = dplyr::lag(rolling_mean_vec(.data$k_long_att_allowed, 5))
    ) |>
    dplyr::ungroup()
}

build_k_wow_feature_overlay_table <- function(k_wow_feature_base = NULL, write_output = TRUE, output_dir = model_paths$wow_output_dir) {
  load_model_core_packages()
  
  if (is.null(k_wow_feature_base)) {
    k_wow_feature_base <- build_k_weekly_feature_base(write_output = FALSE)
  }
  
  k_prior_season_summary <- build_k_prior_season_week1_summary(k_wow_feature_base)
  k_defense_context <- build_k_wow_defense_context(k_wow_feature_base)
  k_sos_prior_reference <- build_k_sos_prior_reference()
  
  out <- k_wow_feature_base |>
    dplyr::left_join(k_prior_season_summary, by = c("player_key", "season")) |>
    dplyr::left_join(k_defense_context, by = c("season", "feature_week", "next_week_opponent" = "defense_team")) |>
    dplyr::left_join(k_sos_prior_reference, by = c("season", "player_key")) |>
    dplyr::mutate(
      season = suppressWarnings(as.integer(.data$season)),
      week = suppressWarnings(as.integer(.data$week)),
      feature_week = suppressWarnings(as.integer(.data$feature_week)),
      depth_team = suppressWarnings(as.numeric(.data$depth_team)),
      age = suppressWarnings(as.numeric(.data$age)),
      rookie_year = suppressWarnings(as.numeric(.data$rookie_year)),
      target_week_fp = suppressWarnings(as.numeric(.data$target_week_fp)),
      healthy_flag = as.integer(
        dplyr::coalesce(.data$report_status, "Active") %in% c("Active", "Healthy") &
          dplyr::coalesce(.data$practice_status, "Full") %in% c("Full", "Healthy")
      ),
      k_wow_anchor_fp = dplyr::coalesce(
        .data$season_to_date_fantasy_points_per_game,
        .data$rolling3_fantasy_points,
        .data$rolling5_fantasy_points,
        .data$fantasy_points_official
      ),
      preseason_weight = dplyr::case_when(
        .data$week <= 1L ~ 0.75,
        .data$week == 2L ~ 0.58,
        .data$week == 3L ~ 0.42,
        .data$week == 4L ~ 0.30,
        .data$week == 5L ~ 0.20,
        TRUE ~ 0.10
      ),
      has_prior_season_stats = is.finite(.data$prior_season_ppg) & .data$prior_season_games >= 4,
      has_career_stats = is.finite(.data$career_ppg) & .data$career_games >= 4,
      is_true_rookie = is.finite(.data$rookie_year) & .data$season == .data$rookie_year,
      draft_day_score_0to100 = qb_draft_day_score_0to100(.data$draft_day),
      k_sos_prior_fp_seed = dplyr::coalesce(.data$k_sos_anchor_ppg_prior, .data$prior_season_ppg, .data$career_ppg),
      roof_context_score = k_wow_roof_score_0to100(.data$roof),
      surface_context_score = k_wow_surface_score_0to100(.data$surface),
      weather_context_score = k_wow_weather_score_0to100(.data$game_wind, .data$roof),
      spread_context_score = k_wow_spread_context_score_0to100(.data$team_spread_line)
    ) |>
    dplyr::group_by(.data$season, .data$feature_week) |>
    dplyr::mutate(
      wow_anchor_rank_component = qb_wow_percent_rank_0to100(.data$k_wow_anchor_fp),
      team_total_line_rank = qb_wow_percent_rank_0to100(.data$team_total_line),
      rolling_team_total_line_rank = qb_wow_percent_rank_0to100(.data$rolling5_team_total_line),
      prior_season_production_score = qb_wow_row_mean(
        qb_wow_percent_rank_0to100(.data$prior_season_ppg),
        qb_wow_percent_rank_0to100(.data$prior_season_total_fp),
        qb_wow_percent_rank_0to100(.data$prior_season_fga_pg),
        qb_wow_percent_rank_0to100(.data$prior_season_xpa_pg),
        qb_wow_percent_rank_0to100(.data$prior_season_fg_pct),
        qb_wow_percent_rank_0to100(.data$prior_season_xp_pct),
        qb_wow_percent_rank_0to100(.data$prior_season_long_att_pg),
        qb_wow_percent_rank_0to100(.data$prior_season_long_made_pg)
      ),
      career_production_score = qb_wow_row_mean(
        qb_wow_percent_rank_0to100(.data$career_ppg),
        qb_wow_percent_rank_0to100(.data$career_total_fp),
        qb_wow_percent_rank_0to100(.data$career_fga_pg),
        qb_wow_percent_rank_0to100(.data$career_xpa_pg),
        qb_wow_percent_rank_0to100(.data$career_fg_pct),
        qb_wow_percent_rank_0to100(.data$career_xp_pct),
        qb_wow_percent_rank_0to100(.data$career_long_att_pg),
        qb_wow_percent_rank_0to100(.data$career_long_made_pg)
      ),
      k_sos_prior_component_0to100 = qb_wow_row_mean(
        .data$k_sos_prior_score,
        qb_wow_percent_rank_0to100(.data$k_sos_anchor_ppg_prior),
        qb_wow_percent_rank_0to100(.data$k_sos_anchor_total_prior),
        .data$k_sos_board_score_prior,
        .data$k_sos_production_prior,
        .data$k_sos_volume_prior,
        .data$k_sos_accuracy_prior
      ),
      production_component_0to100 = qb_wow_row_mean(
        qb_wow_percent_rank_0to100(.data$rolling3_fantasy_points),
        qb_wow_percent_rank_0to100(.data$rolling5_fantasy_points),
        qb_wow_percent_rank_0to100(.data$season_to_date_fantasy_points_per_game)
      ),
      team_opportunity_baseline_component_0to100 =
        0.26 * qb_wow_percent_rank_0to100(.data$team_rolling3_fga) +
        0.18 * qb_wow_percent_rank_0to100(.data$team_rolling5_fga) +
        0.10 * qb_wow_percent_rank_0to100(.data$team_season_to_date_fga_pg) +
        0.08 * qb_wow_percent_rank_0to100(.data$team_rolling3_xpa) +
        0.06 * qb_wow_percent_rank_0to100(.data$team_rolling5_xpa) +
        0.08 * qb_wow_percent_rank_0to100(.data$team_season_to_date_xpa_pg) +
        0.12 * qb_wow_percent_rank_0to100(.data$team_rolling3_long_att) +
        0.07 * qb_wow_percent_rank_0to100(.data$team_rolling5_long_att) +
        0.05 * .data$team_total_line_rank,
      fg_settle_environment_component_0to100 =
        0.28 * qb_wow_percent_rank_0to100(.data$team_rolling3_fg_settle_rate) +
        0.22 * qb_wow_percent_rank_0to100(.data$team_rolling5_fg_settle_rate) +
        0.15 * qb_wow_percent_rank_0to100(.data$team_season_to_date_fg_settle_rate) +
        0.10 * qb_wow_percent_rank_0to100(.data$team_trend_fg_settle_3v5) +
        0.10 * qb_wow_percent_rank_0to100(.data$team_rolling3_fga) +
        0.05 * qb_wow_percent_rank_0to100(.data$team_rolling3_long_att) +
        0.10 * qb_wow_percent_rank_0to100(.data$team_rolling3_total_kick_ops),
      volume_opportunity_component_0to100 =
        0.18 * qb_wow_percent_rank_0to100(.data$rolling3_fga) +
        0.12 * qb_wow_percent_rank_0to100(.data$rolling5_fga) +
        0.12 * qb_wow_percent_rank_0to100(.data$rolling3_xpa) +
        0.07 * qb_wow_percent_rank_0to100(.data$rolling5_xpa) +
        0.09 * qb_wow_percent_rank_0to100(.data$games_with_2plus_fga_recent_rate) +
        0.06 * qb_wow_percent_rank_0to100(.data$games_with_3plus_xpa_recent_rate) +
        0.08 * qb_wow_percent_rank_0to100(.data$rolling3_long_att) +
        0.04 * .data$team_total_line_rank +
        0.24 * .data$team_opportunity_baseline_component_0to100,
      accuracy_range_component_0to100 =
        0.20 * qb_wow_percent_rank_0to100(.data$rolling5_fg_pct) +
        0.10 * qb_wow_percent_rank_0to100(.data$rolling5_xp_pct) +
        0.18 * qb_wow_percent_rank_0to100(.data$rolling5_long_fg_pct) +
        0.14 * qb_wow_percent_rank_0to100(.data$season_to_date_long_fg_pct) +
        0.12 * qb_wow_percent_rank_0to100(.data$rolling3_long_att) +
        0.10 * qb_wow_percent_rank_0to100(.data$rolling5_long_att) +
        0.08 * qb_wow_percent_rank_0to100(.data$rolling5_long_made) +
        0.08 * dplyr::coalesce(.data$k_sos_accuracy_prior, 50),
      team_fg_attempt_baseline_component_0to100 =
        0.40 * dplyr::coalesce(qb_wow_percent_rank_0to100(.data$team_rolling3_fga), 50) +
        0.25 * dplyr::coalesce(qb_wow_percent_rank_0to100(.data$team_rolling5_fga), 50) +
        0.15 * dplyr::coalesce(qb_wow_percent_rank_0to100(.data$team_season_to_date_fga_pg), 50) +
        0.10 * dplyr::coalesce(qb_wow_percent_rank_0to100(.data$team_trend_fga_3v5), 50) +
        0.10 * dplyr::coalesce(qb_wow_percent_rank_0to100(.data$team_rolling3_long_att), 50),
      player_fg_attempt_component_0to100 =
        0.40 * dplyr::coalesce(qb_wow_percent_rank_0to100(.data$rolling3_fga), 50) +
        0.25 * dplyr::coalesce(qb_wow_percent_rank_0to100(.data$rolling5_fga), 50) +
        0.15 * dplyr::coalesce(qb_wow_percent_rank_0to100(.data$season_to_date_fga_per_game), 50) +
        0.10 * dplyr::coalesce(qb_wow_percent_rank_0to100(.data$games_with_2plus_fga_recent_rate), 50) +
        0.10 * dplyr::coalesce(qb_wow_percent_rank_0to100(.data$rolling3_long_att), 50),
      long_range_reliability_component_0to100 =
        0.30 * dplyr::coalesce(qb_wow_percent_rank_0to100(.data$rolling5_long_fg_pct), 50) +
        0.25 * dplyr::coalesce(qb_wow_percent_rank_0to100(.data$season_to_date_long_fg_pct), 50) +
        0.20 * dplyr::coalesce(qb_wow_percent_rank_0to100(.data$rolling5_long_made), 50) +
        0.10 * dplyr::coalesce(qb_wow_percent_rank_0to100(.data$rolling3_long_att), 50) +
        0.10 * dplyr::coalesce(qb_wow_percent_rank_0to100(.data$rolling5_long_att), 50) +
        0.05 * dplyr::coalesce(.data$k_sos_accuracy_prior, 50),
      weather_venue_component_0to100 = qb_wow_row_mean(
        .data$weather_context_score,
        .data$roof_context_score,
        .data$surface_context_score
      ),
      market_environment_component_0to100 =
        0.35 * .data$team_total_line_rank +
        0.15 * .data$rolling_team_total_line_rank +
        0.25 * .data$spread_context_score +
        0.25 * .data$weather_venue_component_0to100,
      scoring_environment_component_0to100 = qb_wow_row_mean(
        qb_wow_percent_rank_0to100(.data$season_to_date_xpa_per_game),
        qb_wow_percent_rank_0to100(.data$rolling3_xpa),
        qb_wow_percent_rank_0to100(.data$rolling5_xpa),
        qb_wow_percent_rank_0to100(.data$rolling5_xpm),
        qb_wow_percent_rank_0to100(.data$games_with_3plus_xpa_recent_rate),
        .data$market_environment_component_0to100
      ),
      availability_component_0to100 = qb_wow_row_mean(
        qb_wow_percent_rank_0to100(.data$depth_order_current, higher_is_better = FALSE),
        qb_wow_percent_rank_0to100(.data$healthy_flag),
        qb_wow_percent_rank_0to100(.data$prior_season_games),
        qb_wow_percent_rank_0to100(.data$career_games)
      ),
      ceiling_opportunity_component_0to100 = qb_wow_row_mean(
        qb_wow_percent_rank_0to100(.data$rolling5_fga_sd),
        qb_wow_percent_rank_0to100(.data$rolling5_xpa_sd),
        qb_wow_percent_rank_0to100(.data$rolling3_long_att),
        qb_wow_percent_rank_0to100(.data$rolling5_long_att),
        qb_wow_percent_rank_0to100(.data$rolling5_long_made),
        .data$team_total_line_rank
      ),
      momentum_component_0to100 = qb_wow_row_mean(
        qb_wow_percent_rank_0to100(.data$trend_fantasy_points_3v5),
        qb_wow_percent_rank_0to100(.data$trend_fga_3v5),
        qb_wow_percent_rank_0to100(.data$trend_xpa_3v5)
      ),
      matchup_ease_component_0to100 = qb_wow_row_mean(
        qb_wow_percent_rank_0to100(.data$trailing5_k_fp_allowed),
        qb_wow_percent_rank_0to100(.data$trailing5_k_fga_allowed),
        qb_wow_percent_rank_0to100(.data$trailing5_k_xpa_allowed),
        qb_wow_percent_rank_0to100(.data$trailing5_k_long_att_allowed)
      ),
      k_production_anchor_historical_scaled = dplyr::case_when(
        is.finite(.data$k_sos_prior_component_0to100) ~
          0.55 * dplyr::coalesce(.data$k_sos_prior_component_0to100, 0) +
          0.25 * dplyr::coalesce(.data$prior_season_production_score, 0) +
          0.20 * dplyr::coalesce(.data$career_production_score, 0),
        .data$has_prior_season_stats ~
          0.55 * dplyr::coalesce(.data$prior_season_production_score, 0) +
          0.45 * dplyr::coalesce(.data$career_production_score, 0),
        .data$has_career_stats ~ dplyr::coalesce(.data$career_production_score, 0),
        TRUE ~ dplyr::coalesce(.data$wow_anchor_rank_component, 50)
      ),
      preseason_anchor_score_raw = dplyr::case_when(
        is.finite(.data$k_sos_prior_component_0to100) ~
          0.50 * dplyr::coalesce(.data$k_sos_prior_component_0to100, 0) +
          0.12 * dplyr::coalesce(.data$prior_season_production_score, 0) +
          0.08 * dplyr::coalesce(.data$career_production_score, 0) +
          0.10 * dplyr::coalesce(.data$availability_component_0to100, 0) +
          0.10 * dplyr::coalesce(.data$market_environment_component_0to100, 0) +
          0.10 * dplyr::coalesce(.data$scoring_environment_component_0to100, 0),
        .data$has_prior_season_stats ~
          0.45 * dplyr::coalesce(.data$prior_season_production_score, 0) +
          0.20 * dplyr::coalesce(.data$career_production_score, 0) +
          0.15 * dplyr::coalesce(.data$wow_anchor_rank_component, 0) +
          0.10 * dplyr::coalesce(.data$availability_component_0to100, 0) +
          0.10 * dplyr::coalesce(.data$draft_day_score_0to100, 50),
        .data$has_career_stats ~
          0.60 * dplyr::coalesce(.data$career_production_score, 0) +
          0.15 * dplyr::coalesce(.data$wow_anchor_rank_component, 0) +
          0.15 * dplyr::coalesce(.data$availability_component_0to100, 0) +
          0.10 * dplyr::coalesce(.data$draft_day_score_0to100, 50),
        TRUE ~
          0.45 * dplyr::coalesce(.data$wow_anchor_rank_component, 50) +
          0.20 * dplyr::coalesce(.data$availability_component_0to100, 50) +
          0.15 * dplyr::coalesce(.data$scoring_environment_component_0to100, 50) +
          0.20 * dplyr::coalesce(.data$draft_day_score_0to100, 50)
      ),
      preseason_anchor_score = dplyr::if_else(.data$is_true_rookie, pmin(.data$preseason_anchor_score_raw, 72), .data$preseason_anchor_score_raw),
      k_preseason_omfg_score = .data$preseason_anchor_score,
      inseason_omfg_component =
        0.20 * .data$production_component_0to100 +
        0.18 * .data$volume_opportunity_component_0to100 +
        0.20 * .data$team_opportunity_baseline_component_0to100 +
        0.02 * .data$fg_settle_environment_component_0to100 +
        0.14 * .data$market_environment_component_0to100 +
        0.10 * .data$scoring_environment_component_0to100 +
        0.10 * .data$accuracy_range_component_0to100 +
        0.04 * .data$matchup_ease_component_0to100 +
        0.02 * .data$availability_component_0to100,
      k_in_season_omfg_score = pmin(100, pmax(0,
                                              dplyr::if_else(
                                                .data$week == 1L,
                                                .data$preseason_anchor_score,
                                                .data$preseason_weight * .data$preseason_anchor_score + (1 - .data$preseason_weight) * .data$inseason_omfg_component
                                              )
      )),
      k_anchor_board_score = qb_wow_row_mean(
        .data$k_sos_prior_component_0to100,
        .data$k_production_anchor_historical_scaled,
        .data$k_preseason_omfg_score,
        .data$wow_anchor_rank_component
      ),
      role_modifier = pmin(1.15, pmax(0.85,
                                      1 +
                                        k_wow_centered_rank(.data$availability_component_0to100) * 0.06 +
                                        k_wow_centered_rank(.data$ceiling_opportunity_component_0to100) * 0.04
      )),
      scoring_environment_modifier = pmin(1.12, pmax(0.88,
                                                     1 +
                                                       k_wow_centered_rank(.data$scoring_environment_component_0to100) * 0.08 +
                                                       k_wow_centered_rank(.data$market_environment_component_0to100) * 0.06
      )),
      weather_modifier = pmin(1.10, pmax(0.90,
                                         1 +
                                           k_wow_centered_rank(.data$weather_venue_component_0to100) * 0.10
      )),
      matchup_modifier = pmin(1.08, pmax(0.92,
                                         1 +
                                           k_wow_centered_rank(.data$matchup_ease_component_0to100) * 0.08 +
                                           k_wow_centered_rank(.data$spread_context_score) * 0.04
      )),
      player_expected_opportunity_fp = dplyr::coalesce(
        3.20 * dplyr::coalesce(.data$rolling3_fga, 0) +
          0.90 * dplyr::coalesce(.data$rolling3_xpa, 0) +
          0.55 * dplyr::coalesce(.data$rolling3_long_att, 0),
        3.10 * dplyr::coalesce(.data$rolling5_fga, 0) +
          0.85 * dplyr::coalesce(.data$rolling5_xpa, 0) +
          0.50 * dplyr::coalesce(.data$rolling5_long_att, 0),
        3.05 * dplyr::coalesce(.data$season_to_date_fga_per_game, 0) +
          0.82 * dplyr::coalesce(.data$season_to_date_xpa_per_game, 0) +
          0.45 * dplyr::coalesce(.data$season_to_date_long_att_per_game, 0)
      ),
      team_expected_opportunity_fp = dplyr::coalesce(
        3.25 * dplyr::coalesce(.data$team_rolling3_fga, 0) +
          0.80 * dplyr::coalesce(.data$team_rolling3_xpa, 0) +
          0.55 * dplyr::coalesce(.data$team_rolling3_long_att, 0),
        3.15 * dplyr::coalesce(.data$team_rolling5_fga, 0) +
          0.78 * dplyr::coalesce(.data$team_rolling5_xpa, 0) +
          0.50 * dplyr::coalesce(.data$team_rolling5_long_att, 0),
        3.10 * dplyr::coalesce(.data$team_season_to_date_fga_pg, 0) +
          0.75 * dplyr::coalesce(.data$team_season_to_date_xpa_pg, 0) +
          0.45 * dplyr::coalesce(.data$team_season_to_date_long_att_pg, 0)
      ),
      settle_bonus_fp = 1.20 * dplyr::coalesce(.data$fg_settle_environment_component_0to100, 50) / 100,
      expected_opportunity_fp = dplyr::coalesce(
        0.60 * .data$player_expected_opportunity_fp +
          0.40 * .data$team_expected_opportunity_fp,
        0.35 * .data$player_expected_opportunity_fp +
          0.65 * .data$team_expected_opportunity_fp,
        .data$player_expected_opportunity_fp,
        .data$team_expected_opportunity_fp
      ),
      base_projection_seed = dplyr::coalesce(
        0.24 * .data$k_sos_prior_fp_seed +
          0.20 * .data$season_to_date_fantasy_points_per_game +
          0.14 * .data$rolling3_fantasy_points +
          0.08 * .data$rolling5_fantasy_points +
          0.34 * .data$expected_opportunity_fp,
        .data$k_sos_prior_fp_seed,
        .data$season_to_date_fantasy_points_per_game,
        .data$rolling3_fantasy_points,
        .data$rolling5_fantasy_points,
        .data$fantasy_points_official
      ),
      weekly_projected_fp = .data$base_projection_seed *
        .data$role_modifier *
        .data$scoring_environment_modifier *
        .data$weather_modifier *
        .data$matchup_modifier,
      weekly_projected_fp_rank_component = qb_wow_percent_rank_0to100(.data$weekly_projected_fp),
      xpa_sd_rank_component = qb_wow_percent_rank_0to100(.data$rolling5_xpa_sd),
      xpm_rank_component = qb_wow_percent_rank_0to100(.data$rolling5_xpm),
      expected_opportunity_rank = qb_wow_percent_rank_0to100(.data$expected_opportunity_fp),
      opp_pressure_rank_component =
        0.34 * qb_wow_percent_rank_0to100(.data$trailing5_k_fga_allowed) +
        0.30 * qb_wow_percent_rank_0to100(.data$trailing5_k_xpa_allowed) +
        0.16 * qb_wow_percent_rank_0to100(.data$trailing5_k_long_att_allowed) +
        0.20 * qb_wow_percent_rank_0to100(.data$trailing5_k_fp_allowed),
      attempt_pressure_rank_component =
        0.24 * qb_wow_percent_rank_0to100(.data$rolling3_fga) +
        0.16 * qb_wow_percent_rank_0to100(.data$rolling5_fga) +
        0.22 * qb_wow_percent_rank_0to100(.data$rolling3_xpa) +
        0.14 * qb_wow_percent_rank_0to100(.data$rolling5_xpa) +
        0.14 * qb_wow_percent_rank_0to100(.data$games_with_2plus_fga_recent_rate) +
        0.10 * qb_wow_percent_rank_0to100(.data$games_with_3plus_xpa_recent_rate),
      drive_env_rank_component =
        0.30 * dplyr::coalesce(.data$team_total_line_rank, 0) +
        0.15 * dplyr::coalesce(.data$rolling_team_total_line_rank, 0) +
        0.30 * dplyr::coalesce(.data$market_environment_component_0to100, 0) +
        0.25 * dplyr::coalesce(.data$scoring_environment_component_0to100, 0),
      k_weekly_board_score_legacy = (
        0.1742 * dplyr::coalesce(.data$weekly_projected_fp_rank_component, 0) +
          0.1014 * dplyr::coalesce(.data$k_in_season_omfg_score, 0) +
          0.2203 * dplyr::coalesce(.data$k_anchor_board_score, 0) +
          0.1442 * dplyr::coalesce(.data$production_component_0to100, 0) +
          0.3348 * dplyr::coalesce(.data$xpa_sd_rank_component, 0) +
          0.0101 * dplyr::coalesce(.data$xpm_rank_component, 0) +
          0.0091 * dplyr::coalesce(.data$scoring_environment_component_0to100, 0) +
          0.0060 * dplyr::coalesce(.data$volume_opportunity_component_0to100, 0)
      ) / (
        0.1742 * as.numeric(is.finite(.data$weekly_projected_fp_rank_component)) +
          0.1014 * as.numeric(is.finite(.data$k_in_season_omfg_score)) +
          0.2203 * as.numeric(is.finite(.data$k_anchor_board_score)) +
          0.1442 * as.numeric(is.finite(.data$production_component_0to100)) +
          0.3348 * as.numeric(is.finite(.data$xpa_sd_rank_component)) +
          0.0101 * as.numeric(is.finite(.data$xpm_rank_component)) +
          0.0091 * as.numeric(is.finite(.data$scoring_environment_component_0to100)) +
          0.0060 * as.numeric(is.finite(.data$volume_opportunity_component_0to100))
      ),
      k_wow_weight_profile = "legacy_board_v1",
      k_weekly_board_score = .data$k_weekly_board_score_legacy,
      k_wow_final_score = .data$k_weekly_board_score
    ) |>
    dplyr::ungroup() |>
    dplyr::group_by(.data$season, .data$week) |>
    dplyr::arrange(dplyr::desc(.data$k_wow_final_score), .data$player, .by_group = TRUE) |>
    dplyr::mutate(
      k_wow_rank = dplyr::row_number(),
      k_wow_legacy_rank = dplyr::min_rank(dplyr::desc(.data$k_weekly_board_score_legacy)),
      k_wow_tier = dplyr::case_when(
        .data$k_wow_rank <= 4 ~ "Tier 1",
        .data$k_wow_rank <= 8 ~ "Tier 2",
        .data$k_wow_rank <= 16 ~ "Tier 3",
        .data$k_wow_rank <= 24 ~ "Tier 4",
        TRUE ~ "Tier 5"
      )
    ) |>
    dplyr::ungroup() |>
    dplyr::arrange(.data$season, .data$week, .data$k_wow_rank)
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "k_wow_feature_overlay_2021_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_k_wow_board_summary <- function(k_wow_board, write_output = TRUE) {
  load_model_core_packages()
  
  week_metrics <- k_wow_board |>
    dplyr::group_by(.data$season, .data$week) |>
    dplyr::summarise(
      n = sum(is.finite(.data$k_wow_rank) & is.finite(.data$target_week_fp)),
      spearman = {
        keep <- is.finite(.data$k_wow_rank) & is.finite(.data$target_week_fp)
        if (sum(keep) > 1) {
          suppressWarnings(stats::cor(-.data$k_wow_rank[keep], .data$target_week_fp[keep], method = "spearman"))
        } else {
          NA_real_
        }
      },
      legacy_spearman = {
        keep <- is.finite(.data$k_wow_legacy_rank) & is.finite(.data$target_week_fp)
        if (sum(keep) > 1) {
          suppressWarnings(stats::cor(-.data$k_wow_legacy_rank[keep], .data$target_week_fp[keep], method = "spearman"))
        } else {
          NA_real_
        }
      },
      .groups = "drop"
    ) |>
    dplyr::mutate(
      predicts_week = .data$week + 1L,
      is_scorable = as.integer(.data$n > 1 & is.finite(.data$spearman)),
      spearman_gain_vs_legacy = .data$spearman - .data$legacy_spearman
    )
  
  summary_out <- week_metrics |>
    dplyr::group_by(.data$season) |>
    dplyr::summarise(
      weeks_total = dplyr::n(),
      weeks = sum(.data$is_scorable, na.rm = TRUE),
      scorable_weeks = sum(.data$is_scorable, na.rm = TRUE),
      avg_spearman = if (sum(.data$is_scorable, na.rm = TRUE) > 0) {
        mean(.data$spearman[.data$is_scorable == 1L], na.rm = TRUE)
      } else {
        NA_real_
      },
      avg_legacy_spearman = if (sum(.data$is_scorable, na.rm = TRUE) > 0) {
        mean(.data$legacy_spearman[.data$is_scorable == 1L], na.rm = TRUE)
      } else {
        NA_real_
      },
      avg_spearman_gain_vs_legacy = if (sum(.data$is_scorable, na.rm = TRUE) > 0) {
        mean(.data$spearman_gain_vs_legacy[.data$is_scorable == 1L], na.rm = TRUE)
      } else {
        NA_real_
      },
      median_spearman = if (sum(.data$is_scorable, na.rm = TRUE) > 0) {
        stats::median(.data$spearman[.data$is_scorable == 1L], na.rm = TRUE)
      } else {
        NA_real_
      },
      min_spearman = if (sum(.data$is_scorable, na.rm = TRUE) > 0) {
        min(.data$spearman[.data$is_scorable == 1L], na.rm = TRUE)
      } else {
        NA_real_
      },
      max_spearman = if (sum(.data$is_scorable, na.rm = TRUE) > 0) {
        max(.data$spearman[.data$is_scorable == 1L], na.rm = TRUE)
      } else {
        NA_real_
      },
      weeks_over_0 = sum(.data$spearman[.data$is_scorable == 1L] > 0, na.rm = TRUE),
      weeks_over_030 = sum(.data$spearman[.data$is_scorable == 1L] >= 0.30, na.rm = TRUE),
      weeks_over_040 = sum(.data$spearman[.data$is_scorable == 1L] >= 0.40, na.rm = TRUE),
      weeks_beating_legacy = sum(.data$spearman_gain_vs_legacy[.data$is_scorable == 1L] > 0, na.rm = TRUE),
      .groups = "drop"
    )
  
  out <- list(
    summary = summary_out,
    week_metrics = week_metrics
  )
  
  if (write_output) {
    dir.create(model_paths$wow_output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out$summary,
      file.path(model_paths$wow_output_dir, "k_wow_board_summary_2021_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    utils::write.csv(
      out$week_metrics,
      file.path(model_paths$wow_output_dir, "k_wow_board_metrics_2021_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_k_wow_final_export <- function(k_wow_board, write_output = TRUE) {
  load_model_core_packages()
  
  out <- k_wow_board |>
    dplyr::filter(is.finite(.data$k_wow_final_score)) |>
    dplyr::transmute(
      season = .data$season,
      week = .data$week,
      predicts_week = .data$week + 1L,
      rank = .data$k_wow_rank,
      legacy_rank = .data$k_wow_legacy_rank,
      tier = .data$k_wow_tier,
      player = .data$player,
      team = .data$team,
      opponent = .data$next_week_opponent,
      depth_team = .data$depth_team,
      report_status = .data$report_status,
      practice_status = .data$practice_status,
      projected_week_fp = .data$weekly_projected_fp,
      final_score = .data$k_wow_final_score,
      weekly_board_score = .data$k_weekly_board_score,
      legacy_weekly_board_score = .data$k_weekly_board_score_legacy,
      weight_profile = .data$k_wow_weight_profile,
      in_season_omfg = .data$k_in_season_omfg_score,
      anchor_fp = .data$k_wow_anchor_fp,
      sos_prior_score = .data$k_sos_prior_component_0to100,
      actual_week_fp = .data$target_week_fp,
      team_total_line = .data$team_total_line,
      team_spread_line = .data$team_spread_line,
      game_wind = .data$game_wind,
      roof = .data$roof,
      surface = .data$surface,
      production_component_0to100 = .data$production_component_0to100,
      volume_opportunity_component_0to100 = .data$volume_opportunity_component_0to100,
      accuracy_range_component_0to100 = .data$accuracy_range_component_0to100,
      team_opportunity_baseline_component_0to100 = .data$team_opportunity_baseline_component_0to100,
      team_fg_attempt_baseline_component_0to100 = .data$team_fg_attempt_baseline_component_0to100,
      player_fg_attempt_component_0to100 = .data$player_fg_attempt_component_0to100,
      long_range_reliability_component_0to100 = .data$long_range_reliability_component_0to100,
      fg_settle_environment_component_0to100 = .data$fg_settle_environment_component_0to100,
      scoring_environment_component_0to100 = .data$scoring_environment_component_0to100,
      market_environment_component_0to100 = .data$market_environment_component_0to100,
      weather_venue_component_0to100 = .data$weather_venue_component_0to100,
      player_expected_opportunity_fp = .data$player_expected_opportunity_fp,
      team_expected_opportunity_fp = .data$team_expected_opportunity_fp,
      team_rolling3_fga = .data$team_rolling3_fga,
      team_rolling5_fga = .data$team_rolling5_fga,
      team_season_to_date_fga_pg = .data$team_season_to_date_fga_pg,
      team_rolling3_xpa = .data$team_rolling3_xpa,
      team_rolling3_fg_settle_rate = .data$team_rolling3_fg_settle_rate,
      team_rolling5_fg_settle_rate = .data$team_rolling5_fg_settle_rate,
      xpa_sd_rank_component = .data$xpa_sd_rank_component,
      xpm_rank_component = .data$xpm_rank_component,
      expected_opportunity_rank = .data$expected_opportunity_rank,
      opp_pressure_rank_component = .data$opp_pressure_rank_component,
      attempt_pressure_rank_component = .data$attempt_pressure_rank_component,
      drive_env_rank_component = .data$drive_env_rank_component,
      matchup_ease_component_0to100 = .data$matchup_ease_component_0to100,
      availability_component_0to100 = .data$availability_component_0to100,
      ceiling_opportunity_component_0to100 = .data$ceiling_opportunity_component_0to100,
      momentum_component_0to100 = .data$momentum_component_0to100
    ) |>
    dplyr::arrange(.data$season, .data$week, .data$rank)
  
  if (write_output) {
    dir.create(model_paths$wow_output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(model_paths$wow_output_dir, "k_wow_final_export_2021_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

run_k_wow_board_rebuild <- function(write_output = TRUE) {
  load_model_core_packages()
  
  k_wow_board <- build_k_wow_feature_overlay_table(write_output = write_output)
  k_wow_board_summary <- build_k_wow_board_summary(k_wow_board, write_output = write_output)
  k_wow_final_export <- build_k_wow_final_export(k_wow_board, write_output = write_output)
  
  list(
    board = k_wow_board,
    board_summary = k_wow_board_summary,
    final_export = k_wow_final_export
  )
}

build_core_wow_lock_summary <- function(write_output = FALSE, output_dir = model_paths$wow_output_dir) {
  out <- data.frame(
    position = c("QB", "RB", "WR", "TE", "K", "DST"),
    production_mode = rep("board_rebuild_current", 6),
    rebuild_runner = c(
      "run_qb_wow_board_rebuild()",
      "run_rb_wow_board_rebuild()",
      "run_wr_wow_board_rebuild()",
      "run_te_wow_board_rebuild()",
      "run_k_wow_board_rebuild()",
      "run_dst_wow_board_rebuild()"
    ),
    final_export_path = c(
      file.path(output_dir, "qb_wow_final_export_2021_2025.csv"),
      file.path(output_dir, "rb_wow_final_export_2021_2025.csv"),
      file.path(output_dir, "wr_wow_final_export_2021_2025.csv"),
      file.path(output_dir, "te_wow_final_export_2021_2025.csv"),
      file.path(output_dir, "k_wow_final_export_2021_2025.csv"),
      file.path(output_dir, "dst_wow_final_export_2021_2025.csv")
    ),
    board_summary_path = c(
      file.path(output_dir, "qb_wow_board_summary_2021_2025.csv"),
      file.path(output_dir, "rb_wow_board_summary_2021_2025.csv"),
      file.path(output_dir, "wr_wow_board_summary_2021_2025.csv"),
      file.path(output_dir, "te_wow_board_summary_2021_2025.csv"),
      file.path(output_dir, "k_wow_board_summary_2021_2025.csv"),
      file.path(output_dir, "dst_wow_board_summary_2021_2025.csv")
    ),
    board_metrics_path = c(
      file.path(output_dir, "qb_wow_board_metrics_2021_2025.csv"),
      file.path(output_dir, "rb_wow_board_metrics_2021_2025.csv"),
      file.path(output_dir, "wr_wow_board_metrics_2021_2025.csv"),
      file.path(output_dir, "te_wow_board_metrics_2021_2025.csv"),
      file.path(output_dir, "k_wow_board_metrics_2021_2025.csv"),
      file.path(output_dir, "dst_wow_board_metrics_2021_2025.csv")
    ),
    stringsAsFactors = FALSE
  )
  
  out$final_export_exists <- file.exists(out$final_export_path)
  out$board_summary_exists <- file.exists(out$board_summary_path)
  out$board_metrics_exists <- file.exists(out$board_metrics_path)
  
  if (write_output) {
    utils::write.csv(
      out,
      file.path(output_dir, "core_wow_lock_summary_2021_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_core_wow_output_manifest <- function(write_output = FALSE, output_dir = model_paths$wow_output_dir) {
  out <- data.frame(
    position = c(
      "QB", "QB", "QB", "QB", "QB",
      "RB", "RB", "RB", "RB", "RB",
      "WR", "WR", "WR", "WR", "WR", "WR",
      "TE", "TE", "TE", "TE", "TE", "TE",
      "K", "K", "K", "K", "K",
      "DST", "DST", "DST", "DST", "DST"
    ),
    artifact = c(
      "weekly_base", "weekly_feature_base", "board_metrics", "board_summary", "final_export",
      "weekly_base", "weekly_feature_base", "board_metrics", "board_summary", "final_export",
      "weekly_base", "weekly_feature_base", "team_context_base", "board_metrics", "board_summary", "final_export",
      "weekly_base", "weekly_feature_base", "team_context_base", "board_metrics", "board_summary", "final_export",
      "weekly_base", "weekly_feature_base", "board_metrics", "board_summary", "final_export",
      "weekly_base", "weekly_feature_base", "board_metrics", "board_summary", "final_export"
    ),
    output_path = c(
      file.path(output_dir, "qb_wow_weekly_base_2021_2025.csv"),
      file.path(output_dir, "qb_weekly_feature_base_2021_2025_regular.csv"),
      file.path(output_dir, "qb_wow_board_metrics_2021_2025.csv"),
      file.path(output_dir, "qb_wow_board_summary_2021_2025.csv"),
      file.path(output_dir, "qb_wow_final_export_2021_2025.csv"),
      file.path(output_dir, "rb_wow_weekly_base_2021_2025.csv"),
      file.path(output_dir, "rb_weekly_feature_base_2021_2025_regular.csv"),
      file.path(output_dir, "rb_wow_board_metrics_2021_2025.csv"),
      file.path(output_dir, "rb_wow_board_summary_2021_2025.csv"),
      file.path(output_dir, "rb_wow_final_export_2021_2025.csv"),
      file.path(output_dir, "wr_wow_weekly_base_2021_2025.csv"),
      file.path(output_dir, "wr_weekly_feature_base_2021_2025_regular.csv"),
      file.path(output_dir, "wr_team_context_base_2021_2025.csv"),
      file.path(output_dir, "wr_wow_board_metrics_2021_2025.csv"),
      file.path(output_dir, "wr_wow_board_summary_2021_2025.csv"),
      file.path(output_dir, "wr_wow_final_export_2021_2025.csv"),
      file.path(output_dir, "te_wow_weekly_base_2021_2025.csv"),
      file.path(output_dir, "te_weekly_feature_base_2021_2025_regular.csv"),
      file.path(output_dir, "te_team_context_base_2021_2025.csv"),
      file.path(output_dir, "te_wow_board_metrics_2021_2025.csv"),
      file.path(output_dir, "te_wow_board_summary_2021_2025.csv"),
      file.path(output_dir, "te_wow_final_export_2021_2025.csv"),
      file.path(output_dir, "k_wow_weekly_base_2021_2025.csv"),
      file.path(output_dir, "k_weekly_feature_base_2021_2025_regular.csv"),
      file.path(output_dir, "k_wow_board_metrics_2021_2025.csv"),
      file.path(output_dir, "k_wow_board_summary_2021_2025.csv"),
      file.path(output_dir, "k_wow_final_export_2021_2025.csv"),
      file.path(output_dir, "dst_wow_weekly_base_2021_2025.csv"),
      file.path(output_dir, "dst_weekly_feature_base_2021_2025_regular.csv"),
      file.path(output_dir, "dst_wow_board_metrics_2021_2025.csv"),
      file.path(output_dir, "dst_wow_board_summary_2021_2025.csv"),
      file.path(output_dir, "dst_wow_final_export_2021_2025.csv")
    ),
    stringsAsFactors = FALSE
  )
  
  out$exists <- file.exists(out$output_path)
  
  if (write_output) {
    utils::write.csv(
      out,
      file.path(output_dir, "core_wow_output_manifest_2021_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}


message("Week-over-week model script loaded.")
message("Available builders: build_qb_wow_inputs(), build_rb_wow_inputs(), build_wr_wow_inputs(), build_te_wow_inputs(), build_k_wow_inputs(), build_dst_wow_feature_base()")
message("QB runner: run_qb_wow_pipeline()")
message("RB runner: run_rb_wow_pipeline()")
message("WR runner: run_wr_wow_pipeline()")
message("TE runner: run_te_wow_pipeline()")
message("K runner: run_k_wow_pipeline()")
message("QB WOW board rebuild runner: run_qb_wow_board_rebuild()")
message("RB WOW board rebuild runner: run_rb_wow_board_rebuild()")
message("WR WOW board rebuild runner: run_wr_wow_board_rebuild()")
message("TE WOW board rebuild runner: run_te_wow_board_rebuild()")
message("K WOW board rebuild runner: run_k_wow_board_rebuild()")
message("DST WOW board rebuild runner: run_dst_wow_board_rebuild()")
message("Core WOW helpers: build_core_wow_lock_summary(), build_core_wow_output_manifest()")

# -----------------------------------------------------------------------------
# DST week-over-week model
# -----------------------------------------------------------------------------
# DST is ranked by the defense that will play the next game.  Recent fantasy
# production, playmaking, prevention, opponent environment, and stability are
# calculated using information available before the predicted week.

dst_wow_pick_num <- function(df, choices, default = NA_real_) {
  out <- rep(NA_real_, nrow(df))
  for (nm in choices[choices %in% names(df)]) {
    candidate <- suppressWarnings(as.numeric(df[[nm]]))
    out <- dplyr::coalesce(out, candidate)
  }
  out[is.na(out)] <- default
  out
}

dst_wow_pick_chr <- function(df, choices, default = NA_character_) {
  out <- rep(default, nrow(df))
  for (nm in choices[choices %in% names(df)]) {
    candidate <- trimws(as.character(df[[nm]]))
    candidate[candidate %in% c("", "NA", "NaN")] <- NA_character_
    out <- dplyr::coalesce(out, candidate)
  }
  out
}

dst_wow_normalize_team <- function(x) {
  x <- toupper(trimws(as.character(x)))
  dplyr::recode(
    x,
    LA = "LAR", CLV = "CLE", HST = "HOU", BLT = "BAL", ARZ = "ARI",
    JAC = "JAX", SD = "LAC", OAK = "LV", STL = "LAR", .default = x
  )
}

dst_wow_rank_0to100 <- function(x, higher_is_better = TRUE) {
  x <- suppressWarnings(as.numeric(x))
  if (!higher_is_better) x <- -x
  out <- rep(50, length(x))
  ok <- is.finite(x)
  n_ok <- sum(ok)
  if (n_ok > 1) out[ok] <- 100 * (rank(x[ok], ties.method = "average") - 1) / (n_ok - 1)
  if (n_ok == 1) out[ok] <- 50
  out[!is.finite(x)] <- NA_real_
  out
}

dst_wow_roll_mean <- function(x, window = 3L) {
  x <- suppressWarnings(as.numeric(x))
  vapply(seq_along(x), function(i) {
    values <- x[max(1, i - window + 1):i]
    if (!any(is.finite(values))) NA_real_ else mean(values, na.rm = TRUE)
  }, numeric(1))
}

dst_wow_roll_sd <- function(x, window = 4L) {
  x <- suppressWarnings(as.numeric(x))
  vapply(seq_along(x), function(i) {
    values <- x[max(1, i - window + 1):i]
    values <- values[is.finite(values)]
    if (length(values) < 2) NA_real_ else stats::sd(values)
  }, numeric(1))
}

dst_wow_safe_cor <- function(x, y) {
  ok <- is.finite(x) & is.finite(y)
  if (sum(ok) < 3 || length(unique(x[ok])) < 2 || length(unique(y[ok])) < 2) return(NA_real_)
  suppressWarnings(stats::cor(x[ok], y[ok], method = "spearman"))
}

build_dst_wow_clean_weekly_master <- function(write_output = FALSE, output_dir = model_paths$foundation_output_dir) {
  load_model_core_packages()
  raw <- load_all_positions_hybrid() |>
    dplyr::filter(as.character(.data$POS) == "DST")
  
  out <- data.frame(
    season = as.integer(dst_wow_pick_num(raw, c("SEA", "season"))),
    week = as.integer(dst_wow_pick_num(raw, c("WK", "week"))),
    player = dst_wow_pick_chr(raw, c("Player", "player_name", "Name")),
    team = dst_wow_normalize_team(dst_wow_pick_chr(raw, c("TM_DEF", "defense_team", "team"))),
    opponent = dst_wow_normalize_team(dst_wow_pick_chr(raw, c("TM", "opponent_team", "opponent"))),
    position = "DST",
    dst_fantasy_points = dst_wow_pick_num(raw, c("DST_ftpts", "DST_Fantasy_Target", "fantasyPts")),
    sacks = dst_wow_pick_num(raw, c("SACK_def_team", "SACK_def", "sacks", "SACK"), 0),
    interceptions = dst_wow_pick_num(raw, c("INT_def_team", "INT_def", "interceptions", "INT"), 0),
    fumbles = dst_wow_pick_num(raw, c("FUM_def_team", "FUM_def", "fumbles", "FUM"), 0),
    safeties = dst_wow_pick_num(raw, c("safety_def_team", "safety_def", "safeties", "SAF"), 0),
    defensive_tds = dst_wow_pick_num(raw, c("Def_TDs_team", "Def_TDs", "TD_def"), 0),
    kicking_tds = dst_wow_pick_num(raw, c("K_TDs_team", "K_TDs"), 0),
    punting_tds = dst_wow_pick_num(raw, c("P_TDs_team", "P_TDs"), 0),
    points_allowed = dst_wow_pick_num(raw, c(
      "PTs_allw_team", "PTs_allw", "avg_PTs_allw", "avg_total_PTs_allw",
      "avg_DST_Proj_PtsAllowed", "DST_Proj_PtsAllowed", "points_allowed"
    )),
    opponent_sacks_allowed = dst_wow_pick_num(raw, c("SACK_off", "sack_allw_off", "sack_allw_pass_off"), 0),
    opponent_interceptions = dst_wow_pick_num(raw, c("INT_off", "interceptions_off"), 0),
    opponent_fumbles_lost = dst_wow_pick_num(raw, c("fumble_lost_pass_off", "fumble_lost_rush_off", "FUM_off"), 0),
    opponent_points_scored = dst_wow_pick_num(raw, c("Pts_scr", "points_scored", "total_points_off")),
    opponent_total_line = dst_wow_pick_num(raw, c("G_total_off", "total_line_off", "total_off")),
    opponent_spread = dst_wow_pick_num(raw, c("spread_line_off", "spread_line")),
    game_day = dst_wow_pick_chr(raw, c("gameday_off", "gameday")),
    stringsAsFactors = FALSE
  ) |>
    dplyr::mutate(
      points_allowed = dplyr::coalesce(points_allowed, opponent_points_scored),
      turnovers = dplyr::coalesce(interceptions, 0) + dplyr::coalesce(fumbles, 0),
      opponent_turnovers = dplyr::coalesce(opponent_interceptions, 0) +
        dplyr::coalesce(opponent_fumbles_lost, 0),
      big_plays = dplyr::coalesce(sacks, 0) +
        2 * dplyr::coalesce(interceptions, 0) +
        2 * dplyr::coalesce(fumbles, 0) +
        2 * dplyr::coalesce(safeties, 0) +
        6 * (dplyr::coalesce(defensive_tds, 0) +
               dplyr::coalesce(kicking_tds, 0) +
               dplyr::coalesce(punting_tds, 0))
    ) |>
    dplyr::filter(season >= 2021, season <= 2025, !is.na(week), week <= 18, !is.na(team))
  
  # Repair historical Cartesian products from non-unique opponent-kicker joins.
  dst_source_corrections <- data.frame(
    season = c(2021L, 2022L, 2024L, 2024L, 2025L),
    week = c(5L, 5L, 5L, 17L, 3L),
    team = c("MIA", "CAR", "ARI", "PIT", "KC"),
    corrected_points_allowed = c(45, 30, 14, 29, 9),
    corrected_dst_fantasy_points = c(-1, 3, 9, -1, 9),
    stringsAsFactors = FALSE
  )
  
  out <- out |>
    dplyr::left_join(dst_source_corrections, by = c("season", "week", "team"), relationship = "many-to-one") |>
    dplyr::mutate(
      points_allowed = dplyr::coalesce(.data$corrected_points_allowed, .data$points_allowed),
      opponent_points_scored = dplyr::coalesce(.data$corrected_points_allowed, .data$opponent_points_scored),
      dst_fantasy_points = dplyr::coalesce(.data$corrected_dst_fantasy_points, .data$dst_fantasy_points)
    ) |>
    dplyr::select(-corrected_points_allowed, -corrected_dst_fantasy_points)
  
  conflict_columns <- c(
    "player", "opponent", "dst_fantasy_points", "sacks", "interceptions", "fumbles",
    "safeties", "defensive_tds", "kicking_tds", "punting_tds", "points_allowed",
    "opponent_sacks_allowed", "opponent_interceptions", "opponent_fumbles_lost",
    "opponent_points_scored"
  )
  conflicting_keys <- out |>
    dplyr::group_by(season, week, team) |>
    dplyr::summarise(
      dplyr::across(dplyr::all_of(conflict_columns), ~ dplyr::n_distinct(.x[!is.na(.x)])),
      .groups = "drop"
    ) |>
    dplyr::filter(dplyr::if_any(dplyr::all_of(conflict_columns), ~ .x > 1))
  if (nrow(conflicting_keys) > 0) {
    stop(
      "DST WOW source has unresolved conflicting team-week rows; repair the upstream join before modeling.",
      call. = FALSE
    )
  }
  
  out <- out |>
    dplyr::mutate(
      source_completeness = rowSums(!is.na(dplyr::pick(dplyr::all_of(conflict_columns))))
    ) |>
    dplyr::arrange(season, week, team, dplyr::desc(source_completeness), player, opponent) |>
    dplyr::distinct(season, week, team, .keep_all = TRUE) |>
    dplyr::select(-source_completeness)
  
  duplicate_keys <- out |>
    dplyr::count(season, week, team) |>
    dplyr::filter(n > 1)
  if (nrow(duplicate_keys) > 0) {
    stop("DST WOW clean weekly master contains duplicated team-week keys after cleanup.", call. = FALSE)
  }
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(out, file.path(output_dir, "dst_clean_weekly_master_2021_2025_regular.csv"), row.names = FALSE, na = "")
  }
  out
}

build_dst_wow_feature_base <- function(dst_weekly = build_dst_wow_clean_weekly_master()) {
  dst_weekly |>
    dplyr::group_by(season, team) |>
    dplyr::arrange(week, .by_group = TRUE) |>
    dplyr::mutate(
      feature_week = week,
      predicts_week = week + 1L,
      target_week_fp = dplyr::if_else(
        dplyr::lead(week) == week + 1L,
        dplyr::lead(dst_fantasy_points),
        NA_real_
      ),
      target_week = dplyr::if_else(
        dplyr::lead(week) == week + 1L,
        dplyr::lead(week),
        NA_integer_
      ),
      recent_fp_3 = dst_wow_roll_mean(dst_fantasy_points, 3L),
      recent_fp_5 = dst_wow_roll_mean(dst_fantasy_points, 5L),
      recent_playmaking_3 = dst_wow_roll_mean(big_plays, 3L),
      recent_turnovers_3 = dst_wow_roll_mean(turnovers, 3L),
      recent_points_allowed_3 = dst_wow_roll_mean(points_allowed, 3L),
      recent_opponent_sacks_allowed_3 = dst_wow_roll_mean(opponent_sacks_allowed, 3L),
      recent_opponent_turnovers_3 = dst_wow_roll_mean(opponent_turnovers, 3L),
      recent_opponent_points_scored_3 = dst_wow_roll_mean(opponent_points_scored, 3L),
      recent_fp_sd_4 = dst_wow_roll_sd(dst_fantasy_points, 4L)
    ) |>
    dplyr::ungroup() |>
    dplyr::filter(feature_week <= 17) |>
    dplyr::mutate(is_scorable = is.finite(target_week_fp)) |>
    dplyr::group_by(season, predicts_week) |>
    dplyr::mutate(
      recent_form_component_0to100 = dst_wow_rank_0to100(recent_fp_3),
      playmaking_component_0to100 = dst_wow_rank_0to100(recent_playmaking_3 + recent_turnovers_3),
      prevention_component_0to100 = dst_wow_rank_0to100(recent_points_allowed_3, higher_is_better = FALSE),
      matchup_component_0to100 = dst_wow_rank_0to100(opponent_total_line, higher_is_better = FALSE),
      opponent_environment_component_0to100 = rowMeans(cbind(
        dst_wow_rank_0to100(recent_opponent_sacks_allowed_3),
        dst_wow_rank_0to100(recent_opponent_turnovers_3),
        dst_wow_rank_0to100(recent_opponent_points_scored_3, higher_is_better = FALSE)
      ), na.rm = TRUE),
      stability_component_0to100 = dst_wow_rank_0to100(recent_fp_sd_4, higher_is_better = FALSE),
      dst_weekly_board_score =
        .30 * dplyr::coalesce(recent_form_component_0to100, 50) +
        .20 * dplyr::coalesce(playmaking_component_0to100, 50) +
        .15 * dplyr::coalesce(prevention_component_0to100, 50) +
        .15 * dplyr::coalesce(matchup_component_0to100, 50) +
        .10 * dplyr::coalesce(stability_component_0to100, 50) +
        .10 * dplyr::coalesce(opponent_environment_component_0to100, 50),
      dst_legacy_board_score = recent_form_component_0to100
    ) |>
    dplyr::mutate(
      rank = dplyr::dense_rank(dplyr::desc(dst_weekly_board_score)),
      legacy_rank = dplyr::dense_rank(dplyr::desc(dst_legacy_board_score)),
      tier = dplyr::case_when(
        rank <= 5 ~ "Top 5",
        rank <= 12 ~ "Top 12",
        rank <= 24 ~ "Top 24",
        TRUE ~ "Field"
      )
    ) |>
    dplyr::ungroup()
}

build_dst_wow_board_summary <- function(board, write_output = FALSE, output_dir = model_paths$wow_output_dir) {
  week_metrics <- board |>
    dplyr::group_by(season, feature_week, predicts_week) |>
    dplyr::summarise(
      n = sum(is.finite(dst_weekly_board_score) & is.finite(target_week_fp)),
      spearman = dst_wow_safe_cor(dst_weekly_board_score, target_week_fp),
      legacy_spearman = dst_wow_safe_cor(dst_legacy_board_score, target_week_fp),
      spearman_gain_vs_legacy = spearman - legacy_spearman,
      is_scorable = n > 0,
      .groups = "drop"
    )
  
  summary <- week_metrics |>
    dplyr::filter(is_scorable, is.finite(spearman)) |>
    dplyr::group_by(season) |>
    dplyr::summarise(
      weeks_total = 18L,
      weeks = dplyr::n_distinct(feature_week),
      scorable_weeks = dplyr::n(),
      avg_spearman = mean(spearman),
      median_spearman = stats::median(spearman),
      min_spearman = min(spearman),
      max_spearman = max(spearman),
      weeks_over_0 = sum(spearman > 0),
      weeks_over_030 = sum(spearman > .30),
      weeks_over_040 = sum(spearman > .40),
      avg_legacy_spearman = mean(legacy_spearman, na.rm = TRUE),
      avg_spearman_gain_vs_legacy = mean(spearman_gain_vs_legacy, na.rm = TRUE),
      .groups = "drop"
    )
  
  out <- list(summary = summary, week_metrics = week_metrics)
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(week_metrics, file.path(output_dir, "dst_wow_board_metrics_2021_2025.csv"), row.names = FALSE, na = "")
    utils::write.csv(summary, file.path(output_dir, "dst_wow_board_summary_2021_2025.csv"), row.names = FALSE, na = "")
  }
  out
}

run_dst_wow_board_rebuild <- function(write_output = TRUE) {
  load_model_core_packages()
  weekly <- build_dst_wow_clean_weekly_master(write_output = write_output)
  feature_base <- build_dst_wow_feature_base(weekly)
  board_summary <- build_dst_wow_board_summary(feature_base, write_output = write_output)
  final_export <- feature_base |>
    dplyr::filter(feature_week <= 17) |>
    dplyr::select(
      season, feature_week, predicts_week, rank, legacy_rank, tier,
      player, team, opponent, game_day, dst_weekly_board_score,
      recent_form_component_0to100, playmaking_component_0to100,
      prevention_component_0to100, matchup_component_0to100,
      opponent_environment_component_0to100, stability_component_0to100,
      recent_opponent_sacks_allowed_3, recent_opponent_turnovers_3,
      recent_opponent_points_scored_3, target_week_fp, is_scorable
    ) |>
    dplyr::arrange(season, predicts_week, rank)
  
  if (write_output) {
    dir.create(model_paths$wow_output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(weekly, file.path(model_paths$wow_output_dir, "dst_wow_weekly_base_2021_2025.csv"), row.names = FALSE, na = "")
    utils::write.csv(feature_base, file.path(model_paths$wow_output_dir, "dst_weekly_feature_base_2021_2025_regular.csv"), row.names = FALSE, na = "")
    utils::write.csv(final_export, file.path(model_paths$wow_output_dir, "dst_wow_final_export_2021_2025.csv"), row.names = FALSE, na = "")
  }
  
  result <- list(
    weekly_base = weekly,
    feature_base = feature_base,
    board = feature_base,
    board_summary = board_summary,
    final_export = final_export
  )
  assign("dst_wow_rebuilt", result, envir = .GlobalEnv)
  result
}

dst_wow_weight_candidates <- function() {
  list(
    legacy_recent_form_100 = c(
      recent_form = 1, playmaking = 0, prevention = 0,
      matchup = 0, stability = 0, opponent_environment = 0
    ),
    current_prevention_matchup_30_20_15_15_10_10 = c(
      recent_form = .30, playmaking = .20, prevention = .15,
      matchup = .15, stability = .10, opponent_environment = .10
    ),
    prevention_heavy_25_20_25_10_5_15 = c(
      recent_form = .25, playmaking = .20, prevention = .25,
      matchup = .10, stability = .05, opponent_environment = .15
    ),
    matchup_heavy_25_15_15_25_10_10 = c(
      recent_form = .25, playmaking = .15, prevention = .15,
      matchup = .25, stability = .10, opponent_environment = .10
    ),
    stability_heavy_30_20_15_10_20_5 = c(
      recent_form = .30, playmaking = .20, prevention = .15,
      matchup = .10, stability = .20, opponent_environment = .05
    )
  )
}

dst_wow_apply_weights <- function(df, weights) {
  component <- function(name) {
    if (name %in% names(df)) {
      ifelse(is.finite(df[[name]]), df[[name]], 50)
    } else {
      rep(50, nrow(df))
    }
  }
  
  as.numeric(
    weights[["recent_form"]] * component("recent_form_component_0to100") +
      weights[["playmaking"]] * component("playmaking_component_0to100") +
      weights[["prevention"]] * component("prevention_component_0to100") +
      weights[["matchup"]] * component("matchup_component_0to100") +
      weights[["stability"]] * component("stability_component_0to100") +
      weights[["opponent_environment"]] * component("opponent_environment_component_0to100")
  )
}

dst_wow_holdout_metric_rows <- function(feature_base, candidates) {
  do.call(rbind, lapply(names(candidates), function(candidate) {
    score <- dst_wow_apply_weights(feature_base, candidates[[candidate]])
    data.frame(
      model = candidate,
      season = feature_base$season,
      feature_week = feature_base$feature_week,
      predicts_week = feature_base$predicts_week,
      score = score,
      target_week_fp = feature_base$target_week_fp,
      legacy_score = feature_base$dst_legacy_board_score,
      stringsAsFactors = FALSE
    ) |>
      dplyr::group_by(season, feature_week, predicts_week) |>
      dplyr::summarise(
        n = sum(is.finite(score) & is.finite(target_week_fp)),
        spearman = dst_wow_safe_cor(score, target_week_fp),
        legacy_spearman = dst_wow_safe_cor(legacy_score, target_week_fp),
        .groups = "drop"
      ) |>
      dplyr::mutate(
        model = candidate,
        spearman_gain_vs_legacy = spearman - legacy_spearman,
        .before = 1
      )
  }))
}

run_dst_wow_holdout_pipeline <- function(test_season = 2025L, write_output = TRUE) {
  load_model_core_packages()
  weekly <- build_dst_wow_clean_weekly_master(write_output = write_output)
  feature_base <- build_dst_wow_feature_base(weekly)
  candidates <- dst_wow_weight_candidates()
  metric_rows <- dst_wow_holdout_metric_rows(feature_base, candidates)
  
  training_summary <- metric_rows |>
    dplyr::filter(season < test_season, is.finite(spearman)) |>
    dplyr::group_by(model) |>
    dplyr::summarise(
      train_seasons = paste(sort(unique(season)), collapse = ","),
      scorable_weeks = dplyr::n(),
      avg_spearman = mean(spearman, na.rm = TRUE),
      median_spearman = stats::median(spearman, na.rm = TRUE),
      min_spearman = min(spearman, na.rm = TRUE),
      max_spearman = max(spearman, na.rm = TRUE),
      weeks_over_0 = sum(spearman > 0),
      weeks_over_030 = sum(spearman > .30),
      weeks_over_040 = sum(spearman > .40),
      avg_legacy_spearman = mean(legacy_spearman, na.rm = TRUE),
      avg_spearman_gain_vs_legacy = mean(spearman_gain_vs_legacy, na.rm = TRUE),
      .groups = "drop"
    ) |>
    dplyr::arrange(dplyr::desc(avg_spearman), dplyr::desc(avg_spearman_gain_vs_legacy))
  
  production_candidate <- training_summary$model[[1]]
  test_metrics <- metric_rows |>
    dplyr::filter(season == test_season) |>
    dplyr::arrange(model, predicts_week)
  
  test_summary <- test_metrics |>
    dplyr::filter(is.finite(spearman)) |>
    dplyr::group_by(model) |>
    dplyr::summarise(
      test_season = test_season,
      scorable_weeks = dplyr::n(),
      avg_spearman = mean(spearman, na.rm = TRUE),
      median_spearman = stats::median(spearman, na.rm = TRUE),
      min_spearman = min(spearman, na.rm = TRUE),
      max_spearman = max(spearman, na.rm = TRUE),
      weeks_over_0 = sum(spearman > 0),
      weeks_over_030 = sum(spearman > .30),
      weeks_over_040 = sum(spearman > .40),
      avg_legacy_spearman = mean(legacy_spearman, na.rm = TRUE),
      avg_spearman_gain_vs_legacy = mean(spearman_gain_vs_legacy, na.rm = TRUE),
      .groups = "drop"
    ) |>
    dplyr::arrange(dplyr::desc(avg_spearman))
  
  holdout_board <- feature_base |>
    dplyr::filter(season == test_season)
  holdout_board$dst_wow_holdout_weight_profile <- production_candidate
  holdout_board$dst_wow_holdout_score <- dst_wow_apply_weights(
    holdout_board,
    candidates[[production_candidate]]
  )
  holdout_board <- holdout_board |>
    dplyr::group_by(season, predicts_week) |>
    dplyr::mutate(
      dst_wow_holdout_rank = dplyr::dense_rank(dplyr::desc(dst_wow_holdout_score)),
      dst_wow_holdout_tier = dplyr::case_when(
        dst_wow_holdout_rank <= 5 ~ "Top 5",
        dst_wow_holdout_rank <= 12 ~ "Top 12",
        dst_wow_holdout_rank <= 24 ~ "Top 24",
        TRUE ~ "Field"
      )
    ) |>
    dplyr::ungroup()
  
  final_export <- holdout_board |>
    dplyr::select(
      season, feature_week, predicts_week,
      dst_wow_holdout_rank, legacy_rank, dst_wow_holdout_tier,
      dst_wow_holdout_weight_profile, player, team, opponent, game_day,
      dst_wow_holdout_score, dst_weekly_board_score, dst_legacy_board_score,
      recent_form_component_0to100, playmaking_component_0to100,
      prevention_component_0to100, matchup_component_0to100,
      opponent_environment_component_0to100, stability_component_0to100,
      target_week_fp, is_scorable
    ) |>
    dplyr::arrange(season, predicts_week, dst_wow_holdout_rank)
  
  if (write_output) {
    dir.create(model_paths$wow_output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      training_summary,
      file.path(model_paths$wow_output_dir, paste0("dst_wow_holdout_tuning_through_", test_season - 1L, ".csv")),
      row.names = FALSE,
      na = ""
    )
    utils::write.csv(
      test_metrics,
      file.path(model_paths$wow_output_dir, paste0("dst_wow_holdout_test_metrics_", test_season, ".csv")),
      row.names = FALSE,
      na = ""
    )
    utils::write.csv(
      test_summary,
      file.path(model_paths$wow_output_dir, paste0("dst_wow_holdout_test_summary_", test_season, ".csv")),
      row.names = FALSE,
      na = ""
    )
    utils::write.csv(
      final_export,
      file.path(model_paths$wow_output_dir, paste0("dst_wow_holdout_final_export_", test_season, ".csv")),
      row.names = FALSE,
      na = ""
    )
  }
  
  result <- list(
    dst_wow_holdout_weekly_base = weekly,
    dst_wow_holdout_feature_base = feature_base,
    dst_wow_holdout_training_summary = training_summary,
    dst_wow_holdout_test_metrics = test_metrics,
    dst_wow_holdout_test_summary = test_summary,
    dst_wow_holdout_production_candidate = production_candidate,
    dst_wow_holdout_final_export = final_export
  )
  for (nm in names(result)) assign(nm, result[[nm]], envir = .GlobalEnv)
  result
}

run_dst_wow_walk_forward_pipeline <- function(
    test_seasons = c(2022L, 2023L, 2024L, 2025L),
    write_output = TRUE
) {
  load_model_core_packages()
  weekly <- build_dst_wow_clean_weekly_master(write_output = write_output)
  feature_base <- build_dst_wow_feature_base(weekly)
  candidates <- dst_wow_weight_candidates()
  test_seasons <- sort(unique(as.integer(test_seasons)))
  
  metric_rows <- dst_wow_holdout_metric_rows(feature_base, candidates)
  safe_mean <- function(x) {
    if (any(is.finite(x))) mean(x, na.rm = TRUE) else NA_real_
  }
  safe_min <- function(x) {
    if (any(is.finite(x))) min(x, na.rm = TRUE) else NA_real_
  }
  
  fold_tuning <- list()
  fold_summary <- list()
  fold_test_metrics <- list()
  fold_boards <- list()
  
  for (test_season in test_seasons) {
    training_summary <- metric_rows |>
      dplyr::filter(season < test_season, is.finite(spearman)) |>
      dplyr::group_by(model) |>
      dplyr::summarise(
        train_seasons = paste(sort(unique(season)), collapse = ","),
        scorable_weeks = dplyr::n(),
        avg_spearman = safe_mean(spearman),
        median_spearman = stats::median(spearman, na.rm = TRUE),
        min_spearman = safe_min(spearman),
        max_spearman = max(spearman, na.rm = TRUE),
        weeks_over_0 = sum(spearman > 0),
        weeks_over_030 = sum(spearman > .30),
        weeks_over_040 = sum(spearman > .40),
        avg_legacy_spearman = safe_mean(legacy_spearman),
        avg_spearman_gain_vs_legacy = safe_mean(spearman_gain_vs_legacy),
        .groups = "drop"
      ) |>
      dplyr::mutate(test_season = test_season, .before = 1) |>
      dplyr::arrange(dplyr::desc(avg_spearman), dplyr::desc(avg_spearman_gain_vs_legacy))
    
    production_candidate <- training_summary$model[[1]]
    test_metrics <- metric_rows |>
      dplyr::filter(season == test_season) |>
      dplyr::mutate(
        test_season = test_season,
        selected_model = model == production_candidate,
        selected_profile = production_candidate,
        .before = 1
      )
    selected_test_metrics <- test_metrics |>
      dplyr::filter(selected_model, is.finite(spearman))
    
    fold_tuning[[as.character(test_season)]] <- training_summary
    fold_test_metrics[[as.character(test_season)]] <- test_metrics
    fold_summary[[as.character(test_season)]] <- data.frame(
      test_season = test_season,
      train_seasons = training_summary$train_seasons[[1]],
      selected_model = production_candidate,
      scorable_weeks = nrow(selected_test_metrics),
      avg_spearman = safe_mean(selected_test_metrics$spearman),
      median_spearman = stats::median(selected_test_metrics$spearman, na.rm = TRUE),
      min_spearman = safe_min(selected_test_metrics$spearman),
      max_spearman = max(selected_test_metrics$spearman, na.rm = TRUE),
      avg_legacy_spearman = safe_mean(selected_test_metrics$legacy_spearman),
      avg_spearman_gain_vs_legacy = safe_mean(selected_test_metrics$spearman_gain_vs_legacy),
      stringsAsFactors = FALSE
    )
    
    board <- feature_base |>
      dplyr::filter(season == test_season)
    board$dst_wow_walk_forward_weight_profile <- production_candidate
    board$dst_wow_walk_forward_score <- dst_wow_apply_weights(
      board,
      candidates[[production_candidate]]
    )
    board <- board |>
      dplyr::group_by(season, predicts_week) |>
      dplyr::mutate(
        dst_wow_walk_forward_rank = dplyr::dense_rank(dplyr::desc(dst_wow_walk_forward_score)),
        dst_wow_walk_forward_tier = dplyr::case_when(
          dst_wow_walk_forward_rank <= 5 ~ "Top 5",
          dst_wow_walk_forward_rank <= 12 ~ "Top 12",
          dst_wow_walk_forward_rank <= 24 ~ "Top 24",
          TRUE ~ "Field"
        )
      ) |>
      dplyr::ungroup() |>
      dplyr::arrange(season, predicts_week, dst_wow_walk_forward_rank)
    fold_boards[[as.character(test_season)]] <- board
  }
  
  walk_forward_tuning <- dplyr::bind_rows(fold_tuning)
  walk_forward_summary <- dplyr::bind_rows(fold_summary)
  walk_forward_test_metrics <- dplyr::bind_rows(fold_test_metrics)
  walk_forward_final_export <- dplyr::bind_rows(fold_boards)
  
  if (write_output) {
    dir.create(model_paths$wow_output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      walk_forward_tuning,
      file.path(model_paths$wow_output_dir, "dst_wow_walk_forward_tuning_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    utils::write.csv(
      walk_forward_summary,
      file.path(model_paths$wow_output_dir, "dst_wow_walk_forward_summary_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    utils::write.csv(
      walk_forward_test_metrics,
      file.path(model_paths$wow_output_dir, "dst_wow_walk_forward_test_metrics_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    utils::write.csv(
      walk_forward_final_export,
      file.path(model_paths$wow_output_dir, "dst_wow_walk_forward_final_export_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  result <- list(
    dst_wow_walk_forward_weekly_base = weekly,
    dst_wow_walk_forward_feature_base = feature_base,
    dst_wow_walk_forward_tuning = walk_forward_tuning,
    dst_wow_walk_forward_summary = walk_forward_summary,
    dst_wow_walk_forward_test_metrics = walk_forward_test_metrics,
    dst_wow_walk_forward_final_export = walk_forward_final_export
  )
  for (nm in names(result)) assign(nm, result[[nm]], envir = .GlobalEnv)
  result
}

run_core_wow_partial_season_audit <- function(
    season = 2025L,
    cutoffs = c(1L, 2L, 4L, 8L),
    write_output = TRUE
) {
  load_model_core_packages()
  
  original_loader <- get("load_all_positions_hybrid", envir = .GlobalEnv)
  on.exit(
    assign("load_all_positions_hybrid", original_loader, envir = .GlobalEnv),
    add = TRUE
  )
  
  raw_full <- original_loader(model_paths$all_positions_hybrid_csv)
  season_col <- if ("SEA" %in% names(raw_full)) "SEA" else "season"
  week_col <- if ("WK" %in% names(raw_full)) "WK" else "week"
  if (!all(c(season_col, week_col) %in% names(raw_full))) {
    stop("The hybrid source is missing season/week columns needed for the partial-season audit.", call. = FALSE)
  }
  
  runner_list <- list(
    QB = function() run_qb_wow_board_rebuild(write_output = FALSE),
    RB = function() run_rb_wow_board_rebuild(write_output = FALSE),
    WR = function() run_wr_wow_board_rebuild(write_output = FALSE),
    TE = function() run_te_wow_board_rebuild(write_output = FALSE),
    K = function() run_k_wow_board_rebuild(write_output = FALSE),
    DST = function() run_dst_wow_board_rebuild(write_output = FALSE)
  )
  
  safe_max <- function(x) {
    x <- suppressWarnings(as.numeric(x))
    if (any(is.finite(x))) max(x, na.rm = TRUE) else NA_real_
  }
  
  audit_rows <- list()
  cutoffs <- sort(unique(as.integer(cutoffs)))
  
  for (cutoff in cutoffs) {
    raw_cutoff <- raw_full |>
      dplyr::filter(
        suppressWarnings(as.integer(.data[[season_col]])) != season |
          is.na(suppressWarnings(as.integer(.data[[week_col]]))) |
          suppressWarnings(as.integer(.data[[week_col]])) <= cutoff
      )
    
    assign(
      "load_all_positions_hybrid",
      (function(raw_value) {
        function(file_path = model_paths$all_positions_hybrid_csv) raw_value
      })(raw_cutoff),
      envir = .GlobalEnv
    )
    
    input_season_values <- suppressWarnings(as.integer(raw_cutoff[[season_col]]))
    input_week_values <- suppressWarnings(as.integer(raw_cutoff[[week_col]]))
    input_2025 <- input_week_values[input_season_values == season]
    
    for (position in names(runner_list)) {
      result <- tryCatch(
        runner_list[[position]](),
        error = function(e) e
      )
      
      if (inherits(result, "error")) {
        audit_rows[[length(audit_rows) + 1L]] <- data.frame(
          season = season,
          cutoff_week = cutoff,
          position = position,
          status = "FAIL",
          input_rows_2025 = sum(input_season_values == season, na.rm = TRUE),
          input_max_week_2025 = safe_max(input_2025),
          board_rows_2025 = NA_integer_,
          board_max_feature_week_2025 = NA_real_,
          board_max_predicts_week_2025 = NA_real_,
          future_feature_rows = NA_integer_,
          future_prediction_rows = NA_integer_,
          duplicate_player_week_keys = NA_integer_,
          error = conditionMessage(result),
          stringsAsFactors = FALSE
        )
        next
      }
      
      board <- result$board
      if (is.null(board) || !is.data.frame(board) || !"season" %in% names(board)) {
        audit_rows[[length(audit_rows) + 1L]] <- data.frame(
          season = season,
          cutoff_week = cutoff,
          position = position,
          status = "FAIL",
          input_rows_2025 = sum(input_season_values == season, na.rm = TRUE),
          input_max_week_2025 = safe_max(input_2025),
          board_rows_2025 = NA_integer_,
          board_max_feature_week_2025 = NA_real_,
          board_max_predicts_week_2025 = NA_real_,
          future_feature_rows = NA_integer_,
          future_prediction_rows = NA_integer_,
          duplicate_player_week_keys = NA_integer_,
          error = "Runner did not return a board with a season column.",
          stringsAsFactors = FALSE
        )
        next
      }
      
      board_seasons <- suppressWarnings(as.integer(board$season))
      board_2025 <- board[board_seasons == season, , drop = FALSE]
      feature_col <- if ("feature_week" %in% names(board_2025)) "feature_week" else "week"
      feature_values <- if (feature_col %in% names(board_2025)) {
        suppressWarnings(as.numeric(board_2025[[feature_col]]))
      } else {
        rep(NA_real_, nrow(board_2025))
      }
      predicts_values <- if ("predicts_week" %in% names(board_2025)) {
        suppressWarnings(as.numeric(board_2025$predicts_week))
      } else {
        rep(NA_real_, nrow(board_2025))
      }
      
      key_cols <- intersect(c("season", feature_col, "player", "team"), names(board_2025))
      duplicate_keys <- NA_integer_
      if (length(key_cols) >= 4L && nrow(board_2025) > 0L) {
        key_values <- apply(board_2025[key_cols], 1, paste, collapse = "\r")
        duplicate_keys <- sum(duplicated(key_values))
      }
      
      future_feature_rows <- sum(is.finite(feature_values) & feature_values > cutoff)
      future_prediction_rows <- sum(is.finite(predicts_values) & predicts_values > cutoff + 1L)
      status <- if (
        nrow(board_2025) > 0L &&
        safe_max(input_2025) <= cutoff &&
        future_feature_rows == 0L &&
        future_prediction_rows == 0L
      ) "PASS" else "FAIL"
      
      audit_rows[[length(audit_rows) + 1L]] <- data.frame(
        season = season,
        cutoff_week = cutoff,
        position = position,
        status = status,
        input_rows_2025 = sum(input_season_values == season, na.rm = TRUE),
        input_max_week_2025 = safe_max(input_2025),
        board_rows_2025 = nrow(board_2025),
        board_max_feature_week_2025 = safe_max(feature_values),
        board_max_predicts_week_2025 = safe_max(predicts_values),
        future_feature_rows = future_feature_rows,
        future_prediction_rows = future_prediction_rows,
        duplicate_player_week_keys = duplicate_keys,
        error = NA_character_,
        stringsAsFactors = FALSE
      )
    }
  }
  
  audit <- dplyr::bind_rows(audit_rows) |>
    dplyr::arrange(cutoff_week, position)
  summary <- audit |>
    dplyr::group_by(season, cutoff_week) |>
    dplyr::summarise(
      positions_checked = dplyr::n(),
      positions_passed = sum(status == "PASS", na.rm = TRUE),
      positions_failed = sum(status == "FAIL", na.rm = TRUE),
      status = ifelse(positions_failed == 0L, "PASS", "FAIL"),
      .groups = "drop"
    ) |>
    dplyr::arrange(cutoff_week)
  
  if (write_output) {
    dir.create(model_paths$wow_output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      audit,
      file.path(model_paths$wow_output_dir, paste0("core_wow_partial_season_audit_", season, ".csv")),
      row.names = FALSE,
      na = ""
    )
    utils::write.csv(
      summary,
      file.path(model_paths$wow_output_dir, paste0("core_wow_partial_season_audit_summary_", season, ".csv")),
      row.names = FALSE,
      na = ""
    )
  }
  
  result <- list(
    audit = audit,
    summary = summary,
    cutoffs = cutoffs,
    season = season
  )
  assign("core_wow_partial_season_audit", result, envir = .GlobalEnv)
  result
}

# Strict 2025 WOW review. The position board rebuilds are chronological by
# design; DST additionally selects its candidate using only pre-2025 weeks.
run_core_wow_walk_forward_2025 <- function(
    test_season = 2025L,
    write_output = TRUE
) {
  load_model_core_packages()
  
  test_season <- as.integer(test_season[[1]])
  position_specs <- list(
    QB = run_qb_wow_board_rebuild,
    RB = run_rb_wow_board_rebuild,
    WR = run_wr_wow_board_rebuild,
    TE = run_te_wow_board_rebuild,
    K = run_k_wow_board_rebuild
  )
  
  summary_rows <- list()
  week_rows <- list()
  selected_exports <- list()
  
  for (position in names(position_specs)) {
    rebuilt <- position_specs[[position]](write_output = FALSE)
    summary_raw <- rebuilt$board_summary$summary |>
      dplyr::filter(.data$season == .env$test_season) |>
      dplyr::slice(1)
    
    summary_rows[[position]] <- data.frame(
      position = position,
      season = test_season,
      selected_model = "board_rebuild_current",
      selection_rule = "fixed_chronological_board_logic",
      weeks_total = summary_raw$weeks_total[[1]],
      scorable_weeks = summary_raw$scorable_weeks[[1]],
      avg_spearman = summary_raw$avg_spearman[[1]],
      median_spearman = summary_raw$median_spearman[[1]],
      min_spearman = summary_raw$min_spearman[[1]],
      max_spearman = summary_raw$max_spearman[[1]],
      weeks_over_0 = summary_raw$weeks_over_0[[1]],
      weeks_over_030 = summary_raw$weeks_over_030[[1]],
      weeks_over_040 = summary_raw$weeks_over_040[[1]],
      avg_legacy_spearman = NA_real_,
      avg_spearman_gain_vs_legacy = NA_real_,
      stringsAsFactors = FALSE
    )
    
    week_raw <- rebuilt$board_summary$week_metrics |>
      dplyr::filter(.data$season == .env$test_season)
    if (!"feature_week" %in% names(week_raw)) {
      week_raw$feature_week <- week_raw$week
    }
    if (!"legacy_spearman" %in% names(week_raw)) {
      week_raw$legacy_spearman <- NA_real_
    }
    if (!"spearman_gain_vs_legacy" %in% names(week_raw)) {
      week_raw$spearman_gain_vs_legacy <- NA_real_
    }
    week_rows[[position]] <- week_raw |>
      dplyr::transmute(
        position = .env$position,
        season = .data$season,
        feature_week = .data$feature_week,
        predicts_week = .data$predicts_week,
        n = .data$n,
        spearman = .data$spearman,
        legacy_spearman = .data$legacy_spearman,
        spearman_gain_vs_legacy = .data$spearman_gain_vs_legacy,
        selected_model = "board_rebuild_current",
        selection_rule = "fixed_chronological_board_logic"
      )
    
    selected_exports[[position]] <- rebuilt$final_export |>
      dplyr::filter(.data$season == .env$test_season) |>
      dplyr::mutate(
        position = .env$position,
        selected_model = "board_rebuild_current",
        selection_rule = "fixed_chronological_board_logic",
        .before = 1
      )
  }
  
  dst_holdout <- run_dst_wow_holdout_pipeline(
    test_season = test_season,
    write_output = write_output
  )
  dst_selected_model <- dst_holdout$dst_wow_holdout_production_candidate
  dst_summary <- dst_holdout$dst_wow_holdout_test_summary |>
    dplyr::filter(.data$model == .env$dst_selected_model) |>
    dplyr::slice(1)
  
  summary_rows[["DST"]] <- data.frame(
    position = "DST",
    season = test_season,
    selected_model = dst_selected_model,
    selection_rule = paste0("trained_through_", test_season - 1L),
    weeks_total = 18L,
    scorable_weeks = dst_summary$scorable_weeks[[1]],
    avg_spearman = dst_summary$avg_spearman[[1]],
    median_spearman = dst_summary$median_spearman[[1]],
    min_spearman = dst_summary$min_spearman[[1]],
    max_spearman = dst_summary$max_spearman[[1]],
    weeks_over_0 = dst_summary$weeks_over_0[[1]],
    weeks_over_030 = dst_summary$weeks_over_030[[1]],
    weeks_over_040 = dst_summary$weeks_over_040[[1]],
    avg_legacy_spearman = dst_summary$avg_legacy_spearman[[1]],
    avg_spearman_gain_vs_legacy = dst_summary$avg_spearman_gain_vs_legacy[[1]],
    stringsAsFactors = FALSE
  )
  
  dst_week_raw <- dst_holdout$dst_wow_holdout_test_metrics |>
    dplyr::filter(.data$model == .env$dst_selected_model)
  week_rows[["DST"]] <- dst_week_raw |>
    dplyr::transmute(
      position = "DST",
      season = .data$season,
      feature_week = .data$feature_week,
      predicts_week = .data$predicts_week,
      n = .data$n,
      spearman = .data$spearman,
      legacy_spearman = .data$legacy_spearman,
      spearman_gain_vs_legacy = .data$spearman_gain_vs_legacy,
      selected_model = .env$dst_selected_model,
      selection_rule = paste0("trained_through_", .env$test_season - 1L)
    )
  selected_exports[["DST"]] <- dst_holdout$dst_wow_holdout_final_export |>
    dplyr::mutate(
      position = "DST",
      selected_model = .env$dst_selected_model,
      selection_rule = paste0("trained_through_", .env$test_season - 1L),
      .before = 1
    )
  
  summary <- dplyr::bind_rows(summary_rows) |>
    dplyr::arrange(.data$position)
  week_metrics <- dplyr::bind_rows(week_rows) |>
    dplyr::arrange(.data$position, .data$feature_week)
  selected_export <- dplyr::bind_rows(selected_exports)
  
  if (write_output) {
    dir.create(model_paths$wow_output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      summary,
      file.path(model_paths$wow_output_dir, "core_wow_walk_forward_2025_summary.csv"),
      row.names = FALSE,
      na = ""
    )
    utils::write.csv(
      week_metrics,
      file.path(model_paths$wow_output_dir, "core_wow_walk_forward_2025_week_metrics.csv"),
      row.names = FALSE,
      na = ""
    )
    utils::write.csv(
      selected_export,
      file.path(model_paths$wow_output_dir, "core_wow_walk_forward_2025_selected_export.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  result <- list(
    summary = summary,
    week_metrics = week_metrics,
    selected_export = selected_export,
    test_season = test_season,
    dst_selected_model = dst_selected_model
  )
  assign("core_wow_walk_forward_2025", result, envir = .GlobalEnv)
  result
}

message("DST WOW board rebuild runner: run_dst_wow_board_rebuild()")
message("DST WOW holdout runner: run_dst_wow_holdout_pipeline()")
message("DST WOW walk-forward runner: run_dst_wow_walk_forward_pipeline()")
message("Core partial-season audit: run_core_wow_partial_season_audit()")

# -----------------------------------------------------------------------------
# WOW tier-finish probabilities
# -----------------------------------------------------------------------------

wow_probability_output_dir <- function() {
  file.path(model_paths$model_root_dir, "outputs", "probabilities")
}

wow_prob_num <- function(x) suppressWarnings(as.numeric(x))
wow_prob_clamp <- function(x, lower = 0.01, upper = 0.99) pmin(pmax(x, lower), upper)

wow_prob_rank_score <- function(rank, group_n) {
  rank <- wow_prob_num(rank)
  group_n <- wow_prob_num(group_n)
  if (length(group_n) == 1L && length(rank) > 1L) group_n <- rep(group_n, length(rank))
  if (length(rank) == 1L && length(group_n) > 1L) rank <- rep(rank, length(group_n))
  if (length(rank) != length(group_n)) {
    stop("rank and group_n must have compatible lengths.", call. = FALSE)
  }
  out <- rep(NA_real_, length(rank))
  keep <- is.finite(rank) & is.finite(group_n) & group_n > 1
  out[keep] <- 100 * (group_n[keep] - rank[keep]) / (group_n[keep] - 1)
  out[is.finite(rank) & is.finite(group_n) & group_n == 1] <- 50
  out
}

wow_prob_z <- function(x) {
  x <- wow_prob_num(x)
  center <- stats::median(x[is.finite(x)], na.rm = TRUE)
  scale <- stats::mad(x[is.finite(x)], constant = 1.4826, na.rm = TRUE)
  if (!is.finite(center)) center <- 50
  if (!is.finite(scale) || scale <= 0) scale <- 15
  z <- (x - center) / scale
  fill <- stats::median(z[is.finite(z)], na.rm = TRUE)
  if (!is.finite(fill)) fill <- 0
  z[!is.finite(z)] <- fill
  z
}

wow_prob_targets <- function(position) {
  switch(
    toupper(position),
    QB = c(top3 = 3L, top6 = 6L, top12 = 12L, top18 = 18L),
    RB = c(top6 = 6L, top12 = 12L, top24 = 24L, top36 = 36L),
    WR = c(top12 = 12L, top24 = 24L, top36 = 36L, top48 = 48L),
    TE = c(top5 = 5L, top12 = 12L, top18 = 18L, top24 = 24L),
    c(top12 = 12L)
  )
}

wow_prob_fit_predict <- function(df, target_col) {
  target <- suppressWarnings(as.integer(df[[target_col]]))
  train <- df[!is.na(target), , drop = FALSE]
  target_train <- target[!is.na(target)]
  if (length(target_train) < 25 || length(unique(target_train)) < 2) {
    base_rate <- mean(target_train, na.rm = TRUE)
    if (!is.finite(base_rate)) base_rate <- 0
    return(wow_prob_clamp(rep(base_rate, nrow(df))))
  }
  train$target_outcome <- target_train
  fit <- try(
    suppressWarnings(stats::glm(
      target_outcome ~ model_score_z + rank_score_z + omfg_score_z + board_score_z,
      data = train,
      family = stats::binomial()
    )),
    silent = TRUE
  )
  if (inherits(fit, "try-error")) {
    base_rate <- mean(target_train, na.rm = TRUE)
    return(wow_prob_clamp(rep(base_rate, nrow(df))))
  }
  pred <- try(suppressWarnings(stats::predict(fit, newdata = df, type = "response")), silent = TRUE)
  if (inherits(pred, "try-error")) pred <- rep(mean(target_train, na.rm = TRUE), nrow(df))
  wow_prob_clamp(as.numeric(pred))
}

build_position_wow_tier_probabilities <- function(position, write_output = TRUE) {
  load_model_core_packages()
  position <- toupper(position)
  input_path <- file.path(model_paths$wow_output_dir, paste0(tolower(position), "_wow_final_export_2021_2025.csv"))
  if (!file.exists(input_path)) stop("Missing WOW final export: ", input_path, call. = FALSE)
  
  df <- utils::read.csv(input_path, stringsAsFactors = FALSE, check.names = FALSE)
  thresholds <- wow_prob_targets(position)
  calibration_profile <- if (position == "QB") {
    build_qb_wow_probability_calibration_profile(write_output = write_output)
  } else {
    NULL
  }
  actual_col <- if ("actual_next_week_fp" %in% names(df)) {
    "actual_next_week_fp"
  } else if ("actual_week_fp" %in% names(df)) {
    "actual_week_fp"
  } else {
    stop("No weekly actual fantasy column found for ", position, call. = FALSE)
  }
  week_col <- if ("predicts_week" %in% names(df)) "predicts_week" else "week"
  in_season_omfg <- if ("in_season_omfg" %in% names(df)) wow_prob_num(df$in_season_omfg) else rep(NA_real_, nrow(df))
  weekly_board_score <- if ("weekly_board_score" %in% names(df)) wow_prob_num(df$weekly_board_score) else rep(NA_real_, nrow(df))
  
  out <- df |>
    dplyr::mutate(
      position = position,
      season = as.integer(.data$season),
      rank = wow_prob_num(.data$rank),
      final_score = wow_prob_num(.data$final_score),
      in_season_omfg = in_season_omfg,
      weekly_board_score = weekly_board_score,
      actual_week_fp_for_probability = wow_prob_num(.data[[actual_col]]),
      probability_week = suppressWarnings(as.integer(.data[[week_col]]))
    ) |>
    dplyr::group_by(.data$season, .data$probability_week) |>
    dplyr::mutate(
      field_size = dplyr::n(),
      actual_week_rank = dplyr::if_else(
        is.finite(.data$actual_week_fp_for_probability),
        rank(-.data$actual_week_fp_for_probability, ties.method = "min", na.last = "keep"),
        NA_real_
      )
    ) |>
    dplyr::ungroup() |>
    dplyr::mutate(
      rank_score_0to100 = wow_prob_rank_score(.data$rank, .data$field_size),
      model_score_z = wow_prob_z(.data$final_score),
      rank_score_z = wow_prob_z(.data$rank_score_0to100),
      omfg_score_z = wow_prob_z(.data$in_season_omfg),
      board_score_z = wow_prob_z(.data$weekly_board_score)
    )
  
  for (target_name in names(thresholds)) {
    cutoff <- thresholds[[target_name]]
    outcome_col <- paste0("actual_week_", target_name)
    prob_col <- paste0("prob_week_", target_name)
    out[[outcome_col]] <- ifelse(is.finite(out$actual_week_rank), as.integer(out$actual_week_rank <= cutoff), NA_integer_)
    raw_probability <- wow_prob_fit_predict(out, outcome_col)
    if (position == "QB") {
      out[[paste0("raw_", prob_col)]] <- raw_probability
      out[[prob_col]] <- wow_prob_apply_oof_calibration(
        raw_probability,
        paste0("week_", target_name),
        calibration_profile
      )
    } else {
      out[[prob_col]] <- raw_probability
    }
  }
  
  probability_cols <- grep("^prob_week_", names(out), value = TRUE)
  raw_probability_cols <- grep("^raw_prob_week_", names(out), value = TRUE)
  keep_cols <- unique(c(
    "position", "season", "week", "predicts_week", "rank", "tier", "player", "team",
    "opponent", "final_score", "weekly_board_score", "in_season_omfg",
    raw_probability_cols, probability_cols,
    "actual_week_rank", actual_col
  ))
  keep_cols <- keep_cols[keep_cols %in% names(out)]
  export <- out |>
    dplyr::select(dplyr::all_of(keep_cols)) |>
    dplyr::arrange(.data$season, .data[[week_col]], .data$rank)
  
  summary_rows <- list()
  idx <- 1L
  for (target_name in names(thresholds)) {
    cutoff <- thresholds[[target_name]]
    outcome_col <- paste0("actual_week_", target_name)
    prob_col <- paste0("prob_week_", target_name)
    keep <- !is.na(out[[outcome_col]]) & is.finite(out[[prob_col]])
    summary_rows[[idx]] <- data.frame(
      position = position,
      model_family = "WOW",
      target = paste0("week_", target_name),
      cutoff = cutoff,
      rows = sum(keep),
      actual_rate = mean(out[[outcome_col]][keep], na.rm = TRUE),
      avg_predicted_probability = mean(out[[prob_col]][keep], na.rm = TRUE),
      calibration_adjustment_applied = if (position == "QB") {
        profile_row <- calibration_profile[calibration_profile$target == paste0("week_", target_name), , drop = FALSE]
        nrow(profile_row) == 1 && isTRUE(profile_row$adjustment_enabled[1])
      } else {
        FALSE
      },
      stringsAsFactors = FALSE
    )
    idx <- idx + 1L
  }
  summary <- dplyr::bind_rows(summary_rows)
  
  if (write_output) {
    output_dir <- wow_probability_output_dir()
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(export, file.path(output_dir, paste0(tolower(position), "_wow_tier_probability_export_2021_2025.csv")), row.names = FALSE, na = "")
    utils::write.csv(summary, file.path(output_dir, paste0(tolower(position), "_wow_tier_probability_summary_2021_2025.csv")), row.names = FALSE, na = "")
  }
  list(export = export, summary = summary)
}

build_core_wow_tier_probabilities <- function(positions = c("QB", "RB", "WR", "TE"), write_output = TRUE) {
  load_model_core_packages()
  results <- lapply(positions, build_position_wow_tier_probabilities, write_output = write_output)
  names(results) <- positions
  summary <- dplyr::bind_rows(lapply(results, `[[`, "summary"))
  if (write_output) {
    output_dir <- wow_probability_output_dir()
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(summary, file.path(output_dir, "core_wow_tier_probability_summary_2021_2025.csv"), row.names = FALSE, na = "")
  }
  result <- list(results = results, summary = summary)
  assign("core_wow_tier_probabilities", result, envir = .GlobalEnv)
  result
}

build_core_wow_probability_lift_audit <- function(
    positions = c("QB", "RB", "WR", "TE"),
    write_output = TRUE
) {
  load_model_core_packages()
  output_dir <- wow_probability_output_dir()
  audit_rows <- list()
  idx <- 1L
  
  for (position in toupper(positions)) {
    input_path <- file.path(output_dir, paste0(tolower(position), "_wow_tier_probability_export_2021_2025.csv"))
    if (!file.exists(input_path)) {
      build_position_wow_tier_probabilities(position, write_output = TRUE)
    }
    df <- utils::read.csv(input_path, stringsAsFactors = FALSE, check.names = FALSE)
    probability_cols <- grep("^prob_week_top[0-9]+$", names(df), value = TRUE)
    
    for (prob_col in probability_cols) {
      cutoff <- suppressWarnings(as.integer(sub(".*_top", "", prob_col)))
      if (!"actual_week_rank" %in% names(df) || !is.finite(cutoff)) next
      
      tmp <- data.frame(
        probability = wow_prob_num(df[[prob_col]]),
        actual_rank = wow_prob_num(df$actual_week_rank)
      )
      tmp <- tmp[is.finite(tmp$probability) & is.finite(tmp$actual_rank), , drop = FALSE]
      if (nrow(tmp) == 0) next
      tmp$actual_hit <- as.integer(tmp$actual_rank <= cutoff)
      tmp$probability_decile <- dplyr::ntile(tmp$probability, 10)
      base_rate <- mean(tmp$actual_hit, na.rm = TRUE)
      target_label <- sub("^prob_", "", prob_col)
      
      audit <- tmp |>
        dplyr::group_by(.data$probability_decile) |>
        dplyr::summarise(
          rows = dplyr::n(),
          avg_probability = mean(.data$probability, na.rm = TRUE),
          actual_rate = mean(.data$actual_hit, na.rm = TRUE),
          .groups = "drop"
        ) |>
        dplyr::mutate(
          position = position,
          model_family = "WOW",
          target = target_label,
          cutoff = cutoff,
          base_rate = base_rate,
          lift_vs_base = .data$actual_rate / .data$base_rate,
          .before = 1
        )
      audit_rows[[idx]] <- audit
      idx <- idx + 1L
    }
  }
  
  out <- dplyr::bind_rows(audit_rows) |>
    dplyr::arrange(.data$position, .data$target, .data$probability_decile)
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "core_wow_tier_probability_lift_audit_2021_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  assign("core_wow_tier_probability_lift_audit", out, envir = .GlobalEnv)
  out
}

wow_prob_walk_forward_fit <- function(train_df, test_df, outcome_col) {
  predictor_cols <- c("final_score", "rank_score_0to100", "in_season_omfg", "weekly_board_score")
  target <- suppressWarnings(as.integer(train_df[[outcome_col]]))
  keep <- !is.na(target)
  train_base_rate <- mean(target[keep], na.rm = TRUE)
  if (!is.finite(train_base_rate)) train_base_rate <- 0
  
  if (sum(keep) < 25 || length(unique(target[keep])) < 2) {
    return(list(
      probability = wow_prob_clamp(rep(train_base_rate, nrow(test_df))),
      fit_method = "training_base_rate",
      n_train = sum(keep),
      train_base_rate = train_base_rate
    ))
  }
  
  train_model <- data.frame(target_outcome = target[keep])
  test_model <- data.frame(row_id = seq_len(nrow(test_df)))
  z_cols <- character()
  for (predictor_col in predictor_cols) {
    train_values <- wow_prob_num(train_df[[predictor_col]])
    test_values <- wow_prob_num(test_df[[predictor_col]])
    center <- stats::median(train_values[keep & is.finite(train_values)], na.rm = TRUE)
    scale <- stats::mad(train_values[keep & is.finite(train_values)], constant = 1.4826, na.rm = TRUE)
    if (!is.finite(center)) center <- 50
    if (!is.finite(scale) || scale <= 0) scale <- 15
    z_col <- paste0(predictor_col, "_z")
    train_model[[z_col]] <- (train_values[keep] - center) / scale
    test_model[[z_col]] <- (test_values - center) / scale
    train_model[[z_col]][!is.finite(train_model[[z_col]])] <- 0
    test_model[[z_col]][!is.finite(test_model[[z_col]])] <- 0
    z_cols <- c(z_cols, z_col)
  }
  
  fit <- try(
    suppressWarnings(stats::glm(
      stats::reformulate(z_cols, response = "target_outcome"),
      data = train_model,
      family = stats::binomial()
    )),
    silent = TRUE
  )
  if (inherits(fit, "try-error")) {
    return(list(
      probability = wow_prob_clamp(rep(train_base_rate, nrow(test_df))),
      fit_method = "training_base_rate_fit_failed",
      n_train = sum(keep),
      train_base_rate = train_base_rate
    ))
  }
  
  probability <- try(
    suppressWarnings(stats::predict(fit, newdata = test_model, type = "response")),
    silent = TRUE
  )
  if (inherits(probability, "try-error")) {
    probability <- rep(train_base_rate, nrow(test_df))
    fit_method <- "training_base_rate_predict_failed"
  } else {
    fit_method <- "chronological_logistic"
  }
  list(
    probability = wow_prob_clamp(as.numeric(probability)),
    fit_method = fit_method,
    n_train = sum(keep),
    train_base_rate = train_base_rate
  )
}

wow_prob_auc <- function(actual, probability) {
  keep <- !is.na(actual) & is.finite(probability)
  actual <- as.integer(actual[keep])
  probability <- probability[keep]
  n_pos <- sum(actual == 1L)
  n_neg <- sum(actual == 0L)
  if (n_pos == 0 || n_neg == 0) return(NA_real_)
  ranks <- rank(probability, ties.method = "average")
  (sum(ranks[actual == 1L]) - n_pos * (n_pos + 1) / 2) / (n_pos * n_neg)
}

wow_prob_calibration_stats <- function(actual, probability) {
  keep <- !is.na(actual) & is.finite(probability)
  actual <- as.integer(actual[keep])
  probability <- wow_prob_clamp(probability[keep], 0.001, 0.999)
  intercept <- NA_real_
  slope <- NA_real_
  if (length(actual) >= 25 && length(unique(actual)) == 2) {
    linear_predictor <- stats::qlogis(probability)
    intercept_fit <- try(
      suppressWarnings(stats::glm(actual ~ offset(linear_predictor), family = stats::binomial())),
      silent = TRUE
    )
    slope_fit <- try(
      suppressWarnings(stats::glm(actual ~ linear_predictor, family = stats::binomial())),
      silent = TRUE
    )
    if (!inherits(intercept_fit, "try-error")) intercept <- unname(stats::coef(intercept_fit)[1])
    if (!inherits(slope_fit, "try-error")) slope <- unname(stats::coef(slope_fit)[2])
  }
  c(calibration_intercept = intercept, calibration_slope = slope)
}

run_position_wow_probability_walk_forward <- function(
    position,
    test_seasons = NULL,
    write_output = TRUE
) {
  load_model_core_packages()
  position_label <- toupper(position)
  input_path <- file.path(
    model_paths$wow_output_dir,
    paste0(tolower(position_label), "_wow_final_export_2021_2025.csv")
  )
  if (!file.exists(input_path)) stop("Missing WOW final export: ", input_path, call. = FALSE)
  
  df <- utils::read.csv(input_path, stringsAsFactors = FALSE, check.names = FALSE)
  thresholds <- wow_prob_targets(position_label)
  actual_col <- if ("actual_next_week_fp" %in% names(df)) {
    "actual_next_week_fp"
  } else if ("actual_week_fp" %in% names(df)) {
    "actual_week_fp"
  } else {
    stop("No weekly actual fantasy column found for ", position_label, call. = FALSE)
  }
  week_col <- if ("predicts_week" %in% names(df)) "predicts_week" else "week"
  in_season_omfg <- if ("in_season_omfg" %in% names(df)) wow_prob_num(df$in_season_omfg) else rep(NA_real_, nrow(df))
  weekly_board_score <- if ("weekly_board_score" %in% names(df)) wow_prob_num(df$weekly_board_score) else rep(NA_real_, nrow(df))
  frame <- df |>
    dplyr::mutate(
      season = as.integer(.data$season),
      rank = wow_prob_num(.data$rank),
      final_score = wow_prob_num(.data$final_score),
      in_season_omfg = in_season_omfg,
      weekly_board_score = weekly_board_score,
      actual_week_fp_for_probability = wow_prob_num(.data[[actual_col]]),
      probability_week = suppressWarnings(as.integer(.data[[week_col]]))
    ) |>
    dplyr::group_by(.data$season, .data$probability_week) |>
    dplyr::mutate(
      field_size = dplyr::n(),
      actual_week_rank = dplyr::if_else(
        is.finite(.data$actual_week_fp_for_probability),
        rank(-.data$actual_week_fp_for_probability, ties.method = "min", na.last = "keep"),
        NA_real_
      )
    ) |>
    dplyr::ungroup() |>
    dplyr::mutate(rank_score_0to100 = wow_prob_rank_score(.data$rank, .data$field_size))
  
  for (target_name in names(thresholds)) {
    cutoff <- thresholds[[target_name]]
    frame[[paste0("actual_week_", target_name)]] <- ifelse(
      is.finite(frame$actual_week_rank), as.integer(frame$actual_week_rank <= cutoff), NA_integer_
    )
  }
  
  available_seasons <- sort(unique(frame$season[is.finite(frame$season)]))
  eligible_test_seasons <- available_seasons[available_seasons > min(available_seasons)]
  if (!is.null(test_seasons)) {
    eligible_test_seasons <- intersect(eligible_test_seasons, as.integer(test_seasons))
  }
  prediction_rows <- list()
  idx <- 1L
  
  for (test_season in eligible_test_seasons) {
    train <- frame[frame$season < test_season, , drop = FALSE]
    test <- frame[frame$season == test_season, , drop = FALSE]
    train_seasons_label <- paste(sort(unique(train$season)), collapse = ",")
    if (nrow(train) == 0 || nrow(test) == 0) next
    
    for (target_name in names(thresholds)) {
      cutoff <- thresholds[[target_name]]
      outcome_col <- paste0("actual_week_", target_name)
      fitted <- wow_prob_walk_forward_fit(train, test, outcome_col)
      prediction_rows[[idx]] <- test |>
        dplyr::transmute(
          position = position_label,
          model_family = "WOW",
          test_season = test_season,
          train_seasons = train_seasons_label,
          feature_week = .data$week,
          predicts_week = .data$probability_week,
          target = paste0("week_", target_name),
          cutoff = cutoff,
          player = .data$player,
          team = .data$team,
          opponent = .data$opponent,
          model_rank = .data$rank,
          final_score = .data$final_score,
          in_season_omfg = .data$in_season_omfg,
          probability = fitted$probability,
          actual_hit = .data[[outcome_col]],
          actual_rank = .data$actual_week_rank,
          fit_method = fitted$fit_method,
          n_train = fitted$n_train,
          train_base_rate = fitted$train_base_rate
        )
      idx <- idx + 1L
    }
  }
  
  predictions <- dplyr::bind_rows(prediction_rows) |>
    dplyr::filter(!is.na(.data$actual_hit), is.finite(.data$probability)) |>
    dplyr::arrange(.data$test_season, .data$target, dplyr::desc(.data$probability))
  if (nrow(predictions) == 0) stop("No WOW walk-forward probability rows were produced for ", position_label, call. = FALSE)
  
  metric_groups <- split(
    predictions,
    interaction(predictions$test_season, predictions$target, drop = TRUE)
  )
  metrics <- dplyr::bind_rows(lapply(metric_groups, function(x) {
    x <- x[order(x$probability), , drop = FALSE]
    x$probability_decile <- dplyr::ntile(x$probability, 10)
    top <- x[x$probability_decile == 10L, , drop = FALSE]
    bottom <- x[x$probability_decile == 1L, , drop = FALSE]
    calibration <- wow_prob_calibration_stats(x$actual_hit, x$probability)
    base_rate <- mean(x$actual_hit)
    data.frame(
      position = position_label,
      model_family = "WOW",
      test_season = x$test_season[1],
      train_seasons = x$train_seasons[1],
      target = x$target[1],
      cutoff = x$cutoff[1],
      fit_method = x$fit_method[1],
      n_train = x$n_train[1],
      n_test = nrow(x),
      actual_rate = base_rate,
      avg_probability = mean(x$probability),
      calibration_error = mean(x$probability) - base_rate,
      absolute_calibration_error = abs(mean(x$probability) - base_rate),
      brier_score = mean((x$probability - x$actual_hit)^2),
      log_loss = mean(-(x$actual_hit * log(x$probability) + (1 - x$actual_hit) * log(1 - x$probability))),
      auc = wow_prob_auc(x$actual_hit, x$probability),
      calibration_intercept = calibration[["calibration_intercept"]],
      calibration_slope = calibration[["calibration_slope"]],
      bottom_decile_rows = nrow(bottom),
      bottom_decile_actual_rate = mean(bottom$actual_hit),
      top_decile_rows = nrow(top),
      top_decile_actual_rate = mean(top$actual_hit),
      top_decile_avg_probability = mean(top$probability),
      top_decile_lift_vs_base = mean(top$actual_hit) / base_rate,
      stringsAsFactors = FALSE
    )
  })) |>
    dplyr::arrange(.data$position, .data$target, .data$test_season)
  
  deciles <- predictions |>
    dplyr::group_by(.data$test_season, .data$train_seasons, .data$target, .data$cutoff) |>
    dplyr::mutate(
      probability_decile = dplyr::ntile(.data$probability, 10),
      base_rate = mean(.data$actual_hit)
    ) |>
    dplyr::group_by(.data$test_season, .data$train_seasons, .data$target, .data$cutoff, .data$probability_decile) |>
    dplyr::summarise(
      rows = dplyr::n(),
      avg_probability = mean(.data$probability),
      actual_rate = mean(.data$actual_hit),
      base_rate = dplyr::first(.data$base_rate),
      .groups = "drop"
    ) |>
    dplyr::mutate(
      position = position_label,
      model_family = "WOW",
      lift_vs_base = .data$actual_rate / .data$base_rate,
      .before = 1
    )
  
  list(predictions = predictions, metrics = metrics, deciles = deciles)
}

run_core_wow_probability_walk_forward <- function(
    positions = c("QB", "RB", "WR", "TE"),
    test_seasons = NULL,
    write_output = TRUE
) {
  load_model_core_packages()
  positions <- toupper(positions)
  results <- lapply(
    positions,
    run_position_wow_probability_walk_forward,
    test_seasons = test_seasons,
    write_output = FALSE
  )
  names(results) <- positions
  predictions <- dplyr::bind_rows(lapply(results, `[[`, "predictions"))
  metrics <- dplyr::bind_rows(lapply(results, `[[`, "metrics"))
  deciles <- dplyr::bind_rows(lapply(results, `[[`, "deciles"))
  
  pooled <- split(predictions, interaction(predictions$position, predictions$target, drop = TRUE))
  summary <- dplyr::bind_rows(lapply(pooled, function(x) {
    x$probability_decile <- dplyr::ntile(x$probability, 10)
    top <- x[x$probability_decile == 10L, , drop = FALSE]
    bottom <- x[x$probability_decile == 1L, , drop = FALSE]
    calibration <- wow_prob_calibration_stats(x$actual_hit, x$probability)
    base_rate <- mean(x$actual_hit)
    data.frame(
      position = x$position[1],
      model_family = "WOW",
      target = x$target[1],
      cutoff = x$cutoff[1],
      test_seasons = paste(sort(unique(x$test_season)), collapse = ","),
      rows = nrow(x),
      actual_rate = base_rate,
      avg_probability = mean(x$probability),
      absolute_calibration_error = abs(mean(x$probability) - base_rate),
      brier_score = mean((x$probability - x$actual_hit)^2),
      log_loss = mean(-(x$actual_hit * log(x$probability) + (1 - x$actual_hit) * log(1 - x$probability))),
      auc = wow_prob_auc(x$actual_hit, x$probability),
      calibration_intercept = calibration[["calibration_intercept"]],
      calibration_slope = calibration[["calibration_slope"]],
      bottom_decile_actual_rate = mean(bottom$actual_hit),
      top_decile_actual_rate = mean(top$actual_hit),
      top_decile_avg_probability = mean(top$probability),
      top_decile_lift_vs_base = mean(top$actual_hit) / base_rate,
      stringsAsFactors = FALSE
    )
  })) |>
    dplyr::arrange(.data$position, .data$target)
  
  if (write_output) {
    output_dir <- wow_probability_output_dir()
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    season_min <- min(predictions$test_season)
    season_max <- max(predictions$test_season)
    suffix <- paste0(season_min, "_", season_max)
    utils::write.csv(predictions, file.path(output_dir, paste0("core_wow_probability_walk_forward_predictions_", suffix, ".csv")), row.names = FALSE, na = "")
    utils::write.csv(metrics, file.path(output_dir, paste0("core_wow_probability_walk_forward_metrics_", suffix, ".csv")), row.names = FALSE, na = "")
    utils::write.csv(deciles, file.path(output_dir, paste0("core_wow_probability_walk_forward_deciles_", suffix, ".csv")), row.names = FALSE, na = "")
    utils::write.csv(summary, file.path(output_dir, paste0("core_wow_probability_walk_forward_summary_", suffix, ".csv")), row.names = FALSE, na = "")
  }
  result <- list(results = results, predictions = predictions, metrics = metrics, deciles = deciles, summary = summary)
  assign("core_wow_probability_walk_forward", result, envir = .GlobalEnv)
  result
}

build_qb_wow_probability_calibration_profile <- function(
    blend_weight = 0.50,
    min_relative_gain = 0.001,
    write_output = TRUE
) {
  blend_weight <- max(0, min(1, as.numeric(blend_weight)))
  min_relative_gain <- max(0, as.numeric(min_relative_gain))
  walk_forward <- run_position_wow_probability_walk_forward(
    "QB",
    write_output = FALSE
  )
  predictions <- walk_forward$predictions
  profile_rows <- list()
  idx <- 1L
  
  for (target_label in unique(predictions$target)) {
    target_rows <- predictions[predictions$target == target_label, , drop = FALSE]
    seasons <- sort(unique(target_rows$test_season))
    nested_rows <- list()
    nested_idx <- 1L
    
    if (length(seasons) > 1) {
      for (test_season in seasons[-1]) {
        train <- target_rows[target_rows$test_season < test_season, , drop = FALSE]
        test <- target_rows[target_rows$test_season == test_season, , drop = FALSE]
        train_logit <- stats::qlogis(wow_prob_clamp(train$probability, 0.001, 0.999))
        fit <- try(
          suppressWarnings(stats::glm(train$actual_hit ~ train_logit, family = stats::binomial())),
          silent = TRUE
        )
        if (inherits(fit, "try-error") || length(unique(train$actual_hit)) < 2) {
          calibrated_probability <- test$probability
        } else {
          test_logit <- stats::qlogis(wow_prob_clamp(test$probability, 0.001, 0.999))
          calibrated_probability <- stats::plogis(
            unname(stats::coef(fit)[1]) + unname(stats::coef(fit)[2]) * test_logit
          )
        }
        adjusted_probability <- wow_prob_clamp(
          (1 - blend_weight) * test$probability + blend_weight * calibrated_probability
        )
        nested_rows[[nested_idx]] <- data.frame(
          test_season = test_season,
          actual_hit = test$actual_hit,
          raw_probability = test$probability,
          adjusted_probability = adjusted_probability
        )
        nested_idx <- nested_idx + 1L
      }
    }
    
    nested <- dplyr::bind_rows(nested_rows)
    if (nrow(nested) > 0) {
      raw_brier <- mean((nested$raw_probability - nested$actual_hit)^2)
      adjusted_brier <- mean((nested$adjusted_probability - nested$actual_hit)^2)
      raw_log_loss <- mean(-(
        nested$actual_hit * log(nested$raw_probability) +
          (1 - nested$actual_hit) * log(1 - nested$raw_probability)
      ))
      adjusted_log_loss <- mean(-(
        nested$actual_hit * log(nested$adjusted_probability) +
          (1 - nested$actual_hit) * log(1 - nested$adjusted_probability)
      ))
    } else {
      raw_brier <- adjusted_brier <- raw_log_loss <- adjusted_log_loss <- NA_real_
    }
    
    full_logit <- stats::qlogis(wow_prob_clamp(target_rows$probability, 0.001, 0.999))
    final_fit <- try(
      suppressWarnings(stats::glm(target_rows$actual_hit ~ full_logit, family = stats::binomial())),
      silent = TRUE
    )
    fit_valid <- !inherits(final_fit, "try-error") && length(unique(target_rows$actual_hit)) == 2
    calibration_intercept <- if (fit_valid) unname(stats::coef(final_fit)[1]) else 0
    calibration_slope <- if (fit_valid) unname(stats::coef(final_fit)[2]) else 1
    brier_gain <- raw_brier - adjusted_brier
    log_loss_gain <- raw_log_loss - adjusted_log_loss
    relative_brier_gain <- if (is.finite(raw_brier) && raw_brier > 0) brier_gain / raw_brier else NA_real_
    relative_log_loss_gain <- if (is.finite(raw_log_loss) && raw_log_loss > 0) log_loss_gain / raw_log_loss else NA_real_
    adjustment_enabled <- is.finite(relative_brier_gain) && is.finite(relative_log_loss_gain) &&
      relative_brier_gain >= min_relative_gain && relative_log_loss_gain >= min_relative_gain &&
      is.finite(calibration_slope) && calibration_slope > 0
    
    profile_rows[[idx]] <- data.frame(
      position = "QB",
      model_family = "WOW",
      target = target_label,
      oof_seasons = paste(seasons, collapse = ","),
      nested_test_seasons = if (length(seasons) > 1) paste(seasons[-1], collapse = ",") else "",
      oof_rows = nrow(target_rows),
      nested_rows = nrow(nested),
      blend_weight = blend_weight,
      min_relative_gain = min_relative_gain,
      calibration_intercept = calibration_intercept,
      calibration_slope = calibration_slope,
      raw_brier = raw_brier,
      adjusted_brier = adjusted_brier,
      brier_gain = brier_gain,
      relative_brier_gain = relative_brier_gain,
      raw_log_loss = raw_log_loss,
      adjusted_log_loss = adjusted_log_loss,
      log_loss_gain = log_loss_gain,
      relative_log_loss_gain = relative_log_loss_gain,
      adjustment_enabled = adjustment_enabled,
      stringsAsFactors = FALSE
    )
    idx <- idx + 1L
  }
  
  profile <- dplyr::bind_rows(profile_rows) |>
    dplyr::arrange(.data$target)
  if (write_output) {
    output_dir <- wow_probability_output_dir()
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      profile,
      file.path(output_dir, "qb_wow_probability_calibration_profile.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  assign("qb_wow_probability_calibration_profile", profile, envir = .GlobalEnv)
  profile
}

wow_prob_apply_oof_calibration <- function(probability, target_label, profile) {
  probability <- wow_prob_clamp(wow_prob_num(probability))
  if (is.null(profile) || nrow(profile) == 0) return(probability)
  profile_row <- profile[profile$target == target_label, , drop = FALSE]
  if (nrow(profile_row) != 1 || !isTRUE(profile_row$adjustment_enabled[1])) return(probability)
  calibrated <- stats::plogis(
    profile_row$calibration_intercept[1] +
      profile_row$calibration_slope[1] * stats::qlogis(wow_prob_clamp(probability, 0.001, 0.999))
  )
  wow_prob_clamp(
    (1 - profile_row$blend_weight[1]) * probability +
      profile_row$blend_weight[1] * calibrated
  )
}

# -----------------------------------------------------------------------------
# WOW live production snapshots
# -----------------------------------------------------------------------------

wow_production_output_dir <- function() {
  file.path(model_paths$model_root_dir, "outputs", "production")
}

wow_prob_enforce_nested <- function(df, probability_cols) {
  if (length(probability_cols) < 2L || nrow(df) == 0L) return(df)
  
  adjusted <- t(apply(as.matrix(df[probability_cols]), 1L, function(values) {
    values <- wow_prob_num(values)
    if (all(!is.finite(values))) return(values)
    finite_values <- is.finite(values)
    if (!all(finite_values)) {
      values[!finite_values] <- stats::median(values[finite_values], na.rm = TRUE)
    }
    wow_prob_clamp(stats::isoreg(seq_along(values), values)$yf)
  }))
  df[probability_cols] <- adjusted
  df
}

wow_prepare_probability_frame <- function(df, include_actual = TRUE) {
  if (nrow(df) == 0L) return(df)
  
  actual_col <- if ("actual_next_week_fp" %in% names(df)) {
    "actual_next_week_fp"
  } else if ("actual_week_fp" %in% names(df)) {
    "actual_week_fp"
  } else {
    NA_character_
  }
  week_col <- if ("predicts_week" %in% names(df)) "predicts_week" else "week"
  in_season_omfg <- if ("in_season_omfg" %in% names(df)) wow_prob_num(df$in_season_omfg) else rep(NA_real_, nrow(df))
  weekly_board_score <- if ("weekly_board_score" %in% names(df)) wow_prob_num(df$weekly_board_score) else rep(NA_real_, nrow(df))
  
  out <- df |>
    dplyr::mutate(
      season = suppressWarnings(as.integer(.data$season)),
      rank = wow_prob_num(.data$rank),
      final_score = wow_prob_num(.data$final_score),
      in_season_omfg = .env$in_season_omfg,
      weekly_board_score = .env$weekly_board_score,
      probability_week = suppressWarnings(as.integer(.data[[week_col]]))
    ) |>
    dplyr::group_by(.data$season, .data$probability_week) |>
    dplyr::mutate(
      field_size = dplyr::n(),
      rank_score_0to100 = wow_prob_rank_score(.data$rank, .data$field_size)
    ) |>
    dplyr::ungroup()
  
  if (isTRUE(include_actual)) {
    if (!is.character(actual_col) || is.na(actual_col)) {
      stop("No weekly actual fantasy column is available for probability training.", call. = FALSE)
    }
    out$actual_week_fp_for_probability <- wow_prob_num(out[[actual_col]])
    out <- out |>
      dplyr::group_by(.data$season, .data$probability_week) |>
      dplyr::mutate(
        actual_week_rank = dplyr::if_else(
          is.finite(.data$actual_week_fp_for_probability),
          rank(-.data$actual_week_fp_for_probability, ties.method = "min", na.last = "keep"),
          NA_real_
        )
      ) |>
      dplyr::ungroup()
  }
  
  out
}

build_position_wow_production_probabilities <- function(
    position,
    production_rows,
    history_end_season,
    write_output = TRUE,
    output_dir = wow_production_output_dir()
) {
  load_model_core_packages()
  position <- toupper(position)
  if (!position %in% c("QB", "RB", "WR", "TE")) return(production_rows)
  if (nrow(production_rows) == 0L) stop("No production rows supplied for ", position, call. = FALSE)
  
  history_path <- file.path(
    model_paths$wow_output_dir,
    paste0(tolower(position), "_wow_final_export_2021_2025.csv")
  )
  if (!file.exists(history_path)) stop("Missing WOW probability history: ", history_path, call. = FALSE)
  
  history <- utils::read.csv(history_path, stringsAsFactors = FALSE, check.names = FALSE) |>
    dplyr::filter(suppressWarnings(as.integer(.data$season)) <= .env$history_end_season)
  train <- wow_prepare_probability_frame(history, include_actual = TRUE)
  test <- wow_prepare_probability_frame(production_rows, include_actual = FALSE)
  thresholds <- wow_prob_targets(position)
  
  for (target_name in names(thresholds)) {
    cutoff <- thresholds[[target_name]]
    outcome_col <- paste0("actual_week_", target_name)
    train[[outcome_col]] <- ifelse(
      is.finite(train$actual_week_rank),
      as.integer(train$actual_week_rank <= cutoff),
      NA_integer_
    )
  }
  
  calibration_profile <- NULL
  if (position == "QB") {
    calibration_path <- file.path(wow_probability_output_dir(), "qb_wow_probability_calibration_profile.csv")
    if (file.exists(calibration_path)) {
      calibration_profile <- utils::read.csv(calibration_path, stringsAsFactors = FALSE, check.names = FALSE)
    }
  }
  
  probability_cols <- character()
  for (target_name in names(thresholds)) {
    outcome_col <- paste0("actual_week_", target_name)
    probability_col <- paste0("prob_week_", target_name)
    fitted <- wow_prob_walk_forward_fit(train, test, outcome_col)
    probability <- fitted$probability
    if (position == "QB") {
      probability <- wow_prob_apply_oof_calibration(
        probability,
        paste0("week_", target_name),
        calibration_profile
      )
    }
    test[[probability_col]] <- probability
    probability_cols <- c(probability_cols, probability_col)
  }
  
  ordered_targets <- names(sort(unlist(thresholds)))
  ordered_probability_cols <- paste0("prob_week_", ordered_targets)
  test <- wow_prob_enforce_nested(test, ordered_probability_cols)
  out <- test |>
    dplyr::select(-dplyr::any_of(c(
      "probability_week", "field_size", "rank_score_0to100",
      "actual_week_fp_for_probability", "actual_week_rank"
    )))
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    prediction_season <- unique(as.integer(out$season))
    prediction_week <- unique(as.integer(out$predicts_week))
    if (length(prediction_season) == 1L && length(prediction_week) == 1L) {
      utils::write.csv(
        out,
        file.path(
          output_dir,
          paste0(tolower(position), "_wow_production_", prediction_season, "_week_", prediction_week, ".csv")
        ),
        row.names = FALSE,
        na = ""
      )
    }
  }
  
  out
}

wow_load_or_rebuild_position_export <- function(position, rebuild = TRUE) {
  position <- toupper(position)
  runners <- list(
    QB = run_qb_wow_board_rebuild,
    RB = run_rb_wow_board_rebuild,
    WR = run_wr_wow_board_rebuild,
    TE = run_te_wow_board_rebuild,
    K = run_k_wow_board_rebuild,
    DST = run_dst_wow_board_rebuild
  )
  if (!position %in% names(runners)) stop("Unsupported WOW production position: ", position, call. = FALSE)
  
  if (isTRUE(rebuild)) {
    return(runners[[position]](write_output = FALSE)$final_export)
  }
  
  path <- file.path(
    model_paths$wow_output_dir,
    paste0(tolower(position), "_wow_final_export_2021_2025.csv")
  )
  if (!file.exists(path)) stop("Missing saved WOW final export: ", path, call. = FALSE)
  utils::read.csv(path, stringsAsFactors = FALSE, check.names = FALSE)
}

build_core_wow_production_audit <- function(master, prediction_season, feature_week) {
  load_model_core_packages()
  positions <- c("QB", "RB", "WR", "TE", "K", "DST")
  
  dplyr::bind_rows(lapply(positions, function(position) {
    x <- master[master$position == position, , drop = FALSE]
    probability_cols <- grep("^prob_week_top[0-9]+$", names(x), value = TRUE)
    active_probability_cols <- probability_cols[
      vapply(probability_cols, function(col) any(is.finite(wow_prob_num(x[[col]]))), logical(1))
    ]
    duplicate_keys <- if (nrow(x) > 0L) {
      sum(duplicated(x[c("season", "feature_week", "player")]))
    } else {
      0L
    }
    missing_probabilities <- if (length(active_probability_cols) > 0L) {
      sum(!is.finite(as.matrix(x[active_probability_cols])))
    } else {
      0L
    }
    out_of_bounds <- if (length(active_probability_cols) > 0L) {
      values <- as.matrix(x[active_probability_cols])
      sum(is.finite(values) & (values < 0 | values > 1))
    } else {
      0L
    }
    nested_violations <- if (length(active_probability_cols) > 1L) {
      cutoffs <- suppressWarnings(as.integer(sub(".*top", "", active_probability_cols)))
      ordered_cols <- active_probability_cols[order(cutoffs)]
      sum(apply(as.matrix(x[ordered_cols]), 1L, function(values) {
        any(diff(wow_prob_num(values)) < -1e-12, na.rm = TRUE)
      }))
    } else {
      0L
    }
    
    checks <- c(
      nrow(x) > 0L,
      duplicate_keys == 0L,
      sum(!is.finite(wow_prob_num(x$rank))) == 0L,
      sum(as.integer(x$season) != prediction_season, na.rm = TRUE) == 0L,
      sum(as.integer(x$feature_week) != feature_week, na.rm = TRUE) == 0L,
      sum(as.integer(x$predicts_week) != feature_week + 1L, na.rm = TRUE) == 0L,
      missing_probabilities == 0L,
      out_of_bounds == 0L,
      nested_violations == 0L
    )
    
    data.frame(
      position = position,
      prediction_season = prediction_season,
      feature_week = feature_week,
      predicts_week = feature_week + 1L,
      rows = nrow(x),
      probability_columns = length(active_probability_cols),
      duplicate_player_week_keys = duplicate_keys,
      missing_ranks = sum(!is.finite(wow_prob_num(x$rank))),
      missing_probabilities = missing_probabilities,
      out_of_bounds_probabilities = out_of_bounds,
      nested_probability_violations = nested_violations,
      status = if (all(checks)) "PASS" else "FAIL",
      stringsAsFactors = FALSE
    )
  }))
}

run_core_wow_production <- function(
    prediction_season,
    feature_week,
    positions = c("QB", "RB", "WR", "TE", "K", "DST"),
    position_exports = NULL,
    rebuild = TRUE,
    write_output = TRUE,
    output_dir = wow_production_output_dir()
) {
  load_model_core_packages()
  prediction_season <- as.integer(prediction_season[[1]])
  feature_week <- as.integer(feature_week[[1]])
  positions <- toupper(positions)
  if (!is.finite(prediction_season) || !is.finite(feature_week) || feature_week < 1L || feature_week > 18L) {
    stop("prediction_season and feature_week must identify a valid NFL feature snapshot.", call. = FALSE)
  }
  
  results <- list()
  for (position in positions) {
    export <- if (!is.null(position_exports) && position %in% names(position_exports)) {
      position_exports[[position]]
    } else {
      wow_load_or_rebuild_position_export(position, rebuild = rebuild)
    }
    if (!"week" %in% names(export) && "feature_week" %in% names(export)) {
      export$week <- export$feature_week
    }
    if (!all(c("season", "week", "rank", "player") %in% names(export))) {
      stop("WOW export for ", position, " is missing required production columns.", call. = FALSE)
    }
    rows <- export |>
      dplyr::filter(
        suppressWarnings(as.integer(.data$season)) == .env$prediction_season,
        suppressWarnings(as.integer(.data$week)) == .env$feature_week
      )
    if (nrow(rows) == 0L) {
      stop(
        "No ", position, " WOW snapshot exists for season ", prediction_season,
        ", feature week ", feature_week, ". Feature week ", feature_week,
        " requires completed Week ", feature_week, " data and predicts Week ", feature_week + 1L,
        ". Before Week 1 is played, use run_core_sos_production() for the preseason board; ",
        "then load current-season weekly data before publishing WOW.",
        call. = FALSE
      )
    }
    if (!"predicts_week" %in% names(rows)) rows$predicts_week <- feature_week + 1L
    rows <- rows |>
      dplyr::mutate(
        position = .env$position,
        production_mode = if (.env$position %in% c("QB", "RB", "WR", "TE")) {
          "live_week_with_probabilities"
        } else {
          "live_week_rank_only"
        },
        feature_week = .data$week,
        .before = 1
      )
    if (position %in% c("QB", "RB", "WR", "TE")) {
      rows <- build_position_wow_production_probabilities(
        position = position,
        production_rows = rows,
        history_end_season = prediction_season - 1L,
        write_output = FALSE,
        output_dir = output_dir
      )
    }
    results[[position]] <- rows |>
      dplyr::arrange(.data$rank)
  }
  
  master <- dplyr::bind_rows(results) |>
    dplyr::arrange(.data$position, .data$rank)
  audit <- build_core_wow_production_audit(master, prediction_season, feature_week)
  if (any(audit$status != "PASS")) {
    failed <- paste(audit$position[audit$status != "PASS"], collapse = ", ")
    stop("WOW production audit failed for: ", failed, call. = FALSE)
  }
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    predicts_week <- feature_week + 1L
    position_paths <- vapply(names(results), function(position) {
      path <- file.path(
        output_dir,
        paste0(tolower(position), "_wow_production_", prediction_season, "_week_", predicts_week, ".csv")
      )
      utils::write.csv(results[[position]], path, row.names = FALSE, na = "")
      path
    }, character(1))
    master_path <- file.path(
      output_dir,
      paste0("core_wow_production_", prediction_season, "_week_", predicts_week, ".csv")
    )
    audit_path <- file.path(
      output_dir,
      paste0("core_wow_production_audit_", prediction_season, "_week_", predicts_week, ".csv")
    )
    utils::write.csv(master, master_path, row.names = FALSE, na = "")
    utils::write.csv(audit, audit_path, row.names = FALSE, na = "")
    manifest <- data.frame(
      position = c(names(position_paths), "CORE", "CORE"),
      artifact = c(rep("position_production", length(position_paths)), "master_production", "production_audit"),
      output_path = c(unname(position_paths), master_path, audit_path),
      stringsAsFactors = FALSE
    ) |>
      dplyr::mutate(exists = file.exists(.data$output_path))
  } else {
    manifest <- data.frame()
  }
  
  result <- list(
    prediction_season = prediction_season,
    feature_week = feature_week,
    predicts_week = feature_week + 1L,
    positions = results,
    master = master,
    audit = audit,
    manifest = manifest
  )
  assign("core_wow_production", result, envir = .GlobalEnv)
  result
}

# Week 1 is a preseason forecast, so it is trained separately from the
# in-season feature-week runner above. Historical SOS boards supply only
# information available before each season and are joined to actual Week 1.
wow_week1_actual_source_spec <- function(position) {
  position <- toupper(position)
  specs <- list(
    QB = list(path = file.path(model_paths$foundation_output_dir, "qb_clean_weekly_master_2021_2025_regular.csv"), points = "fantasy_points_calc"),
    RB = list(path = file.path(model_paths$foundation_output_dir, "rb_clean_weekly_master_2021_2025_regular.csv"), points = "half_ppr_points"),
    WR = list(path = file.path(model_paths$wow_output_dir, "wr_weekly_feature_base_2021_2025_regular.csv"), points = "half_ppr_points"),
    TE = list(path = file.path(model_paths$wow_output_dir, "te_weekly_feature_base_2021_2025_regular.csv"), points = "half_ppr_points"),
    K = list(path = file.path(model_paths$foundation_output_dir, "k_clean_weekly_master_2021_2025_regular.csv"), points = "fantasy_points_calc"),
    DST = list(path = file.path(model_paths$foundation_output_dir, "dst_clean_weekly_master_2021_2025_regular.csv"), points = "dst_fantasy_points")
  )
  if (!position %in% names(specs)) stop("Unsupported Week 1 position: ", position, call. = FALSE)
  specs[[position]]
}

wow_read_week1_actuals <- function(position) {
  spec <- wow_week1_actual_source_spec(position)
  if (!file.exists(spec$path)) stop("Missing Week 1 actual source: ", spec$path, call. = FALSE)
  raw <- utils::read.csv(spec$path, stringsAsFactors = FALSE, check.names = FALSE)
  if (!all(c("season", "week", "player", spec$points) %in% names(raw))) {
    stop("Week 1 actual source has an unexpected schema: ", spec$path, call. = FALSE)
  }
  
  raw |>
    dplyr::filter(suppressWarnings(as.integer(.data$week)) == 1L) |>
    dplyr::transmute(
      season = suppressWarnings(as.integer(.data$season)),
      player_key = make_player_key(.data$player),
      actual_week1_fp = wow_prob_num(.data[[spec$points]])
    ) |>
    dplyr::group_by(.data$season, .data$player_key) |>
    dplyr::summarise(
      actual_week1_fp = if (any(is.finite(.data$actual_week1_fp))) max(.data$actual_week1_fp, na.rm = TRUE) else NA_real_,
      .groups = "drop"
    )
}

wow_standardize_sos_week1_board <- function(position, df) {
  position <- toupper(position)
  if (position == "DST") {
    return(df |>
             dplyr::transmute(
               position = "DST",
               season = suppressWarnings(as.integer(.data$predict_season)),
               player = as.character(.data$player),
               player_key = make_player_key(.data$player),
               team = normalize_team_abbr(.data$team),
               sos_rank = wow_prob_num(.data$dst_sos_rank),
               sos_tier = as.character(.data$dst_sos_tier),
               sos_final_score = wow_prob_num(.data$dst_sos_final_score),
               sos_board_score = wow_prob_num(.data$dst_sos_final_score),
               preseason_omfg = NA_real_,
               anchor_ppg = wow_prob_num(.data$dst_sos_projected_ppg)
             ))
  }
  
  df |>
    dplyr::transmute(
      position = .env$position,
      season = suppressWarnings(as.integer(.data$season)),
      player = as.character(.data$player),
      player_key = make_player_key(.data$player),
      team = normalize_team_abbr(dplyr::coalesce(.data$next_team, .data$current_team)),
      sos_rank = wow_prob_num(.data$rank),
      sos_tier = as.character(.data$tier),
      sos_final_score = wow_prob_num(.data$final_score),
      sos_board_score = wow_prob_num(.data$board_score),
      preseason_omfg = wow_prob_num(.data$preseason_omfg),
      anchor_ppg = wow_prob_num(.data$anchor_ppg)
    )
}

wow_read_historical_sos_week1_board <- function(position) {
  position <- toupper(position)
  path <- file.path(
    model_paths$sos_output_dir,
    paste0(tolower(position), "_sos_final_export_2022_2025.csv")
  )
  if (!file.exists(path)) stop("Missing historical SOS board for Week 1 training: ", path, call. = FALSE)
  board <- wow_standardize_sos_week1_board(
    position,
    utils::read.csv(path, stringsAsFactors = FALSE, check.names = FALSE)
  )
  actual <- wow_read_week1_actuals(position)
  
  board |>
    dplyr::left_join(actual, by = c("season", "player_key")) |>
    dplyr::mutate(actual_week1_fp = dplyr::coalesce(.data$actual_week1_fp, 0)) |>
    dplyr::group_by(.data$season) |>
    dplyr::mutate(
      field_size = dplyr::n(),
      sos_rank_score_0to100 = wow_prob_rank_score(.data$sos_rank, .data$field_size),
      actual_week1_rank = rank(-.data$actual_week1_fp, ties.method = "min", na.last = "keep")
    ) |>
    dplyr::ungroup()
}

wow_week1_linear_predict <- function(train, test) {
  predictors <- c("sos_rank_score_0to100", "sos_final_score", "sos_board_score", "preseason_omfg", "anchor_ppg")
  train_model <- data.frame(actual_week1_fp = wow_prob_num(train$actual_week1_fp))
  test_model <- data.frame(row_id = seq_len(nrow(test)))
  model_cols <- character()
  
  for (predictor in predictors) {
    train_values <- wow_prob_num(train[[predictor]])
    test_values <- wow_prob_num(test[[predictor]])
    center <- stats::median(train_values[is.finite(train_values)], na.rm = TRUE)
    scale <- stats::mad(train_values[is.finite(train_values)], constant = 1.4826, na.rm = TRUE)
    if (!is.finite(center)) center <- 50
    if (!is.finite(scale) || scale <= 0) scale <- 15
    model_col <- paste0(predictor, "_z")
    train_model[[model_col]] <- (train_values - center) / scale
    test_model[[model_col]] <- (test_values - center) / scale
    train_model[[model_col]][!is.finite(train_model[[model_col]])] <- 0
    test_model[[model_col]][!is.finite(test_model[[model_col]])] <- 0
    model_cols <- c(model_cols, model_col)
  }
  
  keep <- is.finite(train_model$actual_week1_fp)
  if (sum(keep) < 25L) return(rep(NA_real_, nrow(test)))
  fit <- try(
    stats::lm(stats::reformulate(model_cols, response = "actual_week1_fp"), data = train_model[keep, , drop = FALSE]),
    silent = TRUE
  )
  if (inherits(fit, "try-error")) return(rep(NA_real_, nrow(test)))
  prediction <- try(suppressWarnings(stats::predict(fit, newdata = test_model)), silent = TRUE)
  if (inherits(prediction, "try-error")) return(rep(NA_real_, nrow(test)))
  pmax(0, as.numeric(prediction))
}

wow_week1_rank_probability <- function(train_rank_score, target, test_rank_score) {
  train_rank_score <- wow_prob_num(train_rank_score)
  test_rank_score <- wow_prob_num(test_rank_score)
  target <- suppressWarnings(as.integer(target))
  keep <- is.finite(train_rank_score) & !is.na(target)
  base_rate <- mean(target[keep], na.rm = TRUE)
  if (!is.finite(base_rate)) base_rate <- 0
  if (sum(keep) < 25L || length(unique(target[keep])) < 2L) {
    return(wow_prob_clamp(rep(base_rate, length(test_rank_score))))
  }
  
  center <- stats::median(train_rank_score[keep], na.rm = TRUE)
  scale <- stats::mad(train_rank_score[keep], constant = 1.4826, na.rm = TRUE)
  if (!is.finite(scale) || scale <= 0) scale <- 15
  train_model <- data.frame(
    target_outcome = target[keep],
    rank_score_z = (train_rank_score[keep] - center) / scale
  )
  test_model <- data.frame(rank_score_z = (test_rank_score - center) / scale)
  test_model$rank_score_z[!is.finite(test_model$rank_score_z)] <- 0
  fit <- try(
    suppressWarnings(stats::glm(target_outcome ~ rank_score_z, data = train_model, family = stats::binomial())),
    silent = TRUE
  )
  if (inherits(fit, "try-error") || !is.finite(stats::coef(fit)[["rank_score_z"]]) || stats::coef(fit)[["rank_score_z"]] <= 0) {
    return(wow_prob_clamp(rep(base_rate, length(test_rank_score))))
  }
  slope <- min(as.numeric(stats::coef(fit)[["rank_score_z"]]), 2.5)
  intercept <- stats::optimize(
    function(value) {
      fitted_mean <- mean(stats::plogis(value + slope * train_model$rank_score_z))
      (fitted_mean - base_rate)^2
    },
    interval = c(-15, 15)
  )$minimum
  probability <- stats::plogis(intercept + slope * test_model$rank_score_z)
  wow_prob_clamp(as.numeric(probability))
}

wow_week1_candidate_scores <- function(train, test) {
  linear_projection <- wow_week1_linear_predict(train, test)
  linear_score <- qb_wow_percent_rank_0to100(linear_projection, higher_is_better = TRUE)
  rank_score <- wow_prob_num(test$sos_rank_score_0to100)
  
  data.frame(
    sos_rank_only = rank_score,
    preseason_linear = linear_score,
    blend_70_linear_30_sos = 0.70 * linear_score + 0.30 * rank_score,
    projected_week1_fp = linear_projection,
    stringsAsFactors = FALSE
  )
}

run_position_wow_week1_backtest <- function(position) {
  position <- toupper(position)
  frame <- wow_read_historical_sos_week1_board(position)
  seasons <- sort(unique(frame$season[is.finite(frame$season)]))
  rows <- list()
  idx <- 1L
  
  for (test_season in seasons[seasons > min(seasons)]) {
    train <- frame[frame$season < test_season, , drop = FALSE]
    test <- frame[frame$season == test_season, , drop = FALSE]
    scores <- wow_week1_candidate_scores(train, test)
    for (candidate in c("sos_rank_only", "preseason_linear", "blend_70_linear_30_sos")) {
      keep <- is.finite(scores[[candidate]]) & is.finite(test$actual_week1_fp)
      rows[[idx]] <- data.frame(
        position = position,
        test_season = test_season,
        train_seasons = paste(sort(unique(train$season)), collapse = ","),
        candidate = candidate,
        n = sum(keep),
        spearman = if (sum(keep) > 1L) suppressWarnings(stats::cor(scores[[candidate]][keep], test$actual_week1_fp[keep], method = "spearman")) else NA_real_,
        mae = if (candidate == "preseason_linear" && sum(keep) > 0L) mean(abs(scores$projected_week1_fp[keep] - test$actual_week1_fp[keep])) else NA_real_,
        stringsAsFactors = FALSE
      )
      idx <- idx + 1L
    }
  }
  
  metrics <- dplyr::bind_rows(rows)
  summary <- metrics |>
    dplyr::group_by(.data$position, .data$candidate) |>
    dplyr::summarise(
      seasons = dplyr::n(),
      avg_spearman = mean(.data$spearman, na.rm = TRUE),
      min_spearman = min(.data$spearman, na.rm = TRUE),
      combined_score = 0.80 * .data$avg_spearman + 0.20 * .data$min_spearman,
      .groups = "drop"
    ) |>
    dplyr::arrange(dplyr::desc(.data$combined_score), dplyr::desc(.data$avg_spearman))
  
  list(
    position = position,
    frame = frame,
    metrics = metrics,
    summary = summary,
    selected_model = summary$candidate[[1]]
  )
}

wow_week1_tier <- function(position, rank) {
  position <- toupper(position)
  limits <- switch(
    position,
    QB = c(3L, 6L, 12L, 18L),
    RB = c(6L, 12L, 24L, 36L),
    WR = c(12L, 24L, 36L, 48L),
    TE = c(5L, 12L, 18L, 24L),
    K = c(6L, 12L, 18L, 24L),
    DST = c(6L, 12L, 18L, 24L)
  )
  dplyr::case_when(
    rank <= limits[[1]] ~ "Tier 1",
    rank <= limits[[2]] ~ "Tier 2",
    rank <= limits[[3]] ~ "Tier 3",
    rank <= limits[[4]] ~ "Tier 4",
    TRUE ~ "Tier 5"
  )
}

wow_normalize_week1_schedule <- function(schedule, prediction_season) {
  if (is.null(schedule) || nrow(schedule) == 0L) {
    return(data.frame(team = character(), opponent = character(), stringsAsFactors = FALSE))
  }
  if (all(c("home_team", "away_team") %in% names(schedule))) {
    if ("season" %in% names(schedule)) schedule <- schedule[as.integer(schedule$season) == prediction_season, , drop = FALSE]
    if ("week" %in% names(schedule)) schedule <- schedule[as.integer(schedule$week) == 1L, , drop = FALSE]
    return(dplyr::bind_rows(
      data.frame(team = normalize_team_abbr(schedule$home_team), opponent = normalize_team_abbr(schedule$away_team)),
      data.frame(team = normalize_team_abbr(schedule$away_team), opponent = normalize_team_abbr(schedule$home_team))
    ) |>
      dplyr::distinct(.data$team, .keep_all = TRUE))
  }
  if (!all(c("team", "opponent") %in% names(schedule))) {
    stop("week1_schedule must contain team/opponent or home_team/away_team columns.", call. = FALSE)
  }
  schedule |>
    dplyr::transmute(team = normalize_team_abbr(.data$team), opponent = normalize_team_abbr(.data$opponent)) |>
    dplyr::distinct(.data$team, .keep_all = TRUE)
}

wow_default_week1_schedule <- function(prediction_season) {
  prediction_season <- as.integer(prediction_season[[1]])
  if (prediction_season != 2026L) {
    return(data.frame(team = character(), opponent = character(), stringsAsFactors = FALSE))
  }
  
  # Official 2026 NFL Week 1 slate published May 14, 2026.
  # https://www.nfl.com/news/2026-nfl-schedule-release-complete-slate-of-week-1-games
  games <- data.frame(
    away_team = c(
      "NE", "SF", "CHI", "TB", "NO", "BUF", "BAL", "CLE",
      "ATL", "NYJ", "ARI", "MIA", "GB", "WAS", "DAL", "DEN"
    ),
    home_team = c(
      "SEA", "LAR", "CAR", "CIN", "DET", "HOU", "IND", "JAX",
      "PIT", "TEN", "LAC", "LV", "MIN", "PHI", "NYG", "KC"
    ),
    stringsAsFactors = FALSE
  )
  wow_normalize_week1_schedule(games, prediction_season)
}

run_core_wow_week1_production <- function(
    prediction_season = 2026L,
    positions = c("QB", "RB", "WR", "TE", "K", "DST"),
    sos_production_path = file.path(wow_production_output_dir(), paste0("core_sos_production_", prediction_season, ".csv")),
    week1_schedule = NULL,
    write_output = TRUE,
    output_dir = wow_production_output_dir()
) {
  load_model_core_packages()
  prediction_season <- as.integer(prediction_season[[1]])
  positions <- toupper(positions)
  if (!file.exists(sos_production_path)) stop("Missing SOS production board: ", sos_production_path, call. = FALSE)
  sos_production <- utils::read.csv(sos_production_path, stringsAsFactors = FALSE, check.names = FALSE)
  schedule <- if (is.null(week1_schedule)) {
    wow_default_week1_schedule(prediction_season)
  } else {
    wow_normalize_week1_schedule(week1_schedule, prediction_season)
  }
  if (nrow(schedule) == 0L) {
    stop(
      "No Week 1 schedule is available for ", prediction_season,
      ". Supply week1_schedule with team/opponent or home_team/away_team columns.",
      call. = FALSE
    )
  }
  
  position_results <- list()
  backtest_rows <- list()
  tuning_rows <- list()
  
  for (position in positions) {
    historical <- run_position_wow_week1_backtest(position)
    train <- historical$frame
    raw_test <- sos_production[sos_production$position == position, , drop = FALSE]
    if (nrow(raw_test) == 0L) stop("No SOS production rows available for ", position, call. = FALSE)
    
    test <- raw_test |>
      dplyr::transmute(
        position = .env$position,
        season = .env$prediction_season,
        player = as.character(.data$player),
        player_key = make_player_key(.data$player),
        team = normalize_team_abbr(dplyr::coalesce(.data$next_team, .data$current_team)),
        sos_rank = wow_prob_num(.data$rank),
        sos_tier = as.character(.data$tier),
        sos_final_score = wow_prob_num(.data$final_score),
        sos_board_score = wow_prob_num(.data$board_score),
        preseason_omfg = wow_prob_num(.data$preseason_omfg),
        anchor_ppg = wow_prob_num(.data$anchor_ppg)
      ) |>
      dplyr::mutate(
        field_size = dplyr::n(),
        sos_rank_score_0to100 = wow_prob_rank_score(.data$sos_rank, .data$field_size)
      )
    scores <- wow_week1_candidate_scores(train, test)
    selected_model <- historical$selected_model
    selected_score <- scores[[selected_model]]
    projected_fp <- scores$projected_week1_fp
    projected_fp[!is.finite(projected_fp)] <- test$anchor_ppg[!is.finite(projected_fp)]
    
    out <- test |>
      dplyr::mutate(
        production_mode = "preseason_week1",
        feature_week = 0L,
        predicts_week = 1L,
        selected_model = .env$selected_model,
        week1_score = .env$selected_score,
        projected_week1_fp = .env$projected_fp
      ) |>
      dplyr::arrange(dplyr::desc(.data$week1_score), .data$player) |>
      dplyr::mutate(
        rank = dplyr::row_number(),
        tier = wow_week1_tier(.env$position, .data$rank),
        final_score = .data$week1_score,
        weekly_board_score = .data$sos_board_score,
        in_season_omfg = .data$preseason_omfg
      ) |>
      dplyr::left_join(schedule, by = "team")
    
    if (position %in% c("QB", "RB", "WR", "TE")) {
      prob_train <- train |>
        dplyr::transmute(
          rank_score_0to100 = .data$sos_rank_score_0to100,
          actual_week_rank = .data$actual_week1_rank
        )
      prob_test <- out |>
        dplyr::transmute(
          rank_score_0to100 = wow_prob_rank_score(.data$rank, dplyr::n())
        )
      thresholds <- wow_prob_targets(position)
      probability_cols <- character()
      for (target_name in names(thresholds)) {
        outcome_col <- paste0("actual_week_", target_name)
        probability_col <- paste0("prob_week_", target_name)
        prob_train[[outcome_col]] <- ifelse(
          is.finite(prob_train$actual_week_rank),
          as.integer(prob_train$actual_week_rank <= thresholds[[target_name]]),
          NA_integer_
        )
        out[[probability_col]] <- wow_week1_rank_probability(
          prob_train$rank_score_0to100,
          prob_train[[outcome_col]],
          prob_test$rank_score_0to100
        )
        probability_cols <- c(probability_cols, probability_col)
      }
      ordered_targets <- names(sort(unlist(thresholds)))
      out <- wow_prob_enforce_nested(out, paste0("prob_week_", ordered_targets))
    }
    
    position_results[[position]] <- out |>
      dplyr::select(
        dplyr::all_of(c(
          "position", "production_mode", "season", "feature_week", "predicts_week",
          "rank", "tier", "player", "team", "opponent", "selected_model",
          "projected_week1_fp", "final_score", "preseason_omfg", "sos_rank", "sos_tier"
        )),
        dplyr::starts_with("prob_week_")
      )
    backtest_rows[[position]] <- historical$metrics
    tuning_rows[[position]] <- historical$summary |>
      dplyr::mutate(selected_model = .data$candidate == .env$selected_model)
  }
  
  master <- dplyr::bind_rows(position_results) |>
    dplyr::arrange(.data$position, .data$rank)
  backtest <- dplyr::bind_rows(backtest_rows) |>
    dplyr::arrange(.data$position, .data$test_season, .data$candidate)
  tuning <- dplyr::bind_rows(tuning_rows) |>
    dplyr::arrange(.data$position, dplyr::desc(.data$selected_model), dplyr::desc(.data$combined_score))
  audit <- build_core_wow_production_audit(master, prediction_season, feature_week = 0L)
  audit$missing_opponents <- vapply(audit$position, function(position) {
    sum(is.na(master$opponent[master$position == position]) | master$opponent[master$position == position] == "")
  }, integer(1))
  audit$status[audit$missing_opponents > 0L] <- "FAIL"
  if (any(audit$status != "PASS")) stop("Week 1 WOW production audit failed.", call. = FALSE)
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    master_path <- file.path(output_dir, paste0("core_wow_week1_production_", prediction_season, ".csv"))
    audit_path <- file.path(output_dir, paste0("core_wow_week1_production_audit_", prediction_season, ".csv"))
    backtest_path <- file.path(output_dir, paste0("core_wow_week1_backtest_2022_2025.csv"))
    tuning_path <- file.path(output_dir, paste0("core_wow_week1_tuning_2022_2025.csv"))
    schedule_path <- file.path(output_dir, paste0("core_wow_week1_schedule_", prediction_season, ".csv"))
    utils::write.csv(master, master_path, row.names = FALSE, na = "")
    utils::write.csv(audit, audit_path, row.names = FALSE, na = "")
    utils::write.csv(backtest, backtest_path, row.names = FALSE, na = "")
    utils::write.csv(tuning, tuning_path, row.names = FALSE, na = "")
    utils::write.csv(schedule, schedule_path, row.names = FALSE, na = "")
    manifest <- data.frame(
      artifact = c("week1_master", "week1_audit", "week1_backtest", "week1_tuning", "week1_schedule"),
      output_path = c(master_path, audit_path, backtest_path, tuning_path, schedule_path),
      stringsAsFactors = FALSE
    ) |>
      dplyr::mutate(exists = file.exists(.data$output_path))
  } else {
    manifest <- data.frame()
  }
  
  result <- list(
    prediction_season = prediction_season,
    positions = position_results,
    master = master,
    audit = audit,
    backtest = backtest,
    tuning = tuning,
    schedule = schedule,
    manifest = manifest
  )
  assign("core_wow_week1_production", result, envir = .GlobalEnv)
  result
}

message("WOW probability helper: build_core_wow_tier_probabilities()")
message("WOW probability audit: build_core_wow_probability_lift_audit()")
message("WOW probability walk-forward: run_core_wow_probability_walk_forward()")
message("WOW QB probability calibration: build_qb_wow_probability_calibration_profile()")
message("WOW production runner: run_core_wow_production()")
message("WOW Week 1 production runner: run_core_wow_week1_production()")
