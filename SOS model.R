# Standalone season-over-season model script.
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

model_cache <- new.env(parent = emptyenv())

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
      report_status = as.character(.data$report_status),
      practice_status = as.character(.data$practice_status),
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

get_player_bio_reference <- function(file_path = model_paths$all_positions_hybrid_csv) {
  load_model_core_packages()
  
  if (exists("player_bio_reference", envir = model_cache, inherits = FALSE)) {
    return(get("player_bio_reference", envir = model_cache, inherits = FALSE))
  }
  
  raw <- load_all_positions_hybrid(file_path)
  
  player_col_a <- if ("Player" %in% names(raw)) as.character(raw$Player) else rep(NA_character_, nrow(raw))
  player_col_b <- if ("Name" %in% names(raw)) as.character(raw$Name) else rep(NA_character_, nrow(raw))
  player_name <- dplyr::coalesce(player_col_a, player_col_b)
  season <- if ("SEA" %in% names(raw)) safe_integer(raw$SEA) else rep(NA_integer_, nrow(raw))
  age <- if ("age" %in% names(raw)) safe_numeric(raw$age) else rep(NA_real_, nrow(raw))
  rookie_year <- if ("rookie_year" %in% names(raw)) safe_integer(raw$rookie_year) else rep(NA_integer_, nrow(raw))
  birth_date <- if ("birth_date" %in% names(raw)) as.character(raw$birth_date) else rep(NA_character_, nrow(raw))
  draft_day <- if ("Draft_Day" %in% names(raw)) as.character(raw$Draft_Day) else rep(NA_character_, nrow(raw))
  
  ref <- data.frame(
    player_key = make_player_key(player_name),
    season = season,
    age = age,
    rookie_year = rookie_year,
    birth_date = birth_date,
    draft_day = draft_day,
    stringsAsFactors = FALSE
  ) |>
    dplyr::filter(!is.na(.data$player_key), .data$player_key != "")
  
  player_static <- ref |>
    dplyr::group_by(.data$player_key) |>
    dplyr::summarise(
      rookie_year_ref = suppressWarnings(min(.data$rookie_year, na.rm = TRUE)),
      birth_date_ref = first_non_missing(.data$birth_date),
      draft_day_ref = first_non_missing(.data$draft_day),
      .groups = "drop"
    ) |>
    dplyr::mutate(
      rookie_year_ref = ifelse(is.infinite(.data$rookie_year_ref), NA, .data$rookie_year_ref)
    )
  
  player_age_by_season <- ref |>
    dplyr::filter(!is.na(.data$season), !is.na(.data$age)) |>
    dplyr::group_by(.data$player_key, .data$season) |>
    dplyr::summarise(
      age_season_ref = mean(.data$age, na.rm = TRUE),
      .groups = "drop"
    )
  
  player_age_offsets <- ref |>
    dplyr::filter(!is.na(.data$season), !is.na(.data$age)) |>
    dplyr::mutate(age_offset_ref = .data$age - .data$season) |>
    dplyr::group_by(.data$player_key) |>
    dplyr::summarise(
      age_offset_ref = mean(.data$age_offset_ref, na.rm = TRUE),
      .groups = "drop"
    )
  
  out <- list(
    player_static = player_static,
    player_age_by_season = player_age_by_season,
    player_age_offsets = player_age_offsets
  )
  
  assign("player_bio_reference", out, envir = model_cache)
  out
}

fill_player_bio_fields <- function(
    df,
    player_key_col = "player_key",
    season_col = "season",
    age_col = "age",
    rookie_year_col = "rookie_year",
    birth_date_col = "birth_date",
    draft_day_col = "draft_day"
) {
  load_model_core_packages()
  
  refs <- get_player_bio_reference()
  
  static_ref <- refs$player_static
  age_season_ref <- refs$player_age_by_season
  age_offset_ref <- refs$player_age_offsets
  
  names(static_ref)[names(static_ref) == "player_key"] <- player_key_col
  names(age_season_ref)[names(age_season_ref) == "player_key"] <- player_key_col
  names(age_season_ref)[names(age_season_ref) == "season"] <- season_col
  names(age_offset_ref)[names(age_offset_ref) == "player_key"] <- player_key_col
  
  out <- df |>
    dplyr::left_join(static_ref, by = player_key_col) |>
    dplyr::left_join(age_season_ref, by = c(player_key_col, season_col)) |>
    dplyr::left_join(age_offset_ref, by = player_key_col)
  
  season_num <- safe_numeric(out[[season_col]])
  age_current <- safe_numeric(out[[age_col]])
  rookie_year_current <- safe_integer(out[[rookie_year_col]])
  
  age_estimate <- ifelse(
    is.na(season_num) | is.na(out$age_offset_ref),
    NA_real_,
    round(out$age_offset_ref + season_num, 1)
  )
  
  out[[age_col]] <- dplyr::coalesce(age_current, out$age_season_ref, age_estimate)
  out[[rookie_year_col]] <- dplyr::coalesce(rookie_year_current, out$rookie_year_ref)
  
  if (birth_date_col %in% names(out)) {
    birth_date_current <- as.character(out[[birth_date_col]])
    birth_date_current[birth_date_current == ""] <- NA_character_
    out[[birth_date_col]] <- dplyr::coalesce(birth_date_current, out$birth_date_ref)
  }
  
  if (draft_day_col %in% names(out)) {
    draft_day_current <- as.character(out[[draft_day_col]])
    draft_day_current[draft_day_current == ""] <- NA_character_
    out[[draft_day_col]] <- dplyr::coalesce(draft_day_current, out$draft_day_ref)
  }
  
  out |>
    dplyr::select(-dplyr::any_of(c(
      "rookie_year_ref",
      "birth_date_ref",
      "draft_day_ref",
      "age_season_ref",
      "age_offset_ref"
    )))
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
  safe_numeric(pass_yards) / 25 +
    safe_numeric(pass_td) * 4 -
    safe_numeric(interceptions) * 2 +
    safe_numeric(rush_yards) / 10 +
    safe_numeric(rush_td) * 6
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
  
  qb_weekly <- fill_player_bio_fields(qb_weekly)
  
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
    dplyr::arrange(.data$season, .data$player_key, .data$week) |>
    dplyr::group_by(.data$season, .data$player_key, .data$player) |>
    dplyr::summarise(
      team = first_non_missing_character(rev(.data$team)),
      teams_played = paste(unique(.data$team[!is.na(.data$team) & .data$team != ""]), collapse = "/"),
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
  
  duplicate_player_seasons <- out |>
    dplyr::count(.data$season, .data$player_key, name = "dup_n") |>
    dplyr::filter(.data$dup_n > 1L)
  if (nrow(duplicate_player_seasons) > 0) {
    stop("QB player-season table is not unique after aggregation.", call. = FALSE)
  }
  
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

make_qb_sos_output_manifest <- function(qb_sos_result) {
  output_paths <- unname(qb_sos_result$output_paths %||% character())
  output_labels <- names(qb_sos_result$output_paths %||% character())
  
  data.frame(
    output_name = output_labels,
    output_path = output_paths,
    exists = file.exists(output_paths),
    stringsAsFactors = FALSE
  )
}

run_qb_sos_pipeline <- function(write_output = TRUE) {
  load_model_core_packages()
  
  dir.create(model_paths$foundation_output_dir, recursive = TRUE, showWarnings = FALSE)
  dir.create(model_paths$sos_output_dir, recursive = TRUE, showWarnings = FALSE)
  
  qb_sos_result <- build_qb_sos_inputs(write_output = write_output)
  output_manifest <- make_qb_sos_output_manifest(qb_sos_result)
  
  list(
    result = qb_sos_result,
    output_manifest = output_manifest
  )
}


build_qb_sos_target_table <- function(qb_player_season_combined_table = NULL) {
  load_model_core_packages()
  
  if (is.null(qb_player_season_combined_table)) {
    qb_player_season_combined_table <- build_qb_player_season_combined_table(write_output = FALSE)
  }
  
  qb_player_season_combined_table |>
    dplyr::group_by(season) |>
    dplyr::arrange(
      dplyr::desc(fantasy_points),
      dplyr::desc(fantasy_points_per_game),
      player,
      .by_group = TRUE
    ) |>
    dplyr::mutate(
      target_next_points_rank_all = dplyr::row_number(),
      next_top3_points_all = as.integer(target_next_points_rank_all <= 3),
      next_top6_points_all = as.integer(target_next_points_rank_all <= 6),
      next_top12_points_all = as.integer(target_next_points_rank_all <= 12),
      next_top18_points_all = as.integer(target_next_points_rank_all <= 18)
    ) |>
    dplyr::ungroup() |>
    dplyr::transmute(
      player_key,
      target_next_season = season,
      target_next_team = team,
      target_next_games = games,
      target_next_starter_weeks = starter_weeks,
      target_next_best_depth_team = best_depth_team,
      target_next_total_points = fantasy_points,
      target_next_ppg = fantasy_points_per_game,
      target_next_points_sd = fantasy_points_sd,
      target_next_floor_p25 = weekly_floor_p25,
      target_next_median_p50 = weekly_median_p50,
      target_next_ceiling_p75 = weekly_ceiling_p75,
      target_next_ceiling_p90 = weekly_ceiling_p90,
      target_next_pass_attempts = pass_attempts,
      target_next_pass_yards = pass_yards,
      target_next_pass_td = pass_td,
      target_next_interceptions = interceptions,
      target_next_rush_attempts = rush_attempts,
      target_next_rush_yards = rush_yards,
      target_next_rush_td = rush_td,
      target_next_points_rank_all,
      next_top3_points_all,
      next_top6_points_all,
      next_top12_points_all,
      next_top18_points_all,
      qualified_4_games_next = as.integer(target_next_games >= 4),
      qualified_8_games_next = as.integer(target_next_games >= 8)
    )
}

build_qb_sos_training_frame <- function(
    write_output = FALSE,
    output_dir = model_paths$sos_output_dir,
    max_source_season = 2024L
) {
  load_model_core_packages()
  
  qb_player_season_combined_table <- build_qb_player_season_combined_table(write_output = FALSE)
  qb_sos_target_table <- build_qb_sos_target_table(qb_player_season_combined_table)
  
  out <- qb_player_season_combined_table |>
    dplyr::mutate(
      target_next_season = next_season,
      qualified_4_games_current = as.integer(games >= 4),
      qualified_8_games_current = as.integer(games >= 8),
      starter_rate = safe_div(starter_weeks, games),
      pass_attempts_per_game = safe_div(pass_attempts, games),
      completions_per_game = safe_div(completions, games),
      pass_yards_per_game_calc = safe_div(pass_yards, games),
      pass_td_per_game = safe_div(pass_td, games),
      interceptions_per_game = safe_div(interceptions, games),
      rush_attempts_per_game = safe_div(rush_attempts, games),
      rush_yards_per_game_calc = safe_div(rush_yards, games),
      rush_td_per_game = safe_div(rush_td, games)
    ) |>
    dplyr::left_join(
      qb_sos_target_table,
      by = c("player_key", "target_next_season"),
      relationship = "many-to-one"
    ) |>
    dplyr::mutate(
      made_next_season = as.integer(!is.na(target_next_ppg)),
      team_changed_next_season = dplyr::if_else(
        !is.na(target_next_team) & team != target_next_team,
        1L,
        0L,
        missing = 0L
      )
    ) |>
    dplyr::filter(season >= 2021, season <= .env$max_source_season) |>
    dplyr::arrange(season, dplyr::desc(fantasy_points_per_game), player)
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "qb_sos_training_frame_2021_2024_to_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

make_qb_sos_training_manifest <- function(
    output_path = file.path(model_paths$sos_output_dir, "qb_sos_training_frame_2021_2024_to_2022_2025.csv")
) {
  data.frame(
    output_name = "qb_sos_training_frame",
    output_path = output_path,
    exists = file.exists(output_path),
    stringsAsFactors = FALSE
  )
}

run_qb_sos_training_step <- function(write_output = TRUE) {
  load_model_core_packages()
  
  dir.create(model_paths$sos_output_dir, recursive = TRUE, showWarnings = FALSE)
  
  qb_sos_training_frame <- build_qb_sos_training_frame(write_output = write_output)
  
  list(
    qb_sos_training_frame = qb_sos_training_frame,
    output_manifest = make_qb_sos_training_manifest()
  )
}
# QB season-over-season training tables

# -------------------- QB SOS baseline models --------------------

calc_regression_metrics <- function(actual, predicted) {
  keep <- is.finite(actual) & is.finite(predicted)
  
  if (sum(keep) == 0) {
    return(
      data.frame(
        n = 0L,
        mae = NA_real_,
        rmse = NA_real_,
        spearman = NA_real_,
        stringsAsFactors = FALSE
      )
    )
  }
  
  actual <- actual[keep]
  predicted <- predicted[keep]
  
  data.frame(
    n = length(actual),
    mae = mean(abs(actual - predicted)),
    rmse = sqrt(mean((actual - predicted)^2)),
    spearman = if (length(actual) > 1) suppressWarnings(stats::cor(actual, predicted, method = "spearman")) else NA_real_,
    stringsAsFactors = FALSE
  )
}

impute_numeric_medians <- function(train_df, test_df, cols) {
  cols <- intersect(cols, names(train_df))
  cols <- intersect(cols, names(test_df))
  
  for (col in cols) {
    med_val <- suppressWarnings(stats::median(train_df[[col]], na.rm = TRUE))
    if (!is.finite(med_val)) {
      med_val <- 0
    }
    
    train_df[[col]][!is.finite(train_df[[col]])] <- med_val
    test_df[[col]][!is.finite(test_df[[col]])] <- med_val
  }
  
  list(train = train_df, test = test_df)
}

build_qb_sos_baseline_feature_set <- function(qb_sos_training_frame = NULL) {
  load_model_core_packages()
  
  if (is.null(qb_sos_training_frame)) {
    qb_sos_training_frame <- build_qb_sos_training_frame(write_output = FALSE)
  }
  
  predictor_cols <- c(
    "games",
    "starter_weeks",
    "best_depth_team",
    "age",
    "rookie_year",
    "fantasy_points",
    "fantasy_points_per_game",
    "fantasy_points_sd",
    "weekly_floor_p25",
    "weekly_median_p50",
    "weekly_ceiling_p75",
    "weekly_ceiling_p90",
    "pass_attempts",
    "completions",
    "pass_yards",
    "pass_td",
    "interceptions",
    "sacks",
    "rush_attempts",
    "rush_yards",
    "rush_td",
    "pass_attempt_share_mean",
    "pass_yards_share_mean",
    "pass_td_share_mean",
    "rush_attempt_share_mean",
    "rush_yards_share_mean",
    "fantasy_point_share_mean",
    "any_a_mean",
    "cpoe_mean",
    "pass_roe_mean",
    "pressure_pct_mean",
    "starter_rate",
    "pass_attempts_per_game",
    "completions_per_game",
    "pass_yards_per_game_calc",
    "pass_td_per_game",
    "interceptions_per_game",
    "rush_attempts_per_game",
    "rush_yards_per_game_calc",
    "rush_td_per_game",
    "qualified_4_games_current",
    "qualified_8_games_current",
    "team_changed_next_season"
  )
  
  predictor_cols <- intersect(predictor_cols, names(qb_sos_training_frame))
  
  qb_sos_training_frame |>
    dplyr::mutate(
      dplyr::across(dplyr::all_of(predictor_cols), safe_numeric),
      target_next_ppg = safe_numeric(target_next_ppg),
      target_next_total_points = safe_numeric(target_next_total_points),
      qualified_4_games_next = safe_numeric(qualified_4_games_next),
      qualified_8_games_next = safe_numeric(qualified_8_games_next)
    )
}

run_qb_sos_baseline_model_step <- function(
    write_output = TRUE,
    output_dir = model_paths$sos_output_dir
) {
  load_model_core_packages()
  
  model_df <- build_qb_sos_baseline_feature_set()
  
  predictor_cols <- c(
    "games",
    "starter_weeks",
    "best_depth_team",
    "age",
    "rookie_year",
    "fantasy_points",
    "fantasy_points_per_game",
    "fantasy_points_sd",
    "weekly_floor_p25",
    "weekly_median_p50",
    "weekly_ceiling_p75",
    "weekly_ceiling_p90",
    "pass_attempts",
    "completions",
    "pass_yards",
    "pass_td",
    "interceptions",
    "sacks",
    "rush_attempts",
    "rush_yards",
    "rush_td",
    "pass_attempt_share_mean",
    "pass_yards_share_mean",
    "pass_td_share_mean",
    "rush_attempt_share_mean",
    "rush_yards_share_mean",
    "fantasy_point_share_mean",
    "any_a_mean",
    "cpoe_mean",
    "pass_roe_mean",
    "pressure_pct_mean",
    "starter_rate",
    "pass_attempts_per_game",
    "completions_per_game",
    "pass_yards_per_game_calc",
    "pass_td_per_game",
    "interceptions_per_game",
    "rush_attempts_per_game",
    "rush_yards_per_game_calc",
    "rush_td_per_game",
    "qualified_4_games_current",
    "qualified_8_games_current",
    "team_changed_next_season"
  )
  
  predictor_cols <- intersect(predictor_cols, names(model_df))
  
  predict_seasons <- sort(unique(model_df$target_next_season))
  predict_seasons <- predict_seasons[predict_seasons >= 2022 & predict_seasons <= 2025]
  
  prediction_list <- list()
  metric_list <- list()
  pred_idx <- 1L
  metric_idx <- 1L
  
  for (predict_season in predict_seasons) {
    train_df <- model_df |>
      dplyr::filter(
        target_next_season < predict_season,
        !is.na(target_next_ppg),
        !is.na(target_next_total_points)
      )
    
    test_df <- model_df |>
      dplyr::filter(
        target_next_season == predict_season,
        !is.na(target_next_ppg),
        !is.na(target_next_total_points)
      )
    
    if (nrow(train_df) == 0 || nrow(test_df) == 0) {
      next
    }
    
    imputed <- impute_numeric_medians(train_df, test_df, predictor_cols)
    train_df <- imputed$train
    test_df <- imputed$test
    
    ppg_formula <- stats::reformulate(predictor_cols, response = "target_next_ppg")
    total_formula <- stats::reformulate(predictor_cols, response = "target_next_total_points")
    
    ppg_model <- stats::lm(ppg_formula, data = train_df)
    total_model <- stats::lm(total_formula, data = train_df)
    
    pred_next_ppg <- as.numeric(stats::predict(ppg_model, newdata = test_df))
    pred_next_total_points <- as.numeric(stats::predict(total_model, newdata = test_df))
    
    fold_predictions <- test_df |>
      dplyr::transmute(
        train_through_season = predict_season - 1L,
        predict_season = target_next_season,
        source_season = season,
        player_key,
        player,
        current_team = team,
        next_team = target_next_team,
        target_next_games,
        qualified_4_games_current,
        qualified_8_games_current,
        qualified_4_games_next,
        qualified_8_games_next,
        target_next_ppg,
        pred_next_ppg,
        target_next_total_points,
        pred_next_total_points
      )
    
    prediction_list[[pred_idx]] <- fold_predictions
    pred_idx <- pred_idx + 1L
    
    overall_ppg <- calc_regression_metrics(fold_predictions$target_next_ppg, fold_predictions$pred_next_ppg)
    overall_ppg$predict_season <- predict_season
    overall_ppg$target <- "target_next_ppg"
    overall_ppg$sample <- "overall"
    metric_list[[metric_idx]] <- overall_ppg
    metric_idx <- metric_idx + 1L
    
    overall_total <- calc_regression_metrics(fold_predictions$target_next_total_points, fold_predictions$pred_next_total_points)
    overall_total$predict_season <- predict_season
    overall_total$target <- "target_next_total_points"
    overall_total$sample <- "overall"
    metric_list[[metric_idx]] <- overall_total
    metric_idx <- metric_idx + 1L
    
    keep_4_4 <- fold_predictions$qualified_4_games_current == 1 & fold_predictions$qualified_4_games_next == 1
    
    qual_ppg <- calc_regression_metrics(
      fold_predictions$target_next_ppg[keep_4_4],
      fold_predictions$pred_next_ppg[keep_4_4]
    )
    qual_ppg$predict_season <- predict_season
    qual_ppg$target <- "target_next_ppg"
    qual_ppg$sample <- "qualified_4_4"
    metric_list[[metric_idx]] <- qual_ppg
    metric_idx <- metric_idx + 1L
    
    qual_total <- calc_regression_metrics(
      fold_predictions$target_next_total_points[keep_4_4],
      fold_predictions$pred_next_total_points[keep_4_4]
    )
    qual_total$predict_season <- predict_season
    qual_total$target <- "target_next_total_points"
    qual_total$sample <- "qualified_4_4"
    metric_list[[metric_idx]] <- qual_total
    metric_idx <- metric_idx + 1L
  }
  
  predictions <- dplyr::bind_rows(prediction_list)
  metrics <- dplyr::bind_rows(metric_list) |>
    dplyr::select(predict_season, target, sample, n, mae, rmse, spearman) |>
    dplyr::arrange(predict_season, target, sample)
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    
    utils::write.csv(
      predictions,
      file.path(output_dir, "qb_sos_baseline_predictions_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    
    utils::write.csv(
      metrics,
      file.path(output_dir, "qb_sos_baseline_metrics_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    predictions = predictions,
    metrics = metrics
  )
}

#two year frame

build_qb_sos_weighted_two_year_frame <- function() {
  load_model_core_packages()
  
  qb_weekly <- build_qb_clean_weekly_master(write_output = FALSE) |>
    dplyr::filter(position == "QB") |>
    dplyr::arrange(player_key, season, week, game_number)
  
  qb_season <- qb_weekly |>
    dplyr::group_by(season, player_key) |>
    dplyr::summarise(
      player = first_non_missing(rev(player)),
      team = first_non_missing(rev(team)),
      games = dplyr::n_distinct(week[!is.na(week)]),
      starter_weeks = sum(!is.na(depth_team) & depth_team <= 1, na.rm = TRUE),
      best_depth_team = suppressWarnings(min(depth_team, na.rm = TRUE)),
      age = suppressWarnings(max(age, na.rm = TRUE)),
      rookie_year = suppressWarnings(min(rookie_year, na.rm = TRUE)),
      fantasy_points = sum(fantasy_points_calc, na.rm = TRUE),
      fantasy_points_per_game = ifelse(
        sum(!is.na(fantasy_points_calc)) > 0,
        mean(fantasy_points_calc, na.rm = TRUE),
        NA_real_
      ),
      .groups = "drop"
    ) |>
    dplyr::mutate(
      best_depth_team = ifelse(is.infinite(best_depth_team), NA, best_depth_team),
      age = ifelse(is.infinite(age), NA, age),
      rookie_year = ifelse(is.infinite(rookie_year), NA, rookie_year),
      qualified_4_games_current = as.integer(games >= 4),
      qualified_8_games_current = as.integer(games >= 8)
    )
  
  qb_target_frame <- qb_season |>
    dplyr::transmute(
      player_key,
      target_next_season = season,
      target_next_team = team,
      target_next_games = games,
      target_next_ppg = fantasy_points_per_game,
      target_next_total_points = fantasy_points,
      qualified_4_games_next = as.integer(games >= 4),
      qualified_8_games_next = as.integer(games >= 8)
    )
  
  qb_prior_frame <- qb_season |>
    dplyr::transmute(
      player_key,
      season = season + 1L,
      prior_ppg = fantasy_points_per_game,
      prior_total_points = fantasy_points
    )
  
  qb_season |>
    dplyr::mutate(
      target_next_season = season + 1L
    ) |>
    dplyr::left_join(
      qb_target_frame,
      by = c("player_key", "target_next_season"),
      relationship = "many-to-one"
    ) |>
    dplyr::left_join(
      qb_prior_frame,
      by = c("player_key", "season"),
      relationship = "many-to-one"
    ) |>
    dplyr::mutate(
      weighted_two_year_ppg = dplyr::case_when(
        !is.na(fantasy_points_per_game) & !is.na(prior_ppg) ~ 0.65 * fantasy_points_per_game + 0.35 * prior_ppg,
        !is.na(fantasy_points_per_game) ~ fantasy_points_per_game,
        TRUE ~ prior_ppg
      ),
      weighted_two_year_total_points = dplyr::case_when(
        !is.na(fantasy_points) & !is.na(prior_total_points) ~ 0.65 * fantasy_points + 0.35 * prior_total_points,
        !is.na(fantasy_points) ~ fantasy_points,
        TRUE ~ prior_total_points
      )
    ) |>
    dplyr::filter(
      target_next_season >= 2022,
      target_next_season <= 2025,
      !is.na(target_next_ppg),
      !is.na(target_next_total_points)
    ) |>
    dplyr::arrange(target_next_season, dplyr::desc(weighted_two_year_ppg), player)
}

run_qb_sos_weighted_two_year_baseline <- function(write_output = TRUE, output_dir = model_paths$sos_output_dir) {
  load_model_core_packages()
  
  predictions <- build_qb_sos_weighted_two_year_frame() |>
    dplyr::transmute(
      predict_season = target_next_season,
      source_season = season,
      player_key,
      player,
      current_team = team,
      next_team = target_next_team,
      qualified_4_games_current,
      qualified_8_games_current,
      qualified_4_games_next,
      qualified_8_games_next,
      target_next_ppg,
      pred_next_ppg = weighted_two_year_ppg,
      target_next_total_points,
      pred_next_total_points = weighted_two_year_total_points
    )
  
  metric_list <- list()
  idx <- 1L
  
  for (predict_season in sort(unique(predictions$predict_season))) {
    fold_df <- predictions |>
      dplyr::filter(predict_season == .env$predict_season)
    
    overall_ppg <- calc_regression_metrics(fold_df$target_next_ppg, fold_df$pred_next_ppg)
    overall_ppg$predict_season <- predict_season
    overall_ppg$target <- "target_next_ppg"
    overall_ppg$sample <- "overall"
    metric_list[[idx]] <- overall_ppg
    idx <- idx + 1L
    
    qual_df <- fold_df |>
      dplyr::filter(qualified_4_games_current == 1, qualified_4_games_next == 1)
    
    qual_ppg <- calc_regression_metrics(qual_df$target_next_ppg, qual_df$pred_next_ppg)
    qual_ppg$predict_season <- predict_season
    qual_ppg$target <- "target_next_ppg"
    qual_ppg$sample <- "qualified_4_4"
    metric_list[[idx]] <- qual_ppg
    idx <- idx + 1L
    
    overall_total <- calc_regression_metrics(fold_df$target_next_total_points, fold_df$pred_next_total_points)
    overall_total$predict_season <- predict_season
    overall_total$target <- "target_next_total_points"
    overall_total$sample <- "overall"
    metric_list[[idx]] <- overall_total
    idx <- idx + 1L
    
    qual_total <- calc_regression_metrics(qual_df$target_next_total_points, qual_df$pred_next_total_points)
    qual_total$predict_season <- predict_season
    qual_total$target <- "target_next_total_points"
    qual_total$sample <- "qualified_4_4"
    metric_list[[idx]] <- qual_total
    idx <- idx + 1L
  }
  
  metrics <- dplyr::bind_rows(metric_list) |>
    dplyr::select(predict_season, target, sample, n, mae, rmse, spearman) |>
    dplyr::arrange(predict_season, target, sample)
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    
    utils::write.csv(
      predictions,
      file.path(output_dir, "qb_sos_weighted_two_year_predictions_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    
    utils::write.csv(
      metrics,
      file.path(output_dir, "qb_sos_weighted_two_year_metrics_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    predictions = predictions,
    metrics = metrics
  )
}


# -------------------- QB SOS hybrid comparator --------------------

run_qb_sos_hybrid_baseline <- function(
    qb_sos_baseline,
    qb_sos_weighted,
    write_output = TRUE,
    output_dir = model_paths$sos_output_dir
) {
  load_model_core_packages()
  
  hybrid_predictions <- qb_sos_weighted$predictions |>
    dplyr::left_join(
      qb_sos_baseline$predictions |>
        dplyr::select(
          predict_season,
          player_key,
          pred_next_ppg_linear = pred_next_ppg,
          pred_next_total_points_linear = pred_next_total_points
        ),
      by = c("predict_season", "player_key")
    ) |>
    dplyr::mutate(
      pred_next_ppg = 0.70 * pred_next_ppg + 0.30 * pred_next_ppg_linear,
      pred_next_total_points = 0.70 * pred_next_total_points + 0.30 * pred_next_total_points_linear
    )
  
  metric_list <- list()
  idx <- 1L
  
  for (predict_season in sort(unique(hybrid_predictions$predict_season))) {
    fold_df <- hybrid_predictions |>
      dplyr::filter(predict_season == .env$predict_season)
    
    overall_ppg <- calc_regression_metrics(fold_df$target_next_ppg, fold_df$pred_next_ppg)
    overall_ppg$predict_season <- predict_season
    overall_ppg$target <- "target_next_ppg"
    overall_ppg$sample <- "overall"
    metric_list[[idx]] <- overall_ppg
    idx <- idx + 1L
    
    qual_df <- fold_df |>
      dplyr::filter(qualified_4_games_current == 1, qualified_4_games_next == 1)
    
    qual_ppg <- calc_regression_metrics(qual_df$target_next_ppg, qual_df$pred_next_ppg)
    qual_ppg$predict_season <- predict_season
    qual_ppg$target <- "target_next_ppg"
    qual_ppg$sample <- "qualified_4_4"
    metric_list[[idx]] <- qual_ppg
    idx <- idx + 1L
    
    overall_total <- calc_regression_metrics(fold_df$target_next_total_points, fold_df$pred_next_total_points)
    overall_total$predict_season <- predict_season
    overall_total$target <- "target_next_total_points"
    overall_total$sample <- "overall"
    metric_list[[idx]] <- overall_total
    idx <- idx + 1L
    
    qual_total <- calc_regression_metrics(qual_df$target_next_total_points, qual_df$pred_next_total_points)
    qual_total$predict_season <- predict_season
    qual_total$target <- "target_next_total_points"
    qual_total$sample <- "qualified_4_4"
    metric_list[[idx]] <- qual_total
    idx <- idx + 1L
  }
  
  hybrid_metrics <- dplyr::bind_rows(metric_list) |>
    dplyr::select(predict_season, target, sample, n, mae, rmse, spearman) |>
    dplyr::arrange(predict_season, target, sample)
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    
    utils::write.csv(
      hybrid_predictions,
      file.path(output_dir, "qb_sos_hybrid_baseline_predictions_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    
    utils::write.csv(
      hybrid_metrics,
      file.path(output_dir, "qb_sos_hybrid_baseline_metrics_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    predictions = hybrid_predictions,
    metrics = hybrid_metrics
  )
}

compare_qb_sos_all_models <- function(qb_sos_baseline, qb_sos_weighted, qb_sos_hybrid) {
  dplyr::bind_rows(
    qb_sos_baseline$metrics |>
      dplyr::mutate(model = "linear_baseline"),
    qb_sos_weighted$metrics |>
      dplyr::mutate(model = "weighted_two_year"),
    qb_sos_hybrid$metrics |>
      dplyr::mutate(model = "hybrid_70_30")
  ) |>
    dplyr::select(model, predict_season, target, sample, n, mae, rmse, spearman) |>
    dplyr::arrange(target, sample, predict_season, model)
}


# -------------------- QB SOS locked anchor --------------------

build_qb_sos_anchor_predictions <- function(
    qb_sos_weighted,
    qb_sos_hybrid,
    write_output = TRUE,
    output_dir = model_paths$sos_output_dir
) {
  load_model_core_packages()
  
  weighted_df <- qb_sos_weighted$predictions |>
    dplyr::rename(
      weighted_pred_next_ppg = pred_next_ppg,
      weighted_pred_next_total_points = pred_next_total_points
    )
  
  hybrid_df <- qb_sos_hybrid$predictions |>
    dplyr::rename(
      hybrid_pred_next_ppg = pred_next_ppg,
      hybrid_pred_next_total_points = pred_next_total_points
    )
  
  out <- dplyr::full_join(
    weighted_df,
    hybrid_df,
    by = c(
      "predict_season",
      "source_season",
      "player_key",
      "player",
      "current_team",
      "next_team",
      "qualified_4_games_current",
      "qualified_8_games_current",
      "qualified_4_games_next",
      "qualified_8_games_next",
      "target_next_ppg",
      "target_next_total_points"
    )
  ) |>
    dplyr::mutate(
      qb_sos_anchor_ppg = dplyr::coalesce(
        hybrid_pred_next_ppg,
        weighted_pred_next_ppg
      ),
      qb_sos_anchor_total_points = dplyr::coalesce(
        weighted_pred_next_total_points,
        hybrid_pred_next_total_points
      ),
      qb_sos_anchor_model_ppg = dplyr::if_else(
        !is.na(hybrid_pred_next_ppg),
        "hybrid_70_30",
        "weighted_two_year"
      ),
      qb_sos_anchor_model_total_points = dplyr::if_else(
        !is.na(weighted_pred_next_total_points),
        "weighted_two_year",
        "hybrid_70_30"
      )
    ) |>
    dplyr::arrange(
      predict_season,
      dplyr::desc(qb_sos_anchor_ppg),
      player
    )
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    
    utils::write.csv(
      out,
      file.path(output_dir, "qb_sos_anchor_predictions_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_qb_sos_anchor_metrics <- function(qb_sos_anchor_predictions) {
  load_model_core_packages()
  
  metric_list <- list()
  idx <- 1L
  
  for (predict_season in sort(unique(qb_sos_anchor_predictions$predict_season))) {
    fold_df <- qb_sos_anchor_predictions |>
      dplyr::filter(predict_season == .env$predict_season)
    
    overall_ppg <- calc_regression_metrics(
      fold_df$target_next_ppg,
      fold_df$qb_sos_anchor_ppg
    )
    overall_ppg$predict_season <- predict_season
    overall_ppg$target <- "target_next_ppg"
    overall_ppg$sample <- "overall"
    metric_list[[idx]] <- overall_ppg
    idx <- idx + 1L
    
    qual_df <- fold_df |>
      dplyr::filter(qualified_4_games_current == 1, qualified_4_games_next == 1)
    
    qual_ppg <- calc_regression_metrics(
      qual_df$target_next_ppg,
      qual_df$qb_sos_anchor_ppg
    )
    qual_ppg$predict_season <- predict_season
    qual_ppg$target <- "target_next_ppg"
    qual_ppg$sample <- "qualified_4_4"
    metric_list[[idx]] <- qual_ppg
    idx <- idx + 1L
    
    overall_total <- calc_regression_metrics(
      fold_df$target_next_total_points,
      fold_df$qb_sos_anchor_total_points
    )
    overall_total$predict_season <- predict_season
    overall_total$target <- "target_next_total_points"
    overall_total$sample <- "overall"
    metric_list[[idx]] <- overall_total
    idx <- idx + 1L
    
    qual_total <- calc_regression_metrics(
      qual_df$target_next_total_points,
      qual_df$qb_sos_anchor_total_points
    )
    qual_total$predict_season <- predict_season
    qual_total$target <- "target_next_total_points"
    qual_total$sample <- "qualified_4_4"
    metric_list[[idx]] <- qual_total
    idx <- idx + 1L
  }
  
  dplyr::bind_rows(metric_list) |>
    dplyr::select(predict_season, target, sample, n, mae, rmse, spearman) |>
    dplyr::arrange(predict_season, target, sample)
}

run_qb_sos_anchor_step <- function(qb_sos_weighted, qb_sos_hybrid, write_output = TRUE) {
  load_model_core_packages()
  
  qb_sos_anchor_predictions <- build_qb_sos_anchor_predictions(
    qb_sos_weighted = qb_sos_weighted,
    qb_sos_hybrid = qb_sos_hybrid,
    write_output = write_output
  )
  
  qb_sos_anchor_metrics <- build_qb_sos_anchor_metrics(qb_sos_anchor_predictions)
  
  if (write_output) {
    utils::write.csv(
      qb_sos_anchor_metrics,
      file.path(model_paths$sos_output_dir, "qb_sos_anchor_metrics_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    predictions = qb_sos_anchor_predictions,
    metrics = qb_sos_anchor_metrics
  )
}


# -------------------- QB SOS feature-family overlay --------------------

qb_rank_to_0_100 <- function(x, higher_is_better = TRUE) {
  x <- safe_numeric(x)
  out <- rep(NA_real_, length(x))
  keep <- is.finite(x)
  
  if (sum(keep) == 0) {
    return(out)
  }
  
  vals <- if (higher_is_better) x[keep] else -x[keep]
  
  if (sum(keep) == 1) {
    out[keep] <- 50
    return(out)
  }
  
  r <- rank(vals, ties.method = "average", na.last = "keep")
  out[keep] <- 100 * (r - 1) / (sum(keep) - 1)
  out
}

qb_row_mean <- function(...) {
  mat <- cbind(...)
  out <- rowMeans(mat, na.rm = TRUE)
  out[rowSums(is.finite(mat)) == 0] <- NA_real_
  out
}

qb_age_window_score <- function(age_vec) {
  age_vec <- safe_numeric(age_vec)
  out <- 100 - pmin(abs(age_vec - 29) * 8, 100)
  out[!is.finite(age_vec)] <- NA_real_
  out
}

build_qb_sos_feature_overlay_table <- function(qb_sos_anchor, max_source_season = 2024L) {
  load_model_core_packages()
  
  qb_anchor_predictions <- if (is.list(qb_sos_anchor) && "predictions" %in% names(qb_sos_anchor)) {
    qb_sos_anchor$predictions
  } else {
    qb_sos_anchor
  }
  
  qb_train <- build_qb_sos_training_frame(
    write_output = FALSE,
    max_source_season = max_source_season
  )
  
  out <- qb_train |>
    dplyr::left_join(
      qb_anchor_predictions |>
        dplyr::select(
          predict_season,
          source_season,
          player_key,
          qb_sos_anchor_ppg,
          qb_sos_anchor_total_points,
          qb_sos_anchor_model_ppg,
          qb_sos_anchor_model_total_points
        ),
      by = c(
        "target_next_season" = "predict_season",
        "season" = "source_season",
        "player_key" = "player_key"
      ),
      relationship = "many-to-one"
    ) |>
    dplyr::mutate(
      starter_rate = dplyr::coalesce(starter_rate, safe_div(starter_weeks, games)),
      pass_td_per_game = dplyr::coalesce(pass_td_per_game, safe_div(pass_td, games)),
      rush_td_per_game = dplyr::coalesce(rush_td_per_game, safe_div(rush_td, games)),
      
      production_component_0to100 = qb_row_mean(
        qb_rank_to_0_100(fantasy_points_per_game),
        qb_rank_to_0_100(fantasy_points),
        qb_rank_to_0_100(pass_yards_per_game_calc),
        qb_rank_to_0_100(pass_td_per_game)
      ),
      
      range_profile_component_0to100 = qb_row_mean(
        qb_rank_to_0_100(weekly_floor_p25),
        qb_rank_to_0_100(weekly_median_p50),
        qb_rank_to_0_100(weekly_ceiling_p75),
        qb_rank_to_0_100(weekly_ceiling_p90),
        qb_rank_to_0_100(fantasy_points_sd, higher_is_better = FALSE)
      ),
      
      volume_opportunity_component_0to100 = qb_row_mean(
        qb_rank_to_0_100(pass_attempts_per_game),
        qb_rank_to_0_100(pass_attempt_share_mean),
        qb_rank_to_0_100(pass_yards_share_mean),
        qb_rank_to_0_100(pass_td_share_mean)
      ),
      
      starter_security_component_0to100 = qb_row_mean(
        qb_rank_to_0_100(starter_weeks),
        qb_rank_to_0_100(starter_rate),
        qb_rank_to_0_100(best_depth_team, higher_is_better = FALSE),
        qb_rank_to_0_100(games)
      ),
      
      rushing_archetype_component_0to100 = qb_row_mean(
        qb_rank_to_0_100(rush_attempts_per_game),
        qb_rank_to_0_100(rush_yards_per_game_calc),
        qb_rank_to_0_100(rush_td_per_game),
        qb_rank_to_0_100(rush_yards_share_mean)
      ),
      
      development_durability_component_0to100 = qb_row_mean(
        qb_age_window_score(age),
        qb_rank_to_0_100(games),
        qb_rank_to_0_100(starter_weeks)
      ),
      
      regressed_efficiency_component_0to100 = qb_row_mean(
        qb_rank_to_0_100(any_a_mean),
        qb_rank_to_0_100(cpoe_mean),
        qb_rank_to_0_100(pass_roe_mean),
        qb_rank_to_0_100(pressure_pct_mean, higher_is_better = FALSE)
      ),
      
      qb_preseason_omfg_score = (
        0.25 * production_component_0to100 +
          0.30 * range_profile_component_0to100 +
          0.18 * starter_security_component_0to100 +
          0.10 * volume_opportunity_component_0to100 +
          0.10 * rushing_archetype_component_0to100 +
          0.05 * development_durability_component_0to100 +
          0.02 * regressed_efficiency_component_0to100
      ),
      
      qb_anchor_board_score = qb_row_mean(
        qb_rank_to_0_100(qb_sos_anchor_ppg),
        qb_rank_to_0_100(qb_sos_anchor_total_points),
        qb_preseason_omfg_score
      )
    ) |>
    dplyr::arrange(target_next_season, dplyr::desc(qb_anchor_board_score), player)
  
  out
}

build_qb_sos_feature_overlay_metrics <- function(qb_sos_feature_overlay) {
  load_model_core_packages()
  
  feature_cols <- c(
    "production_component_0to100",
    "range_profile_component_0to100",
    "volume_opportunity_component_0to100",
    "starter_security_component_0to100",
    "rushing_archetype_component_0to100",
    "development_durability_component_0to100",
    "regressed_efficiency_component_0to100",
    "qb_preseason_omfg_score",
    "qb_anchor_board_score",
    "qb_sos_anchor_ppg",
    "qb_sos_anchor_total_points"
  )
  
  metric_rows <- list()
  idx <- 1L
  
  for (feature_col in feature_cols) {
    keep_ppg <- is.finite(qb_sos_feature_overlay[[feature_col]]) & is.finite(qb_sos_feature_overlay$target_next_ppg)
    
    metric_rows[[idx]] <- data.frame(
      feature = feature_col,
      target = "target_next_ppg",
      n = sum(keep_ppg),
      spearman = if (sum(keep_ppg) > 1) {
        suppressWarnings(stats::cor(
          qb_sos_feature_overlay[[feature_col]][keep_ppg],
          qb_sos_feature_overlay$target_next_ppg[keep_ppg],
          method = "spearman"
        ))
      } else {
        NA_real_
      },
      stringsAsFactors = FALSE
    )
    idx <- idx + 1L
    
    keep_total <- is.finite(qb_sos_feature_overlay[[feature_col]]) & is.finite(qb_sos_feature_overlay$target_next_total_points)
    
    metric_rows[[idx]] <- data.frame(
      feature = feature_col,
      target = "target_next_total_points",
      n = sum(keep_total),
      spearman = if (sum(keep_total) > 1) {
        suppressWarnings(stats::cor(
          qb_sos_feature_overlay[[feature_col]][keep_total],
          qb_sos_feature_overlay$target_next_total_points[keep_total],
          method = "spearman"
        ))
      } else {
        NA_real_
      },
      stringsAsFactors = FALSE
    )
    idx <- idx + 1L
  }
  
  dplyr::bind_rows(metric_rows) |>
    dplyr::arrange(target, dplyr::desc(spearman), feature)
}

run_qb_sos_feature_overlay_step <- function(
    qb_sos_anchor,
    write_output = TRUE,
    max_source_season = 2024L
) {
  load_model_core_packages()
  
  qb_sos_feature_overlay <- build_qb_sos_feature_overlay_table(
    qb_sos_anchor,
    max_source_season = max_source_season
  )
  qb_sos_feature_metrics <- build_qb_sos_feature_overlay_metrics(qb_sos_feature_overlay)
  
  if (write_output) {
    dir.create(model_paths$sos_output_dir, recursive = TRUE, showWarnings = FALSE)
    
    utils::write.csv(
      qb_sos_feature_overlay,
      file.path(model_paths$sos_output_dir, "qb_sos_feature_overlay_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    
    utils::write.csv(
      qb_sos_feature_metrics,
      file.path(model_paths$sos_output_dir, "qb_sos_feature_overlay_metrics_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    feature_table = qb_sos_feature_overlay,
    metrics = qb_sos_feature_metrics
  )
}


# -------------------- QB SOS production-style board --------------------

build_qb_sos_board_metrics <- function(qb_sos_production_board) {
  load_model_core_packages()
  
  metric_rows <- list()
  idx <- 1L
  
  for (predict_season in sort(unique(qb_sos_production_board$target_next_season))) {
    fold_df <- qb_sos_production_board |>
      dplyr::filter(target_next_season == .env$predict_season)
    
    keep_ppg <- is.finite(fold_df$qb_sos_rank) & is.finite(fold_df$target_next_ppg)
    
    metric_rows[[idx]] <- data.frame(
      predict_season = predict_season,
      target = "target_next_ppg",
      n = sum(keep_ppg),
      spearman = if (sum(keep_ppg) > 1) {
        suppressWarnings(stats::cor(
          -fold_df$qb_sos_rank[keep_ppg],
          fold_df$target_next_ppg[keep_ppg],
          method = "spearman"
        ))
      } else {
        NA_real_
      },
      stringsAsFactors = FALSE
    )
    idx <- idx + 1L
    
    keep_total <- is.finite(fold_df$qb_sos_rank) & is.finite(fold_df$target_next_total_points)
    
    metric_rows[[idx]] <- data.frame(
      predict_season = predict_season,
      target = "target_next_total_points",
      n = sum(keep_total),
      spearman = if (sum(keep_total) > 1) {
        suppressWarnings(stats::cor(
          -fold_df$qb_sos_rank[keep_total],
          fold_df$target_next_total_points[keep_total],
          method = "spearman"
        ))
      } else {
        NA_real_
      },
      stringsAsFactors = FALSE
    )
    idx <- idx + 1L
  }
  
  dplyr::bind_rows(metric_rows) |>
    dplyr::arrange(predict_season, target)
}

run_qb_sos_production_board_step <- function(qb_sos_features, write_output = TRUE, output_dir = model_paths$sos_output_dir) {
  load_model_core_packages()
  
  production_candidate <- get_qb_sos_production_candidate()
  
  weights_row <- build_qb_sos_weight_candidates() |>
    dplyr::filter(candidate == .env$production_candidate) |>
    dplyr::slice(1)
  
  qb_sos_production_board <- build_qb_sos_production_board_from_weights(qb_sos_features, weights_row) |>
    dplyr::mutate(
      qb_sos_weight_profile = .env$production_candidate,
      qb_sos_tier = dplyr::case_when(
        .data$qb_sos_rank <= 3 ~ "Tier 1",
        .data$qb_sos_rank <= 6 ~ "Tier 2",
        .data$qb_sos_rank <= 12 ~ "Tier 3",
        .data$qb_sos_rank <= 18 ~ "Tier 4",
        TRUE ~ "Tier 5"
      )
    )
  
  qb_sos_board_metrics <- build_qb_sos_board_metrics(qb_sos_production_board)
  
  if (write_output) {
    utils::write.csv(
      qb_sos_production_board,
      file.path(output_dir, "qb_sos_production_board_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    
    utils::write.csv(
      qb_sos_board_metrics,
      file.path(output_dir, "qb_sos_production_board_metrics_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    board = qb_sos_production_board,
    metrics = qb_sos_board_metrics
  )
}


# -------------------- QB SOS weight tuning --------------------

build_qb_sos_weight_candidates <- function() {
  data.frame(
    candidate = c(
      "current_35_25_20_10_10",
      "anchor_heavy_45_20_15_10_10",
      "balanced_30_25_20_15_10",
      "omfg_heavy_30_20_25_10_15",
      "starter_prod_30_20_20_15_15"
    ),
    w_anchor_total = c(0.35, 0.45, 0.30, 0.30, 0.30),
    w_anchor_board = c(0.25, 0.20, 0.25, 0.20, 0.20),
    w_omfg = c(0.20, 0.15, 0.20, 0.25, 0.20),
    w_starter = c(0.10, 0.10, 0.15, 0.10, 0.15),
    w_production = c(0.10, 0.10, 0.10, 0.15, 0.15),
    stringsAsFactors = FALSE
  )
}

get_qb_sos_production_candidate <- function() {
  "current_35_25_20_10_10"
}

build_qb_sos_production_board_from_weights <- function(qb_sos_features, weights_row) {
  load_model_core_packages()
  
  feature_table <- if (is.list(qb_sos_features) && "feature_table" %in% names(qb_sos_features)) {
    qb_sos_features$feature_table
  } else {
    qb_sos_features
  }
  
  feature_table |>
    dplyr::mutate(
      qb_sos_final_score = (
        weights_row$w_anchor_total[[1]] * qb_rank_to_0_100(qb_sos_anchor_total_points) +
          weights_row$w_anchor_board[[1]] * qb_anchor_board_score +
          weights_row$w_omfg[[1]] * qb_preseason_omfg_score +
          weights_row$w_starter[[1]] * starter_security_component_0to100 +
          weights_row$w_production[[1]] * production_component_0to100
      )
    ) |>
    dplyr::group_by(target_next_season) |>
    dplyr::arrange(dplyr::desc(qb_sos_final_score), player, .by_group = TRUE) |>
    dplyr::mutate(
      qb_sos_rank = dplyr::row_number()
    ) |>
    dplyr::ungroup()
}

run_qb_sos_weight_tuning <- function(qb_sos_features, validation_seasons = 2023:2025, write_output = TRUE) {
  load_model_core_packages()
  
  candidates <- build_qb_sos_weight_candidates()
  
  summary_rows <- list()
  metric_rows <- list()
  board_list <- list()
  
  for (i in seq_len(nrow(candidates))) {
    weights_row <- candidates[i, , drop = FALSE]
    candidate_name <- weights_row$candidate[[1]]
    
    board <- build_qb_sos_production_board_from_weights(qb_sos_features, weights_row)
    metrics <- build_qb_sos_board_metrics(board) |>
      dplyr::mutate(candidate = candidate_name)
    
    board_list[[candidate_name]] <- board
    metric_rows[[i]] <- metrics
    
    val_metrics <- metrics |>
      dplyr::filter(predict_season %in% .env$validation_seasons)
    
    ppg_metrics <- val_metrics |>
      dplyr::filter(target == "target_next_ppg")
    
    total_metrics <- val_metrics |>
      dplyr::filter(target == "target_next_total_points")
    
    summary_rows[[i]] <- data.frame(
      candidate = candidate_name,
      avg_ppg_spearman = mean(ppg_metrics$spearman, na.rm = TRUE),
      min_ppg_spearman = min(ppg_metrics$spearman, na.rm = TRUE),
      avg_total_spearman = mean(total_metrics$spearman, na.rm = TRUE),
      min_total_spearman = min(total_metrics$spearman, na.rm = TRUE),
      combined_score = mean(c(
        mean(ppg_metrics$spearman, na.rm = TRUE),
        mean(total_metrics$spearman, na.rm = TRUE)
      ), na.rm = TRUE),
      stringsAsFactors = FALSE
    )
  }
  
  summary_df <- dplyr::bind_rows(summary_rows) |>
    dplyr::arrange(dplyr::desc(combined_score), dplyr::desc(avg_ppg_spearman), dplyr::desc(avg_total_spearman))
  
  metrics_df <- dplyr::bind_rows(metric_rows) |>
    dplyr::select(candidate, predict_season, target, n, spearman) |>
    dplyr::arrange(candidate, predict_season, target)
  
  if (write_output) {
    utils::write.csv(
      summary_df,
      file.path(model_paths$sos_output_dir, "qb_sos_weight_tuning_summary_2023_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    
    utils::write.csv(
      metrics_df,
      file.path(model_paths$sos_output_dir, "qb_sos_weight_tuning_metrics_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    summary = summary_df,
    metrics = metrics_df,
    boards = board_list
  )
}

# -------------------- QB SOS final export --------------------

build_qb_sos_final_export <- function(qb_sos_board, write_output = TRUE, output_dir = model_paths$sos_output_dir) {
  load_model_core_packages()
  
  board_df <- if (is.list(qb_sos_board) && "board" %in% names(qb_sos_board)) {
    qb_sos_board$board
  } else {
    qb_sos_board
  }
  
  out <- board_df |>
    dplyr::transmute(
      season = target_next_season,
      rank = qb_sos_rank,
      tier = qb_sos_tier,
      player,
      current_team = team,
      next_team = target_next_team,
      games,
      starter_weeks,
      age,
      rookie_year,
      weight_profile = .data$qb_sos_weight_profile,
      final_score = qb_sos_final_score,
      anchor_ppg = qb_sos_anchor_ppg,
      anchor_total_points = qb_sos_anchor_total_points,
      preseason_omfg = qb_preseason_omfg_score,
      board_score = qb_anchor_board_score,
      starter_security = starter_security_component_0to100,
      production = production_component_0to100,
      range_profile = range_profile_component_0to100,
      volume_opportunity = volume_opportunity_component_0to100,
      rushing_archetype = rushing_archetype_component_0to100,
      development_durability = development_durability_component_0to100,
      regressed_efficiency = regressed_efficiency_component_0to100,
      actual_next_ppg = target_next_ppg,
      actual_next_total_points = target_next_total_points
    ) |>
    dplyr::arrange(season, rank)
  
  if (write_output) {
    utils::write.csv(
      out,
      file.path(output_dir, "qb_sos_final_export_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}


compare_qb_sos_models <- function(qb_sos_baseline, qb_sos_weighted) {
  dplyr::bind_rows(
    qb_sos_baseline$metrics |>
      dplyr::mutate(model = "linear_baseline"),
    qb_sos_weighted$metrics |>
      dplyr::mutate(model = "weighted_two_year")
  ) |>
    dplyr::select(model, predict_season, target, sample, n, mae, rmse, spearman) |>
    dplyr::arrange(target, sample, predict_season, model)
}

run_qb_sos_full_pipeline <- function(write_output = TRUE) {
  load_model_core_packages()
  
  qb_sos_target_table <- build_qb_sos_target_table()
  qb_sos_train <- run_qb_sos_training_step(write_output = write_output)
  qb_sos_baseline <- run_qb_sos_baseline_model_step(write_output = write_output)
  qb_sos_weighted <- run_qb_sos_weighted_two_year_baseline(write_output = write_output)
  qb_sos_compare <- compare_qb_sos_models(qb_sos_baseline, qb_sos_weighted)
  qb_sos_hybrid <- run_qb_sos_hybrid_baseline(qb_sos_baseline, qb_sos_weighted, write_output = write_output)
  qb_sos_all_compare <- compare_qb_sos_all_models(qb_sos_baseline, qb_sos_weighted, qb_sos_hybrid)
  qb_sos_anchor <- run_qb_sos_anchor_step(qb_sos_weighted, qb_sos_hybrid, write_output = write_output)
  qb_sos_features <- run_qb_sos_feature_overlay_step(qb_sos_anchor, write_output = write_output)
  qb_sos_board <- run_qb_sos_production_board_step(qb_sos_features)
  qb_sos_tuning <- run_qb_sos_weight_tuning(qb_sos_features, write_output = write_output)
  qb_sos_final_export <- build_qb_sos_final_export(qb_sos_board, write_output = write_output)
  
  list(
    qb_sos_target_table = qb_sos_target_table,
    qb_sos_train = qb_sos_train,
    qb_sos_baseline = qb_sos_baseline,
    qb_sos_weighted = qb_sos_weighted,
    qb_sos_compare = qb_sos_compare,
    qb_sos_hybrid = qb_sos_hybrid,
    qb_sos_all_compare = qb_sos_all_compare,
    qb_sos_anchor = qb_sos_anchor,
    qb_sos_features = qb_sos_features,
    qb_sos_board = qb_sos_board,
    qb_sos_tuning = qb_sos_tuning,
    qb_sos_final_export = qb_sos_final_export
  )
}

if (isTRUE(getOption("sos.autorun_qb", TRUE))) {
  qb_sos_full_run <- run_qb_sos_full_pipeline(write_output = TRUE)
  qb_sos_target_table <- qb_sos_full_run$qb_sos_target_table
  qb_sos_train <- qb_sos_full_run$qb_sos_train
  qb_sos_training_frame <- qb_sos_train$qb_sos_training_frame
  qb_sos_baseline <- qb_sos_full_run$qb_sos_baseline
  qb_sos_weighted <- qb_sos_full_run$qb_sos_weighted
  qb_sos_compare <- qb_sos_full_run$qb_sos_compare
  qb_sos_hybrid <- qb_sos_full_run$qb_sos_hybrid
  qb_sos_all_compare <- qb_sos_full_run$qb_sos_all_compare
  qb_sos_anchor <- qb_sos_full_run$qb_sos_anchor
  qb_sos_features <- qb_sos_full_run$qb_sos_features
  qb_sos_board <- qb_sos_full_run$qb_sos_board
  qb_sos_tuning <- qb_sos_full_run$qb_sos_tuning
  qb_sos_final_export <- qb_sos_full_run$qb_sos_final_export
}

rb_sos_handoff <- get_handoff_spec("RB", "season_over_season")

rb_half_ppr_points_formula <- function(rush_yards, receptions, receiving_yards, total_td) {
  safe_numeric(rush_yards) / 10 +
    safe_numeric(receptions) * 0.5 +
    safe_numeric(receiving_yards) / 10 +
    safe_numeric(total_td) * 6
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
      yards_per_carry = safe_div(.data$rush_yards, .data$rush_attempts),
      yards_per_target = safe_div(.data$receiving_yards, .data$targets),
      yards_per_reception = safe_div(.data$receiving_yards, .data$receptions),
      yards_per_route = safe_div(.data$receiving_yards, .data$routes),
      targets_per_route = safe_div(.data$targets, .data$routes),
      td_per_opportunity = safe_div(.data$total_td, .data$opportunities),
      rush_td_per_carry = safe_div(.data$rush_td, .data$rush_attempts),
      rec_td_per_target = safe_div(.data$receiving_td, .data$targets),
      rb_model_eligible = .data$position == "RB",
      regular_season_flag = TRUE
    ) |>
    dplyr::select(-dplyr::any_of(c("targets_primary", "targets_fallback"))) |>
    dplyr::arrange(.data$season, .data$week, .data$team, .data$player)
  
  rb_weekly <- fill_player_bio_fields(rb_weekly)
  
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
      team_rbfb_rush_yards = sum(.data$rush_yards, na.rm = TRUE),
      team_rbfb_receiving_yards = sum(.data$receiving_yards, na.rm = TRUE),
      team_rbfb_receptions = sum(.data$receptions, na.rm = TRUE),
      team_rbfb_rush_td = sum(.data$rush_td, na.rm = TRUE),
      team_rbfb_receiving_td = sum(.data$receiving_td, na.rm = TRUE),
      team_rbfb_total_td = sum(.data$total_td, na.rm = TRUE),
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

build_rb_weekly_role_usage_table <- function(
    rb_share = build_rb_player_share_table(),
    write_output = FALSE,
    output_dir = model_paths$foundation_output_dir
) {
  load_model_core_packages()
  
  out <- rb_share |>
    dplyr::transmute(
      season,
      week,
      player,
      player_key,
      team,
      opponent,
      position,
      rb_model_eligible,
      depth_team,
      draft_day,
      report_status,
      practice_primary_injury,
      practice_secondary_injury,
      practice_status,
      rookie_year,
      age,
      rush_attempts,
      rush_yards,
      rush_td,
      targets,
      receptions,
      receiving_yards,
      receiving_td,
      routes,
      inside5_carries,
      total_td,
      scrimmage_yards,
      opportunities,
      half_ppr_points,
      team_carry_share,
      team_target_share,
      team_opportunity_share,
      team_route_share,
      team_fantasy_share
    )
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "rb_weekly_role_usage_2021_2025_regular.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_rb_player_season_combined_table <- function(
    rb_weekly = build_rb_clean_weekly_master(),
    rb_share = build_rb_player_share_table(rb_weekly = rb_weekly),
    write_output = FALSE,
    output_dir = model_paths$foundation_output_dir
) {
  load_model_core_packages()
  
  out <- rb_share |>
    dplyr::filter(.data$rb_model_eligible) |>
    dplyr::arrange(.data$season, .data$player_key, .data$week) |>
    dplyr::group_by(.data$season, .data$player_key) |>
    dplyr::summarise(
      player = first_non_missing(rev(.data$player)),
      team = first_non_missing(rev(.data$team)),
      teams_played = paste(unique(.data$team[!is.na(.data$team) & .data$team != ""]), collapse = "/"),
      games = dplyr::n_distinct(.data$week),
      starter_weeks = sum(.data$starter_flag, na.rm = TRUE),
      best_depth_team = suppressWarnings(min(.data$depth_team, na.rm = TRUE)),
      draft_day = first_non_missing(rev(.data$draft_day)),
      rookie_year = suppressWarnings(min(.data$rookie_year, na.rm = TRUE)),
      age = suppressWarnings(max(.data$age, na.rm = TRUE)),
      rush_attempts = sum(.data$rush_attempts, na.rm = TRUE),
      rush_yards = sum(.data$rush_yards, na.rm = TRUE),
      rush_td = sum(.data$rush_td, na.rm = TRUE),
      targets = sum(.data$targets, na.rm = TRUE),
      receptions = sum(.data$receptions, na.rm = TRUE),
      receiving_yards = sum(.data$receiving_yards, na.rm = TRUE),
      receiving_td = sum(.data$receiving_td, na.rm = TRUE),
      routes = sum(.data$routes, na.rm = TRUE),
      inside5_carries = sum(.data$inside5_carries, na.rm = TRUE),
      total_td = sum(.data$total_td, na.rm = TRUE),
      scrimmage_yards = sum(.data$scrimmage_yards, na.rm = TRUE),
      opportunities = sum(.data$opportunities, na.rm = TRUE),
      fantasy_points = sum(.data$half_ppr_points, na.rm = TRUE),
      fantasy_points_per_game = ifelse(
        sum(!is.na(.data$half_ppr_points)) > 0,
        mean(.data$half_ppr_points, na.rm = TRUE),
        NA_real_
      ),
      fantasy_points_sd = stats::sd(.data$half_ppr_points, na.rm = TRUE),
      weekly_floor_p25 = suppressWarnings(stats::quantile(.data$half_ppr_points, probs = 0.25, na.rm = TRUE, names = FALSE)),
      weekly_median_p50 = suppressWarnings(stats::quantile(.data$half_ppr_points, probs = 0.50, na.rm = TRUE, names = FALSE)),
      weekly_ceiling_p75 = suppressWarnings(stats::quantile(.data$half_ppr_points, probs = 0.75, na.rm = TRUE, names = FALSE)),
      weekly_ceiling_p90 = suppressWarnings(stats::quantile(.data$half_ppr_points, probs = 0.90, na.rm = TRUE, names = FALSE)),
      team_carry_share_mean = mean(.data$team_carry_share, na.rm = TRUE),
      team_target_share_mean = mean(.data$team_target_share, na.rm = TRUE),
      team_opportunity_share_mean = mean(.data$team_opportunity_share, na.rm = TRUE),
      team_route_share_mean = mean(.data$team_route_share, na.rm = TRUE),
      team_fantasy_share_mean = mean(.data$team_fantasy_share, na.rm = TRUE),
      .groups = "drop"
    ) |>
    dplyr::mutate(
      best_depth_team = ifelse(is.infinite(.data$best_depth_team), NA, .data$best_depth_team),
      rookie_year = ifelse(is.infinite(.data$rookie_year), NA, .data$rookie_year),
      age = ifelse(is.infinite(.data$age), NA, .data$age),
      qualified_4_games_current = .data$games >= 4,
      qualified_8_games_current = .data$games >= 8,
      next_season = .data$season + 1L,
      starter_rate = safe_div(.data$starter_weeks, .data$games),
      rush_attempts_per_game = safe_div(.data$rush_attempts, .data$games),
      targets_per_game = safe_div(.data$targets, .data$games),
      receptions_per_game = safe_div(.data$receptions, .data$games),
      routes_per_game = safe_div(.data$routes, .data$games),
      opportunities_per_game = safe_div(.data$opportunities, .data$games),
      rush_yards_per_game = safe_div(.data$rush_yards, .data$games),
      receiving_yards_per_game = safe_div(.data$receiving_yards, .data$games),
      scrimmage_yards_per_game = safe_div(.data$scrimmage_yards, .data$games),
      total_td_per_game = safe_div(.data$total_td, .data$games),
      yards_per_carry = safe_div(.data$rush_yards, .data$rush_attempts),
      yards_per_target = safe_div(.data$receiving_yards, .data$targets),
      yards_per_reception = safe_div(.data$receiving_yards, .data$receptions),
      targets_per_route = safe_div(.data$targets, .data$routes),
      td_per_opportunity = safe_div(.data$total_td, .data$opportunities),
      rush_td_per_carry = safe_div(.data$rush_td, .data$rush_attempts),
      rec_td_per_target = safe_div(.data$receiving_td, .data$targets)
    ) |>
    dplyr::arrange(.data$season, dplyr::desc(.data$fantasy_points_per_game), .data$player)
  
  duplicate_player_seasons <- out |>
    dplyr::count(.data$season, .data$player_key, name = "dup_n") |>
    dplyr::filter(.data$dup_n > 1L)
  if (nrow(duplicate_player_seasons) > 0) {
    stop("RB player-season table is not unique after aggregation.", call. = FALSE)
  }
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "rb_player_season_combined_table_2021_2025_regular.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_rb_sos_inputs <- function(write_output = FALSE) {
  load_model_core_packages()
  
  rb_clean_weekly_master <- build_rb_clean_weekly_master(write_output = write_output)
  rb_team_week_opportunity <- build_rb_team_week_opportunity_table(
    rb_weekly = rb_clean_weekly_master,
    write_output = write_output
  )
  rb_player_share_table <- build_rb_player_share_table(
    rb_weekly = rb_clean_weekly_master,
    team_week = rb_team_week_opportunity,
    write_output = write_output
  )
  rb_weekly_role_usage <- build_rb_weekly_role_usage_table(
    rb_share = rb_player_share_table,
    write_output = write_output
  )
  rb_player_season_combined_table <- build_rb_player_season_combined_table(
    rb_weekly = rb_clean_weekly_master,
    rb_share = rb_player_share_table,
    write_output = write_output
  )
  
  out <- list(
    position = "RB",
    mode = "season_over_season",
    handoff = rb_sos_handoff,
    handoff_text = read_text_from_handoff(rb_sos_handoff),
    rb_clean_weekly_master = rb_clean_weekly_master,
    rb_team_week_opportunity = rb_team_week_opportunity,
    rb_player_share_table = rb_player_share_table,
    rb_weekly_role_usage = rb_weekly_role_usage,
    rb_player_season_combined_table = rb_player_season_combined_table,
    player_season_index = build_sos_player_season_index("RB"),
    next_steps = c(
      "Build RB next-season targets from the player-season combined table.",
      "Translate the RB season-over-season handoff into baseline, weighted, and anchor model stages.",
      "Add preseason OMFG, market challenger, range, and simulation layers after the clean training frame is locked."
    )
  )
  
  if (write_output) {
    out$output_paths <- c(
      rb_clean_weekly_master = file.path(model_paths$foundation_output_dir, "rb_clean_weekly_master_2021_2025_regular.csv"),
      rb_team_week_opportunity = file.path(model_paths$foundation_output_dir, "rb_team_week_opportunity_2021_2025_regular.csv"),
      rb_player_share_table = file.path(model_paths$foundation_output_dir, "rb_player_share_table_2021_2025_regular.csv"),
      rb_weekly_role_usage = file.path(model_paths$foundation_output_dir, "rb_weekly_role_usage_2021_2025_regular.csv"),
      rb_player_season_combined_table = file.path(model_paths$foundation_output_dir, "rb_player_season_combined_table_2021_2025_regular.csv"),
      rb_player_season_index = write_sos_player_season_index("RB")
    )
  }
  
  out
}

make_rb_sos_output_manifest <- function(rb_sos_result) {
  output_paths <- unname(rb_sos_result$output_paths %||% character())
  output_labels <- names(rb_sos_result$output_paths %||% character())
  
  data.frame(
    output_name = output_labels,
    output_path = output_paths,
    exists = file.exists(output_paths),
    stringsAsFactors = FALSE
  )
}

run_rb_sos_pipeline <- function(write_output = TRUE) {
  load_model_core_packages()
  
  dir.create(model_paths$foundation_output_dir, recursive = TRUE, showWarnings = FALSE)
  dir.create(model_paths$sos_output_dir, recursive = TRUE, showWarnings = FALSE)
  
  rb_sos_result <- build_rb_sos_inputs(write_output = write_output)
  output_manifest <- make_rb_sos_output_manifest(rb_sos_result)
  
  list(
    result = rb_sos_result,
    output_manifest = output_manifest
  )
}

build_rb_sos_target_table <- function(
    rb_player_season_combined_table = NULL,
    write_output = FALSE,
    output_dir = model_paths$sos_output_dir
) {
  load_model_core_packages()
  
  if (is.null(rb_player_season_combined_table)) {
    rb_player_season_combined_table <- build_rb_player_season_combined_table(write_output = FALSE)
  }
  
  out <- rb_player_season_combined_table |>
    dplyr::group_by(.data$season) |>
    dplyr::arrange(
      dplyr::desc(.data$fantasy_points),
      dplyr::desc(.data$fantasy_points_per_game),
      .data$player,
      .by_group = TRUE
    ) |>
    dplyr::mutate(
      target_next_points_rank_all = dplyr::row_number(),
      next_top5_points_all = as.integer(.data$target_next_points_rank_all <= 5),
      next_top12_points_all = as.integer(.data$target_next_points_rank_all <= 12),
      next_top24_points_all = as.integer(.data$target_next_points_rank_all <= 24),
      next_top36_points_all = as.integer(.data$target_next_points_rank_all <= 36)
    ) |>
    dplyr::ungroup() |>
    dplyr::transmute(
      player_key,
      target_next_season = .data$season,
      target_next_team = .data$team,
      target_next_games = .data$games,
      target_next_points_rank_all,
      target_next_total_points = .data$fantasy_points,
      target_next_ppg = .data$fantasy_points_per_game,
      next_top5_points_all,
      next_top12_points_all,
      next_top24_points_all,
      next_top36_points_all,
      qualified_4_games_next = as.integer(.data$target_next_games >= 4),
      qualified_8_games_next = as.integer(.data$target_next_games >= 8)
    )
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "rb_sos_target_table_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_rb_sos_training_frame <- function(
    write_output = FALSE,
    output_dir = model_paths$sos_output_dir,
    max_source_season = 2024L
) {
  load_model_core_packages()
  
  rb_player_season_combined_table <- build_rb_player_season_combined_table(write_output = FALSE)
  rb_sos_target_table <- build_rb_sos_target_table(rb_player_season_combined_table, write_output = FALSE)
  
  out <- rb_player_season_combined_table |>
    dplyr::mutate(
      target_next_season = .data$next_season,
      qualified_4_games_current = as.integer(.data$games >= 4),
      qualified_8_games_current = as.integer(.data$games >= 8)
    ) |>
    dplyr::left_join(
      rb_sos_target_table,
      by = c("player_key", "target_next_season"),
      relationship = "many-to-one"
    ) |>
    dplyr::mutate(
      made_next_season = as.integer(!is.na(.data$target_next_ppg)),
      team_changed_next_season = dplyr::if_else(
        !is.na(.data$target_next_team) & .data$team != .data$target_next_team,
        1L,
        0L,
        missing = 0L
      )
    ) |>
    dplyr::filter(.data$season >= 2021, .data$season <= .env$max_source_season) |>
    dplyr::arrange(.data$season, dplyr::desc(.data$fantasy_points_per_game), .data$player)
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "rb_sos_training_frame_2021_2024_to_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

make_rb_sos_training_manifest <- function() {
  data.frame(
    output_name = c("rb_sos_target_table", "rb_sos_training_frame"),
    output_path = c(
      file.path(model_paths$sos_output_dir, "rb_sos_target_table_2022_2025.csv"),
      file.path(model_paths$sos_output_dir, "rb_sos_training_frame_2021_2024_to_2022_2025.csv")
    ),
    exists = c(
      file.exists(file.path(model_paths$sos_output_dir, "rb_sos_target_table_2022_2025.csv")),
      file.exists(file.path(model_paths$sos_output_dir, "rb_sos_training_frame_2021_2024_to_2022_2025.csv"))
    ),
    stringsAsFactors = FALSE
  )
}

run_rb_sos_training_step <- function(write_output = TRUE) {
  load_model_core_packages()
  
  dir.create(model_paths$sos_output_dir, recursive = TRUE, showWarnings = FALSE)
  
  rb_sos_target_table <- build_rb_sos_target_table(write_output = write_output)
  rb_sos_training_frame <- build_rb_sos_training_frame(write_output = write_output)
  
  list(
    rb_sos_target_table = rb_sos_target_table,
    rb_sos_training_frame = rb_sos_training_frame,
    output_manifest = make_rb_sos_training_manifest()
  )
}

build_rb_sos_baseline_feature_set <- function() {
  load_model_core_packages()
  
  model_df <- build_rb_sos_training_frame(write_output = FALSE)
  non_numeric_cols <- c("player_key", "player", "team", "target_next_team", "draft_day")
  numeric_cols <- setdiff(names(model_df), non_numeric_cols)
  
  model_df |>
    dplyr::mutate(
      dplyr::across(dplyr::any_of(numeric_cols), safe_numeric),
      target_next_ppg = safe_numeric(.data$target_next_ppg),
      target_next_total_points = safe_numeric(.data$target_next_total_points),
      qualified_4_games_next = safe_numeric(.data$qualified_4_games_next),
      qualified_8_games_next = safe_numeric(.data$qualified_8_games_next)
    )
}

run_rb_sos_baseline_model_step <- function(
    write_output = TRUE,
    output_dir = model_paths$sos_output_dir
) {
  load_model_core_packages()
  
  model_df <- build_rb_sos_baseline_feature_set()
  
  predictor_cols <- c(
    "games",
    "starter_weeks",
    "best_depth_team",
    "age",
    "rookie_year",
    "rush_attempts",
    "rush_yards",
    "rush_td",
    "targets",
    "receptions",
    "receiving_yards",
    "receiving_td",
    "routes",
    "inside5_carries",
    "total_td",
    "scrimmage_yards",
    "opportunities",
    "fantasy_points",
    "fantasy_points_per_game",
    "fantasy_points_sd",
    "weekly_floor_p25",
    "weekly_median_p50",
    "weekly_ceiling_p75",
    "weekly_ceiling_p90",
    "team_carry_share_mean",
    "team_target_share_mean",
    "team_opportunity_share_mean",
    "team_route_share_mean",
    "team_fantasy_share_mean",
    "starter_rate",
    "rush_attempts_per_game",
    "targets_per_game",
    "receptions_per_game",
    "routes_per_game",
    "opportunities_per_game",
    "rush_yards_per_game",
    "receiving_yards_per_game",
    "total_td_per_game",
    "yards_per_carry",
    "yards_per_target",
    "yards_per_reception",
    "targets_per_route",
    "td_per_opportunity",
    "rush_td_per_carry",
    "rec_td_per_target",
    "qualified_4_games_current",
    "qualified_8_games_current",
    "team_changed_next_season"
  )
  
  predictor_cols <- intersect(predictor_cols, names(model_df))
  
  predict_seasons <- sort(unique(model_df$target_next_season))
  predict_seasons <- predict_seasons[predict_seasons >= 2022 & predict_seasons <= 2025]
  
  prediction_list <- list()
  metric_list <- list()
  pred_idx <- 1L
  metric_idx <- 1L
  
  for (predict_season in predict_seasons) {
    train_df <- model_df |>
      dplyr::filter(
        target_next_season < predict_season,
        !is.na(.data$target_next_ppg),
        !is.na(.data$target_next_total_points)
      )
    
    test_df <- model_df |>
      dplyr::filter(
        target_next_season == predict_season,
        !is.na(.data$target_next_ppg),
        !is.na(.data$target_next_total_points)
      )
    
    if (nrow(train_df) == 0 || nrow(test_df) == 0) {
      next
    }
    
    imputed <- impute_numeric_medians(train_df, test_df, predictor_cols)
    train_df <- imputed$train
    test_df <- imputed$test
    
    ppg_formula <- stats::reformulate(predictor_cols, response = "target_next_ppg")
    total_formula <- stats::reformulate(predictor_cols, response = "target_next_total_points")
    
    ppg_model <- stats::lm(ppg_formula, data = train_df)
    total_model <- stats::lm(total_formula, data = train_df)
    
    pred_next_ppg <- as.numeric(stats::predict(ppg_model, newdata = test_df))
    pred_next_total_points <- as.numeric(stats::predict(total_model, newdata = test_df))
    
    fold_predictions <- test_df |>
      dplyr::transmute(
        train_through_season = predict_season - 1L,
        predict_season = .data$target_next_season,
        source_season = .data$season,
        player_key,
        player,
        current_team = .data$team,
        next_team = .data$target_next_team,
        target_next_games = .data$target_next_games,
        qualified_4_games_current,
        qualified_8_games_current,
        qualified_4_games_next,
        qualified_8_games_next,
        target_next_ppg,
        pred_next_ppg,
        target_next_total_points,
        pred_next_total_points
      )
    
    prediction_list[[pred_idx]] <- fold_predictions
    pred_idx <- pred_idx + 1L
    
    overall_ppg <- calc_regression_metrics(fold_predictions$target_next_ppg, fold_predictions$pred_next_ppg)
    overall_ppg$predict_season <- predict_season
    overall_ppg$target <- "target_next_ppg"
    overall_ppg$sample <- "overall"
    metric_list[[metric_idx]] <- overall_ppg
    metric_idx <- metric_idx + 1L
    
    overall_total <- calc_regression_metrics(fold_predictions$target_next_total_points, fold_predictions$pred_next_total_points)
    overall_total$predict_season <- predict_season
    overall_total$target <- "target_next_total_points"
    overall_total$sample <- "overall"
    metric_list[[metric_idx]] <- overall_total
    metric_idx <- metric_idx + 1L
    
    keep_4_4 <- fold_predictions$qualified_4_games_current == 1 & fold_predictions$qualified_4_games_next == 1
    
    qual_ppg <- calc_regression_metrics(
      fold_predictions$target_next_ppg[keep_4_4],
      fold_predictions$pred_next_ppg[keep_4_4]
    )
    qual_ppg$predict_season <- predict_season
    qual_ppg$target <- "target_next_ppg"
    qual_ppg$sample <- "qualified_4_4"
    metric_list[[metric_idx]] <- qual_ppg
    metric_idx <- metric_idx + 1L
    
    qual_total <- calc_regression_metrics(
      fold_predictions$target_next_total_points[keep_4_4],
      fold_predictions$pred_next_total_points[keep_4_4]
    )
    qual_total$predict_season <- predict_season
    qual_total$target <- "target_next_total_points"
    qual_total$sample <- "qualified_4_4"
    metric_list[[metric_idx]] <- qual_total
    metric_idx <- metric_idx + 1L
  }
  
  predictions <- dplyr::bind_rows(prediction_list)
  metrics <- dplyr::bind_rows(metric_list) |>
    dplyr::select(predict_season, target, sample, n, mae, rmse, spearman) |>
    dplyr::arrange(predict_season, target, sample)
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    
    utils::write.csv(
      predictions,
      file.path(output_dir, "rb_sos_baseline_predictions_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    
    utils::write.csv(
      metrics,
      file.path(output_dir, "rb_sos_baseline_metrics_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    predictions = predictions,
    metrics = metrics
  )
}

build_rb_sos_weighted_two_year_frame <- function() {
  load_model_core_packages()
  
  rb_season <- build_rb_player_season_combined_table(write_output = FALSE) |>
    dplyr::arrange(.data$season, dplyr::desc(.data$fantasy_points_per_game), .data$player)
  
  rb_target_frame <- rb_season |>
    dplyr::transmute(
      player_key,
      target_next_season = .data$season,
      target_next_team = .data$team,
      target_next_games = .data$games,
      target_next_ppg = .data$fantasy_points_per_game,
      target_next_total_points = .data$fantasy_points,
      qualified_4_games_next = as.integer(.data$games >= 4),
      qualified_8_games_next = as.integer(.data$games >= 8)
    )
  
  rb_prior_frame <- rb_season |>
    dplyr::transmute(
      player_key,
      season = .data$season + 1L,
      prior_ppg = .data$fantasy_points_per_game,
      prior_total_points = .data$fantasy_points
    )
  
  rb_season |>
    dplyr::mutate(
      target_next_season = .data$season + 1L
    ) |>
    dplyr::left_join(
      rb_target_frame,
      by = c("player_key", "target_next_season"),
      relationship = "many-to-one"
    ) |>
    dplyr::left_join(
      rb_prior_frame,
      by = c("player_key", "season"),
      relationship = "many-to-one"
    ) |>
    dplyr::mutate(
      weighted_two_year_ppg = dplyr::case_when(
        !is.na(.data$fantasy_points_per_game) & !is.na(.data$prior_ppg) ~ 0.65 * .data$fantasy_points_per_game + 0.35 * .data$prior_ppg,
        !is.na(.data$fantasy_points_per_game) ~ .data$fantasy_points_per_game,
        TRUE ~ .data$prior_ppg
      ),
      weighted_two_year_total_points = dplyr::case_when(
        !is.na(.data$fantasy_points) & !is.na(.data$prior_total_points) ~ 0.65 * .data$fantasy_points + 0.35 * .data$prior_total_points,
        !is.na(.data$fantasy_points) ~ .data$fantasy_points,
        TRUE ~ .data$prior_total_points
      )
    ) |>
    dplyr::filter(
      .data$target_next_season >= 2022,
      .data$target_next_season <= 2025,
      !is.na(.data$target_next_ppg),
      !is.na(.data$target_next_total_points)
    ) |>
    dplyr::arrange(.data$target_next_season, dplyr::desc(.data$weighted_two_year_ppg), .data$player)
}

run_rb_sos_weighted_two_year_baseline <- function(write_output = TRUE, output_dir = model_paths$sos_output_dir) {
  load_model_core_packages()
  
  predictions <- build_rb_sos_weighted_two_year_frame() |>
    dplyr::transmute(
      predict_season = .data$target_next_season,
      source_season = .data$season,
      player_key,
      player,
      current_team = .data$team,
      next_team = .data$target_next_team,
      qualified_4_games_current,
      qualified_8_games_current,
      qualified_4_games_next,
      qualified_8_games_next,
      target_next_ppg,
      pred_next_ppg = .data$weighted_two_year_ppg,
      target_next_total_points,
      pred_next_total_points = .data$weighted_two_year_total_points
    )
  
  metric_list <- list()
  idx <- 1L
  
  for (predict_season in sort(unique(predictions$predict_season))) {
    fold_df <- predictions |>
      dplyr::filter(.data$predict_season == .env$predict_season)
    
    overall_ppg <- calc_regression_metrics(fold_df$target_next_ppg, fold_df$pred_next_ppg)
    overall_ppg$predict_season <- predict_season
    overall_ppg$target <- "target_next_ppg"
    overall_ppg$sample <- "overall"
    metric_list[[idx]] <- overall_ppg
    idx <- idx + 1L
    
    qual_df <- fold_df |>
      dplyr::filter(.data$qualified_4_games_current == 1, .data$qualified_4_games_next == 1)
    
    qual_ppg <- calc_regression_metrics(qual_df$target_next_ppg, qual_df$pred_next_ppg)
    qual_ppg$predict_season <- predict_season
    qual_ppg$target <- "target_next_ppg"
    qual_ppg$sample <- "qualified_4_4"
    metric_list[[idx]] <- qual_ppg
    idx <- idx + 1L
    
    overall_total <- calc_regression_metrics(fold_df$target_next_total_points, fold_df$pred_next_total_points)
    overall_total$predict_season <- predict_season
    overall_total$target <- "target_next_total_points"
    overall_total$sample <- "overall"
    metric_list[[idx]] <- overall_total
    idx <- idx + 1L
    
    qual_total <- calc_regression_metrics(qual_df$target_next_total_points, qual_df$pred_next_total_points)
    qual_total$predict_season <- predict_season
    qual_total$target <- "target_next_total_points"
    qual_total$sample <- "qualified_4_4"
    metric_list[[idx]] <- qual_total
    idx <- idx + 1L
  }
  
  metrics <- dplyr::bind_rows(metric_list) |>
    dplyr::select(predict_season, target, sample, n, mae, rmse, spearman) |>
    dplyr::arrange(predict_season, target, sample)
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    
    utils::write.csv(
      predictions,
      file.path(output_dir, "rb_sos_weighted_two_year_predictions_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    
    utils::write.csv(
      metrics,
      file.path(output_dir, "rb_sos_weighted_two_year_metrics_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    predictions = predictions,
    metrics = metrics
  )
}

run_rb_sos_hybrid_baseline <- function(
    rb_sos_baseline,
    rb_sos_weighted,
    write_output = TRUE,
    output_dir = model_paths$sos_output_dir
) {
  load_model_core_packages()
  
  hybrid_predictions <- rb_sos_weighted$predictions |>
    dplyr::left_join(
      rb_sos_baseline$predictions |>
        dplyr::select(
          predict_season,
          player_key,
          pred_next_ppg_linear = pred_next_ppg,
          pred_next_total_points_linear = pred_next_total_points
        ),
      by = c("predict_season", "player_key")
    ) |>
    dplyr::mutate(
      pred_next_ppg = 0.70 * .data$pred_next_ppg + 0.30 * .data$pred_next_ppg_linear,
      pred_next_total_points = 0.70 * .data$pred_next_total_points + 0.30 * .data$pred_next_total_points_linear
    )
  
  metric_list <- list()
  idx <- 1L
  
  for (predict_season in sort(unique(hybrid_predictions$predict_season))) {
    fold_df <- hybrid_predictions |>
      dplyr::filter(.data$predict_season == .env$predict_season)
    
    overall_ppg <- calc_regression_metrics(fold_df$target_next_ppg, fold_df$pred_next_ppg)
    overall_ppg$predict_season <- predict_season
    overall_ppg$target <- "target_next_ppg"
    overall_ppg$sample <- "overall"
    metric_list[[idx]] <- overall_ppg
    idx <- idx + 1L
    
    qual_df <- fold_df |>
      dplyr::filter(.data$qualified_4_games_current == 1, .data$qualified_4_games_next == 1)
    
    qual_ppg <- calc_regression_metrics(qual_df$target_next_ppg, qual_df$pred_next_ppg)
    qual_ppg$predict_season <- predict_season
    qual_ppg$target <- "target_next_ppg"
    qual_ppg$sample <- "qualified_4_4"
    metric_list[[idx]] <- qual_ppg
    idx <- idx + 1L
    
    overall_total <- calc_regression_metrics(fold_df$target_next_total_points, fold_df$pred_next_total_points)
    overall_total$predict_season <- predict_season
    overall_total$target <- "target_next_total_points"
    overall_total$sample <- "overall"
    metric_list[[idx]] <- overall_total
    idx <- idx + 1L
    
    qual_total <- calc_regression_metrics(qual_df$target_next_total_points, qual_df$pred_next_total_points)
    qual_total$predict_season <- predict_season
    qual_total$target <- "target_next_total_points"
    qual_total$sample <- "qualified_4_4"
    metric_list[[idx]] <- qual_total
    idx <- idx + 1L
  }
  
  hybrid_metrics <- dplyr::bind_rows(metric_list) |>
    dplyr::select(predict_season, target, sample, n, mae, rmse, spearman) |>
    dplyr::arrange(predict_season, target, sample)
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    
    utils::write.csv(
      hybrid_predictions,
      file.path(output_dir, "rb_sos_hybrid_baseline_predictions_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    
    utils::write.csv(
      hybrid_metrics,
      file.path(output_dir, "rb_sos_hybrid_baseline_metrics_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    predictions = hybrid_predictions,
    metrics = hybrid_metrics
  )
}

compare_rb_sos_models <- function(rb_sos_baseline, rb_sos_weighted) {
  dplyr::bind_rows(
    rb_sos_baseline$metrics |>
      dplyr::mutate(model = "linear_baseline"),
    rb_sos_weighted$metrics |>
      dplyr::mutate(model = "weighted_two_year")
  ) |>
    dplyr::select(model, predict_season, target, sample, n, mae, rmse, spearman) |>
    dplyr::arrange(target, sample, predict_season, model)
}

compare_rb_sos_all_models <- function(rb_sos_baseline, rb_sos_weighted, rb_sos_hybrid) {
  dplyr::bind_rows(
    rb_sos_baseline$metrics |>
      dplyr::mutate(model = "linear_baseline"),
    rb_sos_weighted$metrics |>
      dplyr::mutate(model = "weighted_two_year"),
    rb_sos_hybrid$metrics |>
      dplyr::mutate(model = "hybrid_70_30")
  ) |>
    dplyr::select(model, predict_season, target, sample, n, mae, rmse, spearman) |>
    dplyr::arrange(target, sample, predict_season, model)
}

build_rb_sos_anchor_predictions <- function(
    rb_sos_weighted,
    rb_sos_hybrid,
    write_output = TRUE,
    output_dir = model_paths$sos_output_dir
) {
  load_model_core_packages()
  
  weighted_df <- rb_sos_weighted$predictions |>
    dplyr::rename(
      weighted_pred_next_ppg = pred_next_ppg,
      weighted_pred_next_total_points = pred_next_total_points
    )
  
  hybrid_df <- rb_sos_hybrid$predictions |>
    dplyr::rename(
      hybrid_pred_next_ppg = pred_next_ppg,
      hybrid_pred_next_total_points = pred_next_total_points
    )
  
  out <- dplyr::full_join(
    weighted_df,
    hybrid_df,
    by = c(
      "predict_season",
      "source_season",
      "player_key",
      "player",
      "current_team",
      "next_team",
      "qualified_4_games_current",
      "qualified_8_games_current",
      "qualified_4_games_next",
      "qualified_8_games_next",
      "target_next_ppg",
      "target_next_total_points"
    )
  ) |>
    dplyr::mutate(
      rb_sos_anchor_ppg = dplyr::coalesce(.data$hybrid_pred_next_ppg, .data$weighted_pred_next_ppg),
      rb_sos_anchor_total_points = dplyr::coalesce(.data$weighted_pred_next_total_points, .data$hybrid_pred_next_total_points),
      rb_sos_anchor_model_ppg = dplyr::if_else(!is.na(.data$hybrid_pred_next_ppg), "hybrid_70_30", "weighted_two_year"),
      rb_sos_anchor_model_total_points = dplyr::if_else(!is.na(.data$weighted_pred_next_total_points), "weighted_two_year", "hybrid_70_30")
    ) |>
    dplyr::arrange(.data$predict_season, dplyr::desc(.data$rb_sos_anchor_ppg), .data$player)
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    
    utils::write.csv(
      out,
      file.path(output_dir, "rb_sos_anchor_predictions_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_rb_sos_anchor_metrics <- function(rb_sos_anchor_predictions) {
  load_model_core_packages()
  
  metric_list <- list()
  idx <- 1L
  
  for (predict_season in sort(unique(rb_sos_anchor_predictions$predict_season))) {
    fold_df <- rb_sos_anchor_predictions |>
      dplyr::filter(.data$predict_season == .env$predict_season)
    
    overall_ppg <- calc_regression_metrics(fold_df$target_next_ppg, fold_df$rb_sos_anchor_ppg)
    overall_ppg$predict_season <- predict_season
    overall_ppg$target <- "target_next_ppg"
    overall_ppg$sample <- "overall"
    metric_list[[idx]] <- overall_ppg
    idx <- idx + 1L
    
    qual_df <- fold_df |>
      dplyr::filter(.data$qualified_4_games_current == 1, .data$qualified_4_games_next == 1)
    
    qual_ppg <- calc_regression_metrics(qual_df$target_next_ppg, qual_df$rb_sos_anchor_ppg)
    qual_ppg$predict_season <- predict_season
    qual_ppg$target <- "target_next_ppg"
    qual_ppg$sample <- "qualified_4_4"
    metric_list[[idx]] <- qual_ppg
    idx <- idx + 1L
    
    overall_total <- calc_regression_metrics(fold_df$target_next_total_points, fold_df$rb_sos_anchor_total_points)
    overall_total$predict_season <- predict_season
    overall_total$target <- "target_next_total_points"
    overall_total$sample <- "overall"
    metric_list[[idx]] <- overall_total
    idx <- idx + 1L
    
    qual_total <- calc_regression_metrics(qual_df$target_next_total_points, qual_df$rb_sos_anchor_total_points)
    qual_total$predict_season <- predict_season
    qual_total$target <- "target_next_total_points"
    qual_total$sample <- "qualified_4_4"
    metric_list[[idx]] <- qual_total
    idx <- idx + 1L
  }
  
  dplyr::bind_rows(metric_list) |>
    dplyr::select(predict_season, target, sample, n, mae, rmse, spearman) |>
    dplyr::arrange(predict_season, target, sample)
}

run_rb_sos_anchor_step <- function(rb_sos_weighted, rb_sos_hybrid, write_output = TRUE) {
  load_model_core_packages()
  
  rb_sos_anchor_predictions <- build_rb_sos_anchor_predictions(
    rb_sos_weighted = rb_sos_weighted,
    rb_sos_hybrid = rb_sos_hybrid,
    write_output = write_output
  )
  
  rb_sos_anchor_metrics <- build_rb_sos_anchor_metrics(rb_sos_anchor_predictions)
  
  if (write_output) {
    utils::write.csv(
      rb_sos_anchor_metrics,
      file.path(model_paths$sos_output_dir, "rb_sos_anchor_metrics_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    predictions = rb_sos_anchor_predictions,
    metrics = rb_sos_anchor_metrics
  )
}

rb_age_window_score <- function(age_vec) {
  age_vec <- safe_numeric(age_vec)
  out <- 100 - pmin(abs(age_vec - 25) * 9, 100)
  out[!is.finite(age_vec)] <- NA_real_
  out
}

build_rb_sos_feature_overlay_table <- function(rb_sos_anchor, max_source_season = 2024L) {
  load_model_core_packages()
  
  rb_anchor_predictions <- if (is.list(rb_sos_anchor) && "predictions" %in% names(rb_sos_anchor)) {
    rb_sos_anchor$predictions
  } else {
    rb_sos_anchor
  }
  
  rb_train <- build_rb_sos_training_frame(
    write_output = FALSE,
    max_source_season = max_source_season
  )
  
  rb_train |>
    dplyr::left_join(
      rb_anchor_predictions |>
        dplyr::select(
          predict_season,
          source_season,
          player_key,
          rb_sos_anchor_ppg,
          rb_sos_anchor_total_points,
          rb_sos_anchor_model_ppg,
          rb_sos_anchor_model_total_points
        ),
      by = c(
        "target_next_season" = "predict_season",
        "season" = "source_season",
        "player_key" = "player_key"
      ),
      relationship = "many-to-one"
    ) |>
    dplyr::mutate(
      starter_rate = dplyr::coalesce(.data$starter_rate, safe_div(.data$starter_weeks, .data$games)),
      total_td_per_game = dplyr::coalesce(.data$total_td_per_game, safe_div(.data$total_td, .data$games)),
      production_component_0to100 = qb_row_mean(
        qb_rank_to_0_100(.data$fantasy_points_per_game),
        qb_rank_to_0_100(.data$fantasy_points),
        qb_rank_to_0_100(.data$scrimmage_yards_per_game),
        qb_rank_to_0_100(.data$total_td_per_game)
      ),
      opportunity_component_0to100 = qb_row_mean(
        qb_rank_to_0_100(.data$opportunities_per_game),
        qb_rank_to_0_100(.data$rush_attempts_per_game),
        qb_rank_to_0_100(.data$targets_per_game),
        qb_rank_to_0_100(.data$team_opportunity_share_mean)
      ),
      weekly_range_component_0to100 = qb_row_mean(
        qb_rank_to_0_100(.data$weekly_floor_p25),
        qb_rank_to_0_100(.data$weekly_median_p50),
        qb_rank_to_0_100(.data$weekly_ceiling_p75),
        qb_rank_to_0_100(.data$weekly_ceiling_p90),
        qb_rank_to_0_100(.data$fantasy_points_sd, higher_is_better = FALSE)
      ),
      receiving_role_component_0to100 = qb_row_mean(
        qb_rank_to_0_100(.data$targets_per_game),
        qb_rank_to_0_100(.data$receptions_per_game),
        qb_rank_to_0_100(.data$routes_per_game),
        qb_rank_to_0_100(.data$team_target_share_mean),
        qb_rank_to_0_100(.data$team_route_share_mean),
        qb_rank_to_0_100(.data$targets_per_route)
      ),
      predictability_stability_component_0to100 = qb_row_mean(
        qb_rank_to_0_100(.data$fantasy_points_sd, higher_is_better = FALSE),
        qb_rank_to_0_100(.data$games),
        qb_rank_to_0_100(.data$starter_weeks),
        qb_rank_to_0_100(.data$team_fantasy_share_mean)
      ),
      td_context_component_0to100 = qb_row_mean(
        qb_rank_to_0_100(.data$total_td_per_game),
        qb_rank_to_0_100(.data$rush_td_per_carry),
        qb_rank_to_0_100(.data$rec_td_per_target),
        qb_rank_to_0_100(.data$team_fantasy_share_mean)
      ),
      age_development_component_0to100 = qb_row_mean(
        rb_age_window_score(.data$age),
        qb_rank_to_0_100(.data$games),
        qb_rank_to_0_100(.data$starter_weeks)
      ),
      shrunk_efficiency_component_0to100 = qb_row_mean(
        qb_rank_to_0_100(.data$yards_per_carry),
        qb_rank_to_0_100(.data$yards_per_target),
        qb_rank_to_0_100(.data$yards_per_reception),
        qb_rank_to_0_100(.data$targets_per_route)
      ),
      rb_preseason_omfg_score = (
        0.23 * .data$production_component_0to100 +
          0.21 * .data$opportunity_component_0to100 +
          0.16 * .data$weekly_range_component_0to100 +
          0.13 * .data$receiving_role_component_0to100 +
          0.10 * .data$predictability_stability_component_0to100 +
          0.08 * .data$td_context_component_0to100 +
          0.05 * .data$age_development_component_0to100 +
          0.04 * .data$shrunk_efficiency_component_0to100
      ),
      rb_anchor_board_score = qb_row_mean(
        qb_rank_to_0_100(.data$rb_sos_anchor_ppg),
        qb_rank_to_0_100(.data$rb_sos_anchor_total_points),
        .data$rb_preseason_omfg_score
      )
    ) |>
    dplyr::arrange(.data$target_next_season, dplyr::desc(.data$rb_anchor_board_score), .data$player)
}

build_rb_sos_feature_overlay_metrics <- function(rb_sos_feature_overlay) {
  load_model_core_packages()
  
  feature_cols <- c(
    "production_component_0to100",
    "opportunity_component_0to100",
    "weekly_range_component_0to100",
    "receiving_role_component_0to100",
    "predictability_stability_component_0to100",
    "td_context_component_0to100",
    "age_development_component_0to100",
    "shrunk_efficiency_component_0to100",
    "rb_preseason_omfg_score",
    "rb_anchor_board_score",
    "rb_sos_anchor_ppg",
    "rb_sos_anchor_total_points"
  )
  
  metric_rows <- list()
  idx <- 1L
  
  for (feature_col in feature_cols) {
    keep_ppg <- is.finite(rb_sos_feature_overlay[[feature_col]]) & is.finite(rb_sos_feature_overlay$target_next_ppg)
    
    metric_rows[[idx]] <- data.frame(
      feature = feature_col,
      target = "target_next_ppg",
      n = sum(keep_ppg),
      spearman = if (sum(keep_ppg) > 1) {
        suppressWarnings(stats::cor(
          rb_sos_feature_overlay[[feature_col]][keep_ppg],
          rb_sos_feature_overlay$target_next_ppg[keep_ppg],
          method = "spearman"
        ))
      } else {
        NA_real_
      },
      stringsAsFactors = FALSE
    )
    idx <- idx + 1L
    
    keep_total <- is.finite(rb_sos_feature_overlay[[feature_col]]) & is.finite(rb_sos_feature_overlay$target_next_total_points)
    
    metric_rows[[idx]] <- data.frame(
      feature = feature_col,
      target = "target_next_total_points",
      n = sum(keep_total),
      spearman = if (sum(keep_total) > 1) {
        suppressWarnings(stats::cor(
          rb_sos_feature_overlay[[feature_col]][keep_total],
          rb_sos_feature_overlay$target_next_total_points[keep_total],
          method = "spearman"
        ))
      } else {
        NA_real_
      },
      stringsAsFactors = FALSE
    )
    idx <- idx + 1L
  }
  
  dplyr::bind_rows(metric_rows) |>
    dplyr::arrange(target, dplyr::desc(spearman), feature)
}

run_rb_sos_feature_overlay_step <- function(
    rb_sos_anchor,
    write_output = TRUE,
    max_source_season = 2024L
) {
  load_model_core_packages()
  
  rb_sos_feature_overlay <- build_rb_sos_feature_overlay_table(
    rb_sos_anchor,
    max_source_season = max_source_season
  )
  rb_sos_feature_metrics <- build_rb_sos_feature_overlay_metrics(rb_sos_feature_overlay)
  
  if (write_output) {
    dir.create(model_paths$sos_output_dir, recursive = TRUE, showWarnings = FALSE)
    
    utils::write.csv(
      rb_sos_feature_overlay,
      file.path(model_paths$sos_output_dir, "rb_sos_feature_overlay_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    
    utils::write.csv(
      rb_sos_feature_metrics,
      file.path(model_paths$sos_output_dir, "rb_sos_feature_overlay_metrics_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    feature_table = rb_sos_feature_overlay,
    metrics = rb_sos_feature_metrics
  )
}

build_rb_sos_board_metrics <- function(rb_sos_production_board) {
  load_model_core_packages()
  
  metric_rows <- list()
  idx <- 1L
  
  for (predict_season in sort(unique(rb_sos_production_board$target_next_season))) {
    fold_df <- rb_sos_production_board |>
      dplyr::filter(.data$target_next_season == .env$predict_season)
    
    keep_ppg <- is.finite(fold_df$rb_sos_rank) & is.finite(fold_df$target_next_ppg)
    
    metric_rows[[idx]] <- data.frame(
      predict_season = predict_season,
      target = "target_next_ppg",
      n = sum(keep_ppg),
      spearman = if (sum(keep_ppg) > 1) {
        suppressWarnings(stats::cor(
          -fold_df$rb_sos_rank[keep_ppg],
          fold_df$target_next_ppg[keep_ppg],
          method = "spearman"
        ))
      } else {
        NA_real_
      },
      stringsAsFactors = FALSE
    )
    idx <- idx + 1L
    
    keep_total <- is.finite(fold_df$rb_sos_rank) & is.finite(fold_df$target_next_total_points)
    
    metric_rows[[idx]] <- data.frame(
      predict_season = predict_season,
      target = "target_next_total_points",
      n = sum(keep_total),
      spearman = if (sum(keep_total) > 1) {
        suppressWarnings(stats::cor(
          -fold_df$rb_sos_rank[keep_total],
          fold_df$target_next_total_points[keep_total],
          method = "spearman"
        ))
      } else {
        NA_real_
      },
      stringsAsFactors = FALSE
    )
    idx <- idx + 1L
  }
  
  dplyr::bind_rows(metric_rows) |>
    dplyr::arrange(predict_season, target)
}

build_rb_sos_weight_candidates <- function() {
  data.frame(
    candidate = c(
      "current_35_25_20_10_10",
      "anchor_heavy_45_20_15_10_10",
      "balanced_30_25_20_15_10",
      "omfg_heavy_30_20_25_10_15",
      "opportunity_receiving_30_20_20_15_15"
    ),
    w_anchor_total = c(0.35, 0.45, 0.30, 0.30, 0.30),
    w_anchor_board = c(0.25, 0.20, 0.25, 0.20, 0.20),
    w_omfg = c(0.20, 0.15, 0.20, 0.25, 0.20),
    w_opportunity = c(0.10, 0.10, 0.15, 0.10, 0.15),
    w_receiving = c(0.10, 0.10, 0.10, 0.15, 0.15),
    stringsAsFactors = FALSE
  )
}

get_rb_sos_production_candidate <- function() {
  "anchor_heavy_45_20_15_10_10"
}

build_rb_sos_production_board_from_weights <- function(rb_sos_features, weights_row) {
  load_model_core_packages()
  
  feature_table <- if (is.list(rb_sos_features) && "feature_table" %in% names(rb_sos_features)) {
    rb_sos_features$feature_table
  } else {
    rb_sos_features
  }
  
  feature_table |>
    dplyr::mutate(
      rb_sos_final_score = (
        weights_row$w_anchor_total[[1]] * qb_rank_to_0_100(.data$rb_sos_anchor_total_points) +
          weights_row$w_anchor_board[[1]] * .data$rb_anchor_board_score +
          weights_row$w_omfg[[1]] * .data$rb_preseason_omfg_score +
          weights_row$w_opportunity[[1]] * .data$opportunity_component_0to100 +
          weights_row$w_receiving[[1]] * .data$receiving_role_component_0to100
      )
    ) |>
    dplyr::group_by(.data$target_next_season) |>
    dplyr::arrange(dplyr::desc(.data$rb_sos_final_score), .data$player, .by_group = TRUE) |>
    dplyr::mutate(
      rb_sos_rank = dplyr::row_number()
    ) |>
    dplyr::ungroup()
}

run_rb_sos_production_board_step <- function(rb_sos_features, write_output = TRUE, output_dir = model_paths$sos_output_dir) {
  load_model_core_packages()
  
  production_candidate <- get_rb_sos_production_candidate()
  
  weights_row <- build_rb_sos_weight_candidates() |>
    dplyr::filter(.data$candidate == .env$production_candidate) |>
    dplyr::slice(1)
  
  rb_sos_production_board <- build_rb_sos_production_board_from_weights(rb_sos_features, weights_row) |>
    dplyr::mutate(
      rb_sos_weight_profile = .env$production_candidate,
      rb_sos_tier = dplyr::case_when(
        .data$rb_sos_rank <= 5 ~ "Tier 1",
        .data$rb_sos_rank <= 12 ~ "Tier 2",
        .data$rb_sos_rank <= 24 ~ "Tier 3",
        .data$rb_sos_rank <= 36 ~ "Tier 4",
        TRUE ~ "Tier 5"
      )
    )
  
  rb_sos_board_metrics <- build_rb_sos_board_metrics(rb_sos_production_board)
  
  if (write_output) {
    utils::write.csv(
      rb_sos_production_board,
      file.path(output_dir, "rb_sos_production_board_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    
    utils::write.csv(
      rb_sos_board_metrics,
      file.path(output_dir, "rb_sos_production_board_metrics_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    board = rb_sos_production_board,
    metrics = rb_sos_board_metrics,
    production_candidate = production_candidate
  )
}

run_rb_sos_weight_tuning <- function(rb_sos_features, validation_seasons = 2023:2025, write_output = TRUE) {
  load_model_core_packages()
  
  candidates <- build_rb_sos_weight_candidates()
  
  summary_rows <- list()
  metric_rows <- list()
  board_list <- list()
  
  for (i in seq_len(nrow(candidates))) {
    weights_row <- candidates[i, , drop = FALSE]
    candidate_name <- weights_row$candidate[[1]]
    
    board <- build_rb_sos_production_board_from_weights(rb_sos_features, weights_row)
    metrics <- build_rb_sos_board_metrics(board) |>
      dplyr::mutate(candidate = candidate_name)
    
    board_list[[candidate_name]] <- board
    metric_rows[[i]] <- metrics
    
    val_metrics <- metrics |>
      dplyr::filter(.data$predict_season %in% .env$validation_seasons)
    
    ppg_metrics <- val_metrics |>
      dplyr::filter(.data$target == "target_next_ppg")
    
    total_metrics <- val_metrics |>
      dplyr::filter(.data$target == "target_next_total_points")
    
    summary_rows[[i]] <- data.frame(
      candidate = candidate_name,
      avg_ppg_spearman = mean(ppg_metrics$spearman, na.rm = TRUE),
      min_ppg_spearman = min(ppg_metrics$spearman, na.rm = TRUE),
      avg_total_spearman = mean(total_metrics$spearman, na.rm = TRUE),
      min_total_spearman = min(total_metrics$spearman, na.rm = TRUE),
      combined_score = mean(c(
        mean(ppg_metrics$spearman, na.rm = TRUE),
        mean(total_metrics$spearman, na.rm = TRUE)
      ), na.rm = TRUE),
      stringsAsFactors = FALSE
    )
  }
  
  summary_df <- dplyr::bind_rows(summary_rows) |>
    dplyr::arrange(dplyr::desc(.data$combined_score), dplyr::desc(.data$avg_ppg_spearman), dplyr::desc(.data$avg_total_spearman))
  
  metrics_df <- dplyr::bind_rows(metric_rows) |>
    dplyr::select(candidate, predict_season, target, n, spearman) |>
    dplyr::arrange(candidate, predict_season, target)
  
  if (write_output) {
    utils::write.csv(
      summary_df,
      file.path(model_paths$sos_output_dir, "rb_sos_weight_tuning_summary_2023_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    
    utils::write.csv(
      metrics_df,
      file.path(model_paths$sos_output_dir, "rb_sos_weight_tuning_metrics_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    summary = summary_df,
    metrics = metrics_df,
    boards = board_list
  )
}

build_rb_sos_final_export <- function(rb_sos_board, write_output = TRUE, output_dir = model_paths$sos_output_dir) {
  load_model_core_packages()
  
  board_df <- if (is.list(rb_sos_board) && "board" %in% names(rb_sos_board)) {
    rb_sos_board$board
  } else {
    rb_sos_board
  }
  
  out <- board_df |>
    dplyr::transmute(
      season = .data$target_next_season,
      rank = .data$rb_sos_rank,
      tier = .data$rb_sos_tier,
      player,
      current_team = .data$team,
      next_team = .data$target_next_team,
      games,
      starter_weeks,
      age,
      rookie_year,
      weight_profile = .data$rb_sos_weight_profile,
      final_score = .data$rb_sos_final_score,
      anchor_ppg = .data$rb_sos_anchor_ppg,
      anchor_total_points = .data$rb_sos_anchor_total_points,
      preseason_omfg = .data$rb_preseason_omfg_score,
      board_score = .data$rb_anchor_board_score,
      production = .data$production_component_0to100,
      opportunity = .data$opportunity_component_0to100,
      weekly_range = .data$weekly_range_component_0to100,
      receiving_role = .data$receiving_role_component_0to100,
      predictability_stability = .data$predictability_stability_component_0to100,
      td_context = .data$td_context_component_0to100,
      age_development = .data$age_development_component_0to100,
      shrunk_efficiency = .data$shrunk_efficiency_component_0to100,
      actual_next_ppg = .data$target_next_ppg,
      actual_next_total_points = .data$target_next_total_points
    ) |>
    dplyr::arrange(.data$season, .data$rank)
  
  if (write_output) {
    utils::write.csv(
      out,
      file.path(output_dir, "rb_sos_final_export_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

run_rb_sos_full_pipeline <- function(write_output = TRUE) {
  load_model_core_packages()
  
  rb_sos_target_table <- build_rb_sos_target_table()
  rb_sos_train <- run_rb_sos_training_step(write_output = write_output)
  rb_sos_baseline <- run_rb_sos_baseline_model_step(write_output = write_output)
  rb_sos_weighted <- run_rb_sos_weighted_two_year_baseline(write_output = write_output)
  rb_sos_compare <- compare_rb_sos_models(rb_sos_baseline, rb_sos_weighted)
  rb_sos_hybrid <- run_rb_sos_hybrid_baseline(rb_sos_baseline, rb_sos_weighted, write_output = write_output)
  rb_sos_all_compare <- compare_rb_sos_all_models(rb_sos_baseline, rb_sos_weighted, rb_sos_hybrid)
  rb_sos_anchor <- run_rb_sos_anchor_step(rb_sos_weighted, rb_sos_hybrid, write_output = write_output)
  rb_sos_features <- run_rb_sos_feature_overlay_step(rb_sos_anchor, write_output = write_output)
  rb_sos_board <- run_rb_sos_production_board_step(rb_sos_features, write_output = write_output)
  rb_sos_tuning <- run_rb_sos_weight_tuning(rb_sos_features, write_output = write_output)
  rb_sos_final_export <- build_rb_sos_final_export(rb_sos_board, write_output = write_output)
  
  list(
    rb_sos_target_table = rb_sos_target_table,
    rb_sos_train = rb_sos_train,
    rb_sos_baseline = rb_sos_baseline,
    rb_sos_weighted = rb_sos_weighted,
    rb_sos_compare = rb_sos_compare,
    rb_sos_hybrid = rb_sos_hybrid,
    rb_sos_all_compare = rb_sos_all_compare,
    rb_sos_anchor = rb_sos_anchor,
    rb_sos_features = rb_sos_features,
    rb_sos_board = rb_sos_board,
    rb_sos_tuning = rb_sos_tuning,
    rb_sos_final_export = rb_sos_final_export
  )
}

wr_sos_handoff <- get_handoff_spec("WR", "season_over_season")

wr_half_ppr_points_formula <- function(receiving_yards, receptions, total_td, rush_yards = 0) {
  safe_numeric(receiving_yards) / 10 +
    safe_numeric(receptions) * 0.5 +
    safe_numeric(rush_yards) / 10 +
    safe_numeric(total_td) * 6
}

wr_age_window_score <- function(age_vec) {
  age_vec <- safe_numeric(age_vec)
  out <- 100 - pmin(abs(age_vec - 26) * 8, 100)
  out[!is.finite(age_vec)] <- NA_real_
  out
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
      adot = pick_first_existing_numeric(wr_raw, c("aDOT", "aDOT_ply")),
      air_yards = pick_first_existing_numeric(wr_raw, c("AY", "AY_ply")),
      air_yards_share = pick_first_existing_numeric(wr_raw, c("AY_Share")),
      targets_primary = pick_first_existing_numeric(wr_raw, c("TGT_ply")),
      targets_fallback = pick_first_existing_numeric(wr_raw, c("TGT")),
      team_total_targets_source = pick_first_existing_numeric(wr_raw, c("TM_TGT", "TGT_team")),
      target_share_total_source = pick_first_existing_numeric(wr_raw, c("TGT_PCT")),
      targets_per_route_source = pick_first_existing_numeric(wr_raw, c("TPRR")),
      receptions = pick_first_existing_numeric(wr_raw, c("REC", "REC_ply")),
      catch_rate_source = pick_first_existing_numeric(wr_raw, c("Catch_Rate", "Catch_Rate_ply")),
      receiving_yards = pick_first_existing_numeric(wr_raw, c("YDS", "YDS_ply")),
      receiving_yards_per_game_source = pick_first_existing_numeric(wr_raw, c("RecYDS_G")),
      team_rec_yards_share = pick_first_existing_numeric(wr_raw, c("TM_RecYDS_PCT")),
      yards_per_route_source = pick_first_existing_numeric(wr_raw, c("YPRR")),
      yards_per_target_source = pick_first_existing_numeric(wr_raw, c("YPT")),
      yards_per_reception_source = pick_first_existing_numeric(wr_raw, c("YPR")),
      yac_total = pick_first_existing_numeric(wr_raw, c("YAC")),
      yac_per_reception_source = pick_first_existing_numeric(wr_raw, c("YAC_REC")),
      yaco_rec = pick_first_existing_numeric(wr_raw, c("YACO_rec", "YACO_REC")),
      receiving_td = pick_first_existing_numeric(wr_raw, c("TD", "TD_ply")),
      team_rec_td_share = pick_first_existing_numeric(wr_raw, c("TM_Rec_TD_PCT", "TM_RecTD_PCT")),
      end_zone_targets = pick_first_existing_numeric(wr_raw, c("EZTGT")),
      end_zone_tds = pick_first_existing_numeric(wr_raw, c("EZTD")),
      first_read_targets = pick_first_existing_numeric(wr_raw, c("X1READ")),
      first_read_target_share = pick_first_existing_numeric(wr_raw, c("X1READ_Rec_PCT", "X1READ_PCT")),
      missed_tackles_forced = pick_first_existing_numeric(wr_raw, c("MTF_rec", "MTF_REC")),
      receiving_first_downs = pick_first_existing_numeric(wr_raw, c("X1D_rec")),
      first_downs_per_route_source = pick_first_existing_numeric(wr_raw, c("X1D_RR")),
      drops = pick_first_existing_numeric(wr_raw, c("DRP")),
      drop_pct = pick_first_existing_numeric(wr_raw, c("DROP_PCT", "DRP_PCT")),
      catchable_targets = pick_first_existing_numeric(wr_raw, c("CTGT")),
      catchable_tgt_pct = pick_first_existing_numeric(wr_raw, c("Catchable_TGT_PCT", "Catchable_TGT_Rate")),
      designed_targets = pick_first_existing_numeric(wr_raw, c("DESIGN")),
      design_pct = pick_first_existing_numeric(wr_raw, c("DESIGN_PCT")),
      contested_targets = pick_first_existing_numeric(wr_raw, c("CT")),
      contested_catches = pick_first_existing_numeric(wr_raw, c("CC")),
      contested_catch_pct = pick_first_existing_numeric(wr_raw, c("Contested_Catch_PCT", "Contested_Catch_Rate")),
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
        pick_first_existing_numeric(wr_raw, c("FP_G_rec"))
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
      target_share_total = dplyr::coalesce(
        .data$target_share_total_source,
        100 * safe_div(.data$targets, .data$team_total_targets_source)
      ),
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
      receiving_yards_per_game = dplyr::coalesce(.data$receiving_yards_per_game_source, safe_div(.data$receiving_yards, 1)),
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
        "targets_primary", "targets_fallback", "team_total_targets_source", "target_share_total_source",
        "targets_per_route_source", "catch_rate_source", "receiving_yards_per_game_source",
        "yards_per_route_source", "yards_per_target_source", "yards_per_reception_source",
        "yac_per_reception_source", "first_downs_per_route_source"
      ))
    ) |>
    dplyr::arrange(.data$season, .data$week, .data$team, .data$player)
  
  wr_weekly <- fill_player_bio_fields(wr_weekly)
  
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
      dplyr::semi_join(
        duplicate_keys,
        by = c("season", "week", "player_key")
      ) |>
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
      .data$season,
      .data$week,
      .data$player_key,
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

build_wr_team_week_opportunity_table <- function(wr_weekly = build_wr_clean_weekly_master(), write_output = FALSE, output_dir = model_paths$foundation_output_dir) {
  load_model_core_packages()
  
  out <- wr_weekly |>
    dplyr::filter(.data$wr_model_eligible) |>
    dplyr::group_by(.data$season, .data$week, .data$team) |>
    dplyr::summarise(
      team_wr_targets = sum(.data$targets, na.rm = TRUE),
      team_wr_receptions = sum(.data$receptions, na.rm = TRUE),
      team_wr_routes = sum(.data$routes, na.rm = TRUE),
      team_wr_receiving_yards = sum(.data$receiving_yards, na.rm = TRUE),
      team_wr_receiving_td = sum(.data$receiving_td, na.rm = TRUE),
      team_wr_air_yards = sum(.data$air_yards, na.rm = TRUE),
      team_wr_end_zone_targets = sum(.data$end_zone_targets, na.rm = TRUE),
      team_wr_first_read_targets = sum(.data$first_read_targets, na.rm = TRUE),
      team_wr_first_downs = sum(.data$receiving_first_downs, na.rm = TRUE),
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
    dplyr::filter(.data$wr_model_eligible) |>
    dplyr::left_join(team_week, by = c("season", "week", "team")) |>
    dplyr::mutate(
      team_wr_target_share = safe_div(.data$targets, .data$team_wr_targets),
      team_wr_reception_share = safe_div(.data$receptions, .data$team_wr_receptions),
      team_wr_route_share = safe_div(.data$routes, .data$team_wr_routes),
      team_wr_rec_yard_share = safe_div(.data$receiving_yards, .data$team_wr_receiving_yards),
      team_wr_td_share = safe_div(.data$receiving_td, .data$team_wr_receiving_td),
      team_wr_air_yard_share = safe_div(.data$air_yards, .data$team_wr_air_yards),
      team_wr_ez_target_share = safe_div(.data$end_zone_targets, .data$team_wr_end_zone_targets),
      team_wr_first_read_share = safe_div(.data$first_read_targets, .data$team_wr_first_read_targets),
      team_wr_first_down_share = safe_div(.data$receiving_first_downs, .data$team_wr_first_downs),
      team_wr_fantasy_share = safe_div(.data$half_ppr_points, .data$team_wr_half_ppr),
      starter_flag = dplyr::if_else(!is.na(.data$depth_team) & .data$depth_team <= 2, 1L, 0L),
      primary_role_flag = dplyr::if_else(!is.na(.data$depth_team) & .data$depth_team <= 1, 1L, 0L)
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

build_wr_weekly_role_usage_table <- function(
    wr_share = build_wr_player_share_table(),
    write_output = FALSE,
    output_dir = model_paths$foundation_output_dir
) {
  load_model_core_packages()
  
  out <- wr_share |>
    dplyr::transmute(
      season,
      week,
      player,
      player_key,
      team,
      opponent,
      position,
      wr_model_eligible,
      depth_team,
      wr_depth_role,
      starter_flag,
      primary_role_flag,
      draft_day,
      report_status,
      practice_primary_injury,
      practice_secondary_injury,
      practice_status,
      rookie_year,
      age,
      routes,
      targets,
      receptions,
      receiving_yards,
      receiving_td,
      air_yards,
      end_zone_targets,
      first_read_targets,
      receiving_first_downs,
      rush_attempts,
      rush_yards,
      rush_td,
      total_td,
      scrimmage_yards,
      half_ppr_points,
      target_share_total,
      team_wr_target_share,
      team_wr_route_share,
      team_wr_rec_yard_share,
      team_wr_air_yard_share,
      team_wr_first_read_share,
      team_wr_first_down_share,
      team_wr_fantasy_share
    )
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "wr_weekly_role_usage_2021_2025_regular.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_wr_player_season_combined_table <- function(
    wr_weekly = build_wr_clean_weekly_master(),
    wr_share = build_wr_player_share_table(wr_weekly = wr_weekly),
    write_output = FALSE,
    output_dir = model_paths$foundation_output_dir
) {
  load_model_core_packages()
  
  out <- wr_share |>
    dplyr::filter(.data$wr_model_eligible) |>
    dplyr::arrange(.data$season, .data$player_key, .data$week) |>
    dplyr::group_by(.data$season, .data$player_key) |>
    dplyr::summarise(
      player = first_non_missing(rev(.data$player)),
      team = first_non_missing(rev(.data$team)),
      teams_played = paste(unique(.data$team[!is.na(.data$team) & .data$team != ""]), collapse = "/"),
      games = dplyr::n_distinct(.data$week),
      starter_weeks = sum(.data$starter_flag, na.rm = TRUE),
      primary_role_weeks = sum(.data$primary_role_flag, na.rm = TRUE),
      best_depth_team = suppressWarnings(min(.data$depth_team, na.rm = TRUE)),
      wr_depth_role = first_non_missing(rev(.data$wr_depth_role)),
      draft_day = first_non_missing(rev(.data$draft_day)),
      rookie_year = suppressWarnings(min(.data$rookie_year, na.rm = TRUE)),
      age = suppressWarnings(max(.data$age, na.rm = TRUE)),
      routes = sum(.data$routes, na.rm = TRUE),
      targets = sum(.data$targets, na.rm = TRUE),
      receptions = sum(.data$receptions, na.rm = TRUE),
      receiving_yards = sum(.data$receiving_yards, na.rm = TRUE),
      receiving_td = sum(.data$receiving_td, na.rm = TRUE),
      air_yards = sum(.data$air_yards, na.rm = TRUE),
      end_zone_targets = sum(.data$end_zone_targets, na.rm = TRUE),
      first_read_targets = sum(.data$first_read_targets, na.rm = TRUE),
      receiving_first_downs = sum(.data$receiving_first_downs, na.rm = TRUE),
      rush_attempts = sum(.data$rush_attempts, na.rm = TRUE),
      rush_yards = sum(.data$rush_yards, na.rm = TRUE),
      rush_td = sum(.data$rush_td, na.rm = TRUE),
      total_td = sum(.data$total_td, na.rm = TRUE),
      scrimmage_yards = sum(.data$scrimmage_yards, na.rm = TRUE),
      fantasy_points = sum(.data$half_ppr_points, na.rm = TRUE),
      fantasy_points_per_game = ifelse(
        sum(!is.na(.data$half_ppr_points)) > 0,
        mean(.data$half_ppr_points, na.rm = TRUE),
        NA_real_
      ),
      fantasy_points_sd = stats::sd(.data$half_ppr_points, na.rm = TRUE),
      weekly_floor_p10 = suppressWarnings(stats::quantile(.data$half_ppr_points, probs = 0.10, na.rm = TRUE, names = FALSE)),
      weekly_floor_p25 = suppressWarnings(stats::quantile(.data$half_ppr_points, probs = 0.25, na.rm = TRUE, names = FALSE)),
      weekly_median_p50 = suppressWarnings(stats::quantile(.data$half_ppr_points, probs = 0.50, na.rm = TRUE, names = FALSE)),
      weekly_ceiling_p75 = suppressWarnings(stats::quantile(.data$half_ppr_points, probs = 0.75, na.rm = TRUE, names = FALSE)),
      weekly_ceiling_p90 = suppressWarnings(stats::quantile(.data$half_ppr_points, probs = 0.90, na.rm = TRUE, names = FALSE)),
      weekly_spike_15_rate = mean(.data$half_ppr_points >= 15, na.rm = TRUE),
      weekly_spike_20_rate = mean(.data$half_ppr_points >= 20, na.rm = TRUE),
      weekly_bust_under8_rate = mean(.data$half_ppr_points < 8, na.rm = TRUE),
      team_total_target_share_mean = mean(.data$target_share_total, na.rm = TRUE),
      team_wr_target_share_mean = mean(.data$team_wr_target_share, na.rm = TRUE),
      team_wr_reception_share_mean = mean(.data$team_wr_reception_share, na.rm = TRUE),
      team_wr_route_share_mean = mean(.data$team_wr_route_share, na.rm = TRUE),
      team_wr_rec_yard_share_mean = mean(.data$team_wr_rec_yard_share, na.rm = TRUE),
      team_wr_td_share_mean = mean(.data$team_wr_td_share, na.rm = TRUE),
      team_wr_air_yard_share_mean = mean(.data$team_wr_air_yard_share, na.rm = TRUE),
      team_wr_ez_target_share_mean = mean(.data$team_wr_ez_target_share, na.rm = TRUE),
      team_wr_first_read_share_mean = mean(.data$team_wr_first_read_share, na.rm = TRUE),
      team_wr_first_down_share_mean = mean(.data$team_wr_first_down_share, na.rm = TRUE),
      team_wr_fantasy_share_mean = mean(.data$team_wr_fantasy_share, na.rm = TRUE),
      .groups = "drop"
    ) |>
    dplyr::mutate(
      best_depth_team = ifelse(is.infinite(.data$best_depth_team), NA, .data$best_depth_team),
      rookie_year = ifelse(is.infinite(.data$rookie_year), NA, .data$rookie_year),
      age = ifelse(is.infinite(.data$age), NA, .data$age),
      qualified_4_games_current = .data$games >= 4,
      qualified_8_games_current = .data$games >= 8,
      next_season = .data$season + 1L,
      starter_rate = safe_div(.data$starter_weeks, .data$games),
      primary_role_rate = safe_div(.data$primary_role_weeks, .data$games),
      targets_per_game = safe_div(.data$targets, .data$games),
      routes_per_game = safe_div(.data$routes, .data$games),
      receptions_per_game = safe_div(.data$receptions, .data$games),
      receiving_yards_per_game = safe_div(.data$receiving_yards, .data$games),
      receiving_td_per_game = safe_div(.data$receiving_td, .data$games),
      air_yards_per_game = safe_div(.data$air_yards, .data$games),
      end_zone_targets_per_game = safe_div(.data$end_zone_targets, .data$games),
      first_read_targets_per_game = safe_div(.data$first_read_targets, .data$games),
      first_downs_per_game = safe_div(.data$receiving_first_downs, .data$games),
      rush_yards_per_game = safe_div(.data$rush_yards, .data$games),
      total_td_per_game = safe_div(.data$total_td, .data$games),
      scrimmage_yards_per_game = safe_div(.data$scrimmage_yards, .data$games),
      targets_per_route = safe_div(.data$targets, .data$routes),
      catch_rate = 100 * safe_div(.data$receptions, .data$targets),
      yards_per_route = safe_div(.data$receiving_yards, .data$routes),
      yards_per_target = safe_div(.data$receiving_yards, .data$targets),
      yards_per_reception = safe_div(.data$receiving_yards, .data$receptions),
      air_yards_per_target = safe_div(.data$air_yards, .data$targets),
      yac_per_reception = safe_div(.data$receiving_yards - .data$air_yards, .data$receptions),
      first_downs_per_target = safe_div(.data$receiving_first_downs, .data$targets),
      first_reads_per_target = safe_div(.data$first_read_targets, .data$targets),
      td_per_target = safe_div(.data$receiving_td, .data$targets),
      end_zone_target_rate = safe_div(.data$end_zone_targets, .data$targets)
    ) |>
    dplyr::arrange(.data$season, dplyr::desc(.data$fantasy_points_per_game), .data$player)
  
  duplicate_player_seasons <- out |>
    dplyr::count(.data$season, .data$player_key, name = "dup_n") |>
    dplyr::filter(.data$dup_n > 1)
  
  if (nrow(duplicate_player_seasons) > 0) {
    stop(
      paste0(
        "WR player-season table has ", nrow(duplicate_player_seasons),
        " duplicate player-season keys after aggregation."
      ),
      call. = FALSE
    )
  }
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "wr_player_season_combined_table_2021_2025_regular.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_wr_sos_inputs <- function(write_output = FALSE) {
  load_model_core_packages()
  
  wr_clean_weekly_master <- build_wr_clean_weekly_master(write_output = write_output)
  wr_team_week_opportunity <- build_wr_team_week_opportunity_table(
    wr_weekly = wr_clean_weekly_master,
    write_output = write_output
  )
  wr_player_share_table <- build_wr_player_share_table(
    wr_weekly = wr_clean_weekly_master,
    team_week = wr_team_week_opportunity,
    write_output = write_output
  )
  wr_weekly_role_usage <- build_wr_weekly_role_usage_table(
    wr_share = wr_player_share_table,
    write_output = write_output
  )
  wr_player_season_combined_table <- build_wr_player_season_combined_table(
    wr_weekly = wr_clean_weekly_master,
    wr_share = wr_player_share_table,
    write_output = write_output
  )
  
  out <- list(
    position = "WR",
    mode = "season_over_season",
    handoff = wr_sos_handoff,
    handoff_text = read_text_from_handoff(wr_sos_handoff),
    wr_clean_weekly_master = wr_clean_weekly_master,
    wr_team_week_opportunity = wr_team_week_opportunity,
    wr_player_share_table = wr_player_share_table,
    wr_weekly_role_usage = wr_weekly_role_usage,
    wr_player_season_combined_table = wr_player_season_combined_table,
    player_season_index = build_sos_player_season_index("WR"),
    next_steps = c(
      "Build WR next-season targets from the player-season combined table.",
      "Translate WR first-down, target-earning, and role-context features into baseline, weighted, and anchor stages.",
      "Tune the WR production board weights before moving into WR WOW."
    )
  )
  
  if (write_output) {
    out$output_paths <- c(
      wr_clean_weekly_master = file.path(model_paths$foundation_output_dir, "wr_clean_weekly_master_2021_2025_regular.csv"),
      wr_team_week_opportunity = file.path(model_paths$foundation_output_dir, "wr_team_week_opportunity_2021_2025_regular.csv"),
      wr_player_share_table = file.path(model_paths$foundation_output_dir, "wr_player_share_table_2021_2025_regular.csv"),
      wr_weekly_role_usage = file.path(model_paths$foundation_output_dir, "wr_weekly_role_usage_2021_2025_regular.csv"),
      wr_player_season_combined_table = file.path(model_paths$foundation_output_dir, "wr_player_season_combined_table_2021_2025_regular.csv"),
      wr_player_season_index = write_sos_player_season_index("WR")
    )
  }
  
  out
}

make_wr_sos_output_manifest <- function(wr_sos_result) {
  output_paths <- unname(wr_sos_result$output_paths %||% character())
  output_labels <- names(wr_sos_result$output_paths %||% character())
  
  data.frame(
    output_name = output_labels,
    output_path = output_paths,
    exists = file.exists(output_paths),
    stringsAsFactors = FALSE
  )
}

run_wr_sos_pipeline <- function(write_output = TRUE) {
  load_model_core_packages()
  
  dir.create(model_paths$foundation_output_dir, recursive = TRUE, showWarnings = FALSE)
  dir.create(model_paths$sos_output_dir, recursive = TRUE, showWarnings = FALSE)
  
  wr_sos_result <- build_wr_sos_inputs(write_output = write_output)
  output_manifest <- make_wr_sos_output_manifest(wr_sos_result)
  
  list(
    result = wr_sos_result,
    output_manifest = output_manifest
  )
}

build_wr_sos_target_table <- function(
    wr_player_season_combined_table = NULL,
    write_output = FALSE,
    output_dir = model_paths$sos_output_dir
) {
  load_model_core_packages()
  
  if (is.null(wr_player_season_combined_table)) {
    wr_player_season_combined_table <- build_wr_player_season_combined_table(write_output = FALSE)
  }
  
  out <- wr_player_season_combined_table |>
    dplyr::group_by(.data$season) |>
    dplyr::arrange(
      dplyr::desc(.data$fantasy_points),
      dplyr::desc(.data$fantasy_points_per_game),
      .data$player,
      .by_group = TRUE
    ) |>
    dplyr::mutate(
      target_next_points_rank_all = dplyr::row_number(),
      next_top12_points_all = as.integer(.data$target_next_points_rank_all <= 12),
      next_top24_points_all = as.integer(.data$target_next_points_rank_all <= 24),
      next_top36_points_all = as.integer(.data$target_next_points_rank_all <= 36),
      next_top48_points_all = as.integer(.data$target_next_points_rank_all <= 48)
    ) |>
    dplyr::ungroup() |>
    dplyr::transmute(
      player_key,
      target_next_season = .data$season,
      target_next_team = .data$team,
      target_next_games = .data$games,
      target_next_points_rank_all,
      target_next_total_points = .data$fantasy_points,
      target_next_ppg = .data$fantasy_points_per_game,
      next_top12_points_all,
      next_top24_points_all,
      next_top36_points_all,
      next_top48_points_all,
      qualified_4_games_next = as.integer(.data$target_next_games >= 4),
      qualified_8_games_next = as.integer(.data$target_next_games >= 8)
    )
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "wr_sos_target_table_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_wr_sos_training_frame <- function(
    write_output = FALSE,
    output_dir = model_paths$sos_output_dir,
    max_source_season = 2024L
) {
  load_model_core_packages()
  
  wr_player_season_combined_table <- build_wr_player_season_combined_table(write_output = FALSE)
  wr_sos_target_table <- build_wr_sos_target_table(wr_player_season_combined_table, write_output = FALSE)
  
  out <- wr_player_season_combined_table |>
    dplyr::mutate(
      target_next_season = .data$next_season,
      qualified_4_games_current = as.integer(.data$games >= 4),
      qualified_8_games_current = as.integer(.data$games >= 8)
    ) |>
    dplyr::left_join(
      wr_sos_target_table,
      by = c("player_key", "target_next_season"),
      relationship = "many-to-one"
    ) |>
    dplyr::mutate(
      made_next_season = as.integer(!is.na(.data$target_next_ppg)),
      team_changed_next_season = dplyr::if_else(
        !is.na(.data$target_next_team) & .data$team != .data$target_next_team,
        1L,
        0L,
        missing = 0L
      )
    ) |>
    dplyr::filter(.data$season >= 2021, .data$season <= .env$max_source_season) |>
    dplyr::arrange(.data$season, dplyr::desc(.data$fantasy_points_per_game), .data$player)
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "wr_sos_training_frame_2021_2024_to_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

make_wr_sos_training_manifest <- function() {
  data.frame(
    output_name = c("wr_sos_target_table", "wr_sos_training_frame"),
    output_path = c(
      file.path(model_paths$sos_output_dir, "wr_sos_target_table_2022_2025.csv"),
      file.path(model_paths$sos_output_dir, "wr_sos_training_frame_2021_2024_to_2022_2025.csv")
    ),
    exists = c(
      file.exists(file.path(model_paths$sos_output_dir, "wr_sos_target_table_2022_2025.csv")),
      file.exists(file.path(model_paths$sos_output_dir, "wr_sos_training_frame_2021_2024_to_2022_2025.csv"))
    ),
    stringsAsFactors = FALSE
  )
}

run_wr_sos_training_step <- function(write_output = TRUE) {
  load_model_core_packages()
  
  dir.create(model_paths$sos_output_dir, recursive = TRUE, showWarnings = FALSE)
  
  wr_sos_target_table <- build_wr_sos_target_table(write_output = write_output)
  wr_sos_training_frame <- build_wr_sos_training_frame(write_output = write_output)
  
  list(
    wr_sos_target_table = wr_sos_target_table,
    wr_sos_training_frame = wr_sos_training_frame,
    output_manifest = make_wr_sos_training_manifest()
  )
}

build_wr_sos_baseline_feature_set <- function() {
  load_model_core_packages()
  
  model_df <- build_wr_sos_training_frame(write_output = FALSE)
  non_numeric_cols <- c("player_key", "player", "team", "target_next_team", "draft_day", "wr_depth_role")
  numeric_cols <- setdiff(names(model_df), non_numeric_cols)
  
  model_df |>
    dplyr::mutate(
      dplyr::across(dplyr::any_of(numeric_cols), safe_numeric),
      target_next_ppg = safe_numeric(.data$target_next_ppg),
      target_next_total_points = safe_numeric(.data$target_next_total_points),
      qualified_4_games_next = safe_numeric(.data$qualified_4_games_next),
      qualified_8_games_next = safe_numeric(.data$qualified_8_games_next)
    )
}

run_wr_sos_baseline_model_step <- function(
    write_output = TRUE,
    output_dir = model_paths$sos_output_dir
) {
  load_model_core_packages()
  
  model_df <- build_wr_sos_baseline_feature_set()
  
  predictor_cols <- c(
    "games",
    "starter_weeks",
    "primary_role_weeks",
    "best_depth_team",
    "age",
    "rookie_year",
    "routes",
    "targets",
    "receptions",
    "receiving_yards",
    "receiving_td",
    "air_yards",
    "end_zone_targets",
    "first_read_targets",
    "receiving_first_downs",
    "rush_attempts",
    "rush_yards",
    "rush_td",
    "total_td",
    "scrimmage_yards",
    "fantasy_points",
    "fantasy_points_per_game",
    "fantasy_points_sd",
    "weekly_floor_p10",
    "weekly_floor_p25",
    "weekly_median_p50",
    "weekly_ceiling_p75",
    "weekly_ceiling_p90",
    "weekly_spike_15_rate",
    "weekly_spike_20_rate",
    "weekly_bust_under8_rate",
    "team_total_target_share_mean",
    "team_wr_target_share_mean",
    "team_wr_reception_share_mean",
    "team_wr_route_share_mean",
    "team_wr_rec_yard_share_mean",
    "team_wr_td_share_mean",
    "team_wr_air_yard_share_mean",
    "team_wr_ez_target_share_mean",
    "team_wr_first_read_share_mean",
    "team_wr_first_down_share_mean",
    "team_wr_fantasy_share_mean",
    "starter_rate",
    "primary_role_rate",
    "targets_per_game",
    "routes_per_game",
    "receptions_per_game",
    "receiving_yards_per_game",
    "receiving_td_per_game",
    "air_yards_per_game",
    "end_zone_targets_per_game",
    "first_read_targets_per_game",
    "first_downs_per_game",
    "rush_yards_per_game",
    "total_td_per_game",
    "scrimmage_yards_per_game",
    "targets_per_route",
    "catch_rate",
    "yards_per_route",
    "yards_per_target",
    "yards_per_reception",
    "air_yards_per_target",
    "yac_per_reception",
    "first_downs_per_target",
    "first_reads_per_target",
    "td_per_target",
    "end_zone_target_rate",
    "qualified_4_games_current",
    "qualified_8_games_current",
    "team_changed_next_season"
  )
  
  predictor_cols <- intersect(predictor_cols, names(model_df))
  
  predict_seasons <- sort(unique(model_df$target_next_season))
  predict_seasons <- predict_seasons[predict_seasons >= 2022 & predict_seasons <= 2025]
  
  prediction_list <- list()
  metric_list <- list()
  pred_idx <- 1L
  metric_idx <- 1L
  
  for (predict_season in predict_seasons) {
    train_df <- model_df |>
      dplyr::filter(
        target_next_season < predict_season,
        !is.na(.data$target_next_ppg),
        !is.na(.data$target_next_total_points)
      )
    
    test_df <- model_df |>
      dplyr::filter(
        target_next_season == predict_season,
        !is.na(.data$target_next_ppg),
        !is.na(.data$target_next_total_points)
      )
    
    if (nrow(train_df) == 0 || nrow(test_df) == 0) {
      next
    }
    
    imputed <- impute_numeric_medians(train_df, test_df, predictor_cols)
    train_df <- imputed$train
    test_df <- imputed$test
    
    ppg_formula <- stats::reformulate(predictor_cols, response = "target_next_ppg")
    total_formula <- stats::reformulate(predictor_cols, response = "target_next_total_points")
    
    ppg_model <- stats::lm(ppg_formula, data = train_df)
    total_model <- stats::lm(total_formula, data = train_df)
    
    pred_next_ppg <- as.numeric(stats::predict(ppg_model, newdata = test_df))
    pred_next_total_points <- as.numeric(stats::predict(total_model, newdata = test_df))
    
    fold_predictions <- test_df |>
      dplyr::transmute(
        train_through_season = predict_season - 1L,
        predict_season = .data$target_next_season,
        source_season = .data$season,
        player_key,
        player,
        current_team = .data$team,
        next_team = .data$target_next_team,
        target_next_games = .data$target_next_games,
        qualified_4_games_current,
        qualified_8_games_current,
        qualified_4_games_next,
        qualified_8_games_next,
        target_next_ppg,
        pred_next_ppg,
        target_next_total_points,
        pred_next_total_points
      )
    
    prediction_list[[pred_idx]] <- fold_predictions
    pred_idx <- pred_idx + 1L
    
    overall_ppg <- calc_regression_metrics(fold_predictions$target_next_ppg, fold_predictions$pred_next_ppg)
    overall_ppg$predict_season <- predict_season
    overall_ppg$target <- "target_next_ppg"
    overall_ppg$sample <- "overall"
    metric_list[[metric_idx]] <- overall_ppg
    metric_idx <- metric_idx + 1L
    
    overall_total <- calc_regression_metrics(fold_predictions$target_next_total_points, fold_predictions$pred_next_total_points)
    overall_total$predict_season <- predict_season
    overall_total$target <- "target_next_total_points"
    overall_total$sample <- "overall"
    metric_list[[metric_idx]] <- overall_total
    metric_idx <- metric_idx + 1L
    
    keep_4_4 <- fold_predictions$qualified_4_games_current == 1 & fold_predictions$qualified_4_games_next == 1
    
    qual_ppg <- calc_regression_metrics(
      fold_predictions$target_next_ppg[keep_4_4],
      fold_predictions$pred_next_ppg[keep_4_4]
    )
    qual_ppg$predict_season <- predict_season
    qual_ppg$target <- "target_next_ppg"
    qual_ppg$sample <- "qualified_4_4"
    metric_list[[metric_idx]] <- qual_ppg
    metric_idx <- metric_idx + 1L
    
    qual_total <- calc_regression_metrics(
      fold_predictions$target_next_total_points[keep_4_4],
      fold_predictions$pred_next_total_points[keep_4_4]
    )
    qual_total$predict_season <- predict_season
    qual_total$target <- "target_next_total_points"
    qual_total$sample <- "qualified_4_4"
    metric_list[[metric_idx]] <- qual_total
    metric_idx <- metric_idx + 1L
  }
  
  predictions <- dplyr::bind_rows(prediction_list)
  metrics <- dplyr::bind_rows(metric_list) |>
    dplyr::select(predict_season, target, sample, n, mae, rmse, spearman) |>
    dplyr::arrange(predict_season, target, sample)
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    
    utils::write.csv(
      predictions,
      file.path(output_dir, "wr_sos_baseline_predictions_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    
    utils::write.csv(
      metrics,
      file.path(output_dir, "wr_sos_baseline_metrics_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    predictions = predictions,
    metrics = metrics
  )
}

build_wr_sos_weighted_two_year_frame <- function() {
  load_model_core_packages()
  
  wr_season <- build_wr_player_season_combined_table(write_output = FALSE) |>
    dplyr::arrange(.data$season, dplyr::desc(.data$fantasy_points_per_game), .data$player)
  
  wr_target_frame <- wr_season |>
    dplyr::transmute(
      player_key,
      target_next_season = .data$season,
      target_next_team = .data$team,
      target_next_games = .data$games,
      target_next_ppg = .data$fantasy_points_per_game,
      target_next_total_points = .data$fantasy_points,
      qualified_4_games_next = as.integer(.data$games >= 4),
      qualified_8_games_next = as.integer(.data$games >= 8)
    )
  
  wr_prior_frame <- wr_season |>
    dplyr::transmute(
      player_key,
      season = .data$season + 1L,
      prior_ppg = .data$fantasy_points_per_game,
      prior_total_points = .data$fantasy_points
    )
  
  wr_season |>
    dplyr::mutate(
      target_next_season = .data$season + 1L
    ) |>
    dplyr::left_join(
      wr_target_frame,
      by = c("player_key", "target_next_season"),
      relationship = "many-to-one"
    ) |>
    dplyr::left_join(
      wr_prior_frame,
      by = c("player_key", "season"),
      relationship = "many-to-one"
    ) |>
    dplyr::mutate(
      weighted_two_year_ppg = dplyr::case_when(
        !is.na(.data$fantasy_points_per_game) & !is.na(.data$prior_ppg) ~ 0.65 * .data$fantasy_points_per_game + 0.35 * .data$prior_ppg,
        !is.na(.data$fantasy_points_per_game) ~ .data$fantasy_points_per_game,
        TRUE ~ .data$prior_ppg
      ),
      weighted_two_year_total_points = dplyr::case_when(
        !is.na(.data$fantasy_points) & !is.na(.data$prior_total_points) ~ 0.65 * .data$fantasy_points + 0.35 * .data$prior_total_points,
        !is.na(.data$fantasy_points) ~ .data$fantasy_points,
        TRUE ~ .data$prior_total_points
      )
    ) |>
    dplyr::filter(
      .data$target_next_season >= 2022,
      .data$target_next_season <= 2025,
      !is.na(.data$target_next_ppg),
      !is.na(.data$target_next_total_points)
    ) |>
    dplyr::arrange(.data$target_next_season, dplyr::desc(.data$weighted_two_year_ppg), .data$player)
}

run_wr_sos_weighted_two_year_baseline <- function(write_output = TRUE, output_dir = model_paths$sos_output_dir) {
  load_model_core_packages()
  
  predictions <- build_wr_sos_weighted_two_year_frame() |>
    dplyr::transmute(
      predict_season = .data$target_next_season,
      source_season = .data$season,
      player_key,
      player,
      current_team = .data$team,
      next_team = .data$target_next_team,
      qualified_4_games_current,
      qualified_8_games_current,
      qualified_4_games_next,
      qualified_8_games_next,
      target_next_ppg,
      pred_next_ppg = .data$weighted_two_year_ppg,
      target_next_total_points,
      pred_next_total_points = .data$weighted_two_year_total_points
    )
  
  metric_list <- list()
  idx <- 1L
  
  for (predict_season in sort(unique(predictions$predict_season))) {
    fold_df <- predictions |>
      dplyr::filter(.data$predict_season == .env$predict_season)
    
    overall_ppg <- calc_regression_metrics(fold_df$target_next_ppg, fold_df$pred_next_ppg)
    overall_ppg$predict_season <- predict_season
    overall_ppg$target <- "target_next_ppg"
    overall_ppg$sample <- "overall"
    metric_list[[idx]] <- overall_ppg
    idx <- idx + 1L
    
    qual_df <- fold_df |>
      dplyr::filter(.data$qualified_4_games_current == 1, .data$qualified_4_games_next == 1)
    
    qual_ppg <- calc_regression_metrics(qual_df$target_next_ppg, qual_df$pred_next_ppg)
    qual_ppg$predict_season <- predict_season
    qual_ppg$target <- "target_next_ppg"
    qual_ppg$sample <- "qualified_4_4"
    metric_list[[idx]] <- qual_ppg
    idx <- idx + 1L
    
    overall_total <- calc_regression_metrics(fold_df$target_next_total_points, fold_df$pred_next_total_points)
    overall_total$predict_season <- predict_season
    overall_total$target <- "target_next_total_points"
    overall_total$sample <- "overall"
    metric_list[[idx]] <- overall_total
    idx <- idx + 1L
    
    qual_total <- calc_regression_metrics(qual_df$target_next_total_points, qual_df$pred_next_total_points)
    qual_total$predict_season <- predict_season
    qual_total$target <- "target_next_total_points"
    qual_total$sample <- "qualified_4_4"
    metric_list[[idx]] <- qual_total
    idx <- idx + 1L
  }
  
  metrics <- dplyr::bind_rows(metric_list) |>
    dplyr::select(predict_season, target, sample, n, mae, rmse, spearman) |>
    dplyr::arrange(predict_season, target, sample)
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    
    utils::write.csv(
      predictions,
      file.path(output_dir, "wr_sos_weighted_two_year_predictions_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    
    utils::write.csv(
      metrics,
      file.path(output_dir, "wr_sos_weighted_two_year_metrics_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    predictions = predictions,
    metrics = metrics
  )
}

run_wr_sos_hybrid_baseline <- function(
    wr_sos_baseline,
    wr_sos_weighted,
    write_output = TRUE,
    output_dir = model_paths$sos_output_dir
) {
  load_model_core_packages()
  
  hybrid_predictions <- wr_sos_weighted$predictions |>
    dplyr::left_join(
      wr_sos_baseline$predictions |>
        dplyr::select(
          predict_season,
          player_key,
          pred_next_ppg_linear = pred_next_ppg,
          pred_next_total_points_linear = pred_next_total_points
        ),
      by = c("predict_season", "player_key")
    ) |>
    dplyr::mutate(
      pred_next_ppg = 0.70 * .data$pred_next_ppg + 0.30 * .data$pred_next_ppg_linear,
      pred_next_total_points = 0.70 * .data$pred_next_total_points + 0.30 * .data$pred_next_total_points_linear
    )
  
  metric_list <- list()
  idx <- 1L
  
  for (predict_season in sort(unique(hybrid_predictions$predict_season))) {
    fold_df <- hybrid_predictions |>
      dplyr::filter(.data$predict_season == .env$predict_season)
    
    overall_ppg <- calc_regression_metrics(fold_df$target_next_ppg, fold_df$pred_next_ppg)
    overall_ppg$predict_season <- predict_season
    overall_ppg$target <- "target_next_ppg"
    overall_ppg$sample <- "overall"
    metric_list[[idx]] <- overall_ppg
    idx <- idx + 1L
    
    qual_df <- fold_df |>
      dplyr::filter(.data$qualified_4_games_current == 1, .data$qualified_4_games_next == 1)
    
    qual_ppg <- calc_regression_metrics(qual_df$target_next_ppg, qual_df$pred_next_ppg)
    qual_ppg$predict_season <- predict_season
    qual_ppg$target <- "target_next_ppg"
    qual_ppg$sample <- "qualified_4_4"
    metric_list[[idx]] <- qual_ppg
    idx <- idx + 1L
    
    overall_total <- calc_regression_metrics(fold_df$target_next_total_points, fold_df$pred_next_total_points)
    overall_total$predict_season <- predict_season
    overall_total$target <- "target_next_total_points"
    overall_total$sample <- "overall"
    metric_list[[idx]] <- overall_total
    idx <- idx + 1L
    
    qual_total <- calc_regression_metrics(qual_df$target_next_total_points, qual_df$pred_next_total_points)
    qual_total$predict_season <- predict_season
    qual_total$target <- "target_next_total_points"
    qual_total$sample <- "qualified_4_4"
    metric_list[[idx]] <- qual_total
    idx <- idx + 1L
  }
  
  hybrid_metrics <- dplyr::bind_rows(metric_list) |>
    dplyr::select(predict_season, target, sample, n, mae, rmse, spearman) |>
    dplyr::arrange(predict_season, target, sample)
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    
    utils::write.csv(
      hybrid_predictions,
      file.path(output_dir, "wr_sos_hybrid_baseline_predictions_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    
    utils::write.csv(
      hybrid_metrics,
      file.path(output_dir, "wr_sos_hybrid_baseline_metrics_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    predictions = hybrid_predictions,
    metrics = hybrid_metrics
  )
}

compare_wr_sos_models <- function(wr_sos_baseline, wr_sos_weighted) {
  dplyr::bind_rows(
    wr_sos_baseline$metrics |>
      dplyr::mutate(model = "linear_baseline"),
    wr_sos_weighted$metrics |>
      dplyr::mutate(model = "weighted_two_year")
  ) |>
    dplyr::select(model, predict_season, target, sample, n, mae, rmse, spearman) |>
    dplyr::arrange(target, sample, predict_season, model)
}

compare_wr_sos_all_models <- function(wr_sos_baseline, wr_sos_weighted, wr_sos_hybrid) {
  dplyr::bind_rows(
    wr_sos_baseline$metrics |>
      dplyr::mutate(model = "linear_baseline"),
    wr_sos_weighted$metrics |>
      dplyr::mutate(model = "weighted_two_year"),
    wr_sos_hybrid$metrics |>
      dplyr::mutate(model = "hybrid_70_30")
  ) |>
    dplyr::select(model, predict_season, target, sample, n, mae, rmse, spearman) |>
    dplyr::arrange(target, sample, predict_season, model)
}

build_wr_sos_anchor_predictions <- function(
    wr_sos_weighted,
    wr_sos_hybrid,
    write_output = TRUE,
    output_dir = model_paths$sos_output_dir
) {
  load_model_core_packages()
  
  weighted_df <- wr_sos_weighted$predictions |>
    dplyr::rename(
      weighted_pred_next_ppg = pred_next_ppg,
      weighted_pred_next_total_points = pred_next_total_points
    )
  
  hybrid_df <- wr_sos_hybrid$predictions |>
    dplyr::rename(
      hybrid_pred_next_ppg = pred_next_ppg,
      hybrid_pred_next_total_points = pred_next_total_points
    )
  
  out <- dplyr::full_join(
    weighted_df,
    hybrid_df,
    by = c(
      "predict_season",
      "source_season",
      "player_key",
      "player",
      "current_team",
      "next_team",
      "qualified_4_games_current",
      "qualified_8_games_current",
      "qualified_4_games_next",
      "qualified_8_games_next",
      "target_next_ppg",
      "target_next_total_points"
    )
  ) |>
    dplyr::mutate(
      wr_sos_anchor_ppg = dplyr::coalesce(.data$hybrid_pred_next_ppg, .data$weighted_pred_next_ppg),
      wr_sos_anchor_total_points = dplyr::coalesce(.data$weighted_pred_next_total_points, .data$hybrid_pred_next_total_points),
      wr_sos_anchor_model_ppg = dplyr::if_else(!is.na(.data$hybrid_pred_next_ppg), "hybrid_70_30", "weighted_two_year"),
      wr_sos_anchor_model_total_points = dplyr::if_else(!is.na(.data$weighted_pred_next_total_points), "weighted_two_year", "hybrid_70_30")
    ) |>
    dplyr::arrange(.data$predict_season, dplyr::desc(.data$wr_sos_anchor_ppg), .data$player)
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    
    utils::write.csv(
      out,
      file.path(output_dir, "wr_sos_anchor_predictions_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_wr_sos_anchor_metrics <- function(wr_sos_anchor_predictions) {
  load_model_core_packages()
  
  metric_list <- list()
  idx <- 1L
  
  for (predict_season in sort(unique(wr_sos_anchor_predictions$predict_season))) {
    fold_df <- wr_sos_anchor_predictions |>
      dplyr::filter(.data$predict_season == .env$predict_season)
    
    overall_ppg <- calc_regression_metrics(fold_df$target_next_ppg, fold_df$wr_sos_anchor_ppg)
    overall_ppg$predict_season <- predict_season
    overall_ppg$target <- "target_next_ppg"
    overall_ppg$sample <- "overall"
    metric_list[[idx]] <- overall_ppg
    idx <- idx + 1L
    
    qual_df <- fold_df |>
      dplyr::filter(.data$qualified_4_games_current == 1, .data$qualified_4_games_next == 1)
    
    qual_ppg <- calc_regression_metrics(qual_df$target_next_ppg, qual_df$wr_sos_anchor_ppg)
    qual_ppg$predict_season <- predict_season
    qual_ppg$target <- "target_next_ppg"
    qual_ppg$sample <- "qualified_4_4"
    metric_list[[idx]] <- qual_ppg
    idx <- idx + 1L
    
    overall_total <- calc_regression_metrics(fold_df$target_next_total_points, fold_df$wr_sos_anchor_total_points)
    overall_total$predict_season <- predict_season
    overall_total$target <- "target_next_total_points"
    overall_total$sample <- "overall"
    metric_list[[idx]] <- overall_total
    idx <- idx + 1L
    
    qual_total <- calc_regression_metrics(qual_df$target_next_total_points, qual_df$wr_sos_anchor_total_points)
    qual_total$predict_season <- predict_season
    qual_total$target <- "target_next_total_points"
    qual_total$sample <- "qualified_4_4"
    metric_list[[idx]] <- qual_total
    idx <- idx + 1L
  }
  
  dplyr::bind_rows(metric_list) |>
    dplyr::select(predict_season, target, sample, n, mae, rmse, spearman) |>
    dplyr::arrange(predict_season, target, sample)
}

run_wr_sos_anchor_step <- function(wr_sos_weighted, wr_sos_hybrid, write_output = TRUE) {
  load_model_core_packages()
  
  wr_sos_anchor_predictions <- build_wr_sos_anchor_predictions(
    wr_sos_weighted = wr_sos_weighted,
    wr_sos_hybrid = wr_sos_hybrid,
    write_output = write_output
  )
  
  wr_sos_anchor_metrics <- build_wr_sos_anchor_metrics(wr_sos_anchor_predictions)
  
  if (write_output) {
    utils::write.csv(
      wr_sos_anchor_metrics,
      file.path(model_paths$sos_output_dir, "wr_sos_anchor_metrics_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    predictions = wr_sos_anchor_predictions,
    metrics = wr_sos_anchor_metrics
  )
}

build_wr_sos_feature_overlay_table <- function(wr_sos_anchor, max_source_season = 2024L) {
  load_model_core_packages()
  
  wr_anchor_predictions <- if (is.list(wr_sos_anchor) && "predictions" %in% names(wr_sos_anchor)) {
    wr_sos_anchor$predictions
  } else {
    wr_sos_anchor
  }
  
  wr_train <- build_wr_sos_training_frame(
    write_output = FALSE,
    max_source_season = max_source_season
  )
  
  wr_train |>
    dplyr::left_join(
      wr_anchor_predictions |>
        dplyr::select(
          predict_season,
          source_season,
          player_key,
          wr_sos_anchor_ppg,
          wr_sos_anchor_total_points,
          wr_sos_anchor_model_ppg,
          wr_sos_anchor_model_total_points
        ),
      by = c(
        "target_next_season" = "predict_season",
        "season" = "source_season",
        "player_key" = "player_key"
      ),
      relationship = "many-to-one"
    ) |>
    dplyr::mutate(
      starter_rate = dplyr::coalesce(.data$starter_rate, safe_div(.data$starter_weeks, .data$games)),
      primary_role_rate = dplyr::coalesce(.data$primary_role_rate, safe_div(.data$primary_role_weeks, .data$games)),
      total_td_per_game = dplyr::coalesce(.data$total_td_per_game, safe_div(.data$total_td, .data$games)),
      production_component_0to100 = qb_row_mean(
        qb_rank_to_0_100(.data$fantasy_points_per_game),
        qb_rank_to_0_100(.data$fantasy_points),
        qb_rank_to_0_100(.data$receiving_yards_per_game),
        qb_rank_to_0_100(.data$first_downs_per_game),
        qb_rank_to_0_100(.data$first_read_targets_per_game)
      ),
      volume_role_component_0to100 = qb_row_mean(
        qb_rank_to_0_100(.data$targets_per_game),
        qb_rank_to_0_100(.data$routes_per_game),
        qb_rank_to_0_100(.data$receptions_per_game),
        qb_rank_to_0_100(.data$team_total_target_share_mean),
        qb_rank_to_0_100(.data$team_wr_target_share_mean),
        qb_rank_to_0_100(.data$team_wr_route_share_mean)
      ),
      first_down_role_component_0to100 = qb_row_mean(
        qb_rank_to_0_100(.data$first_downs_per_game),
        qb_rank_to_0_100(.data$first_downs_per_target),
        qb_rank_to_0_100(.data$team_wr_first_down_share_mean),
        qb_rank_to_0_100(.data$first_read_targets_per_game),
        qb_rank_to_0_100(.data$team_wr_first_read_share_mean)
      ),
      air_big_play_component_0to100 = qb_row_mean(
        qb_rank_to_0_100(.data$air_yards_per_game),
        qb_rank_to_0_100(.data$team_wr_air_yard_share_mean),
        qb_rank_to_0_100(.data$yards_per_route),
        qb_rank_to_0_100(.data$yards_per_target),
        qb_rank_to_0_100(.data$air_yards_per_target)
      ),
      range_stability_component_0to100 = qb_row_mean(
        qb_rank_to_0_100(.data$weekly_floor_p10),
        qb_rank_to_0_100(.data$weekly_floor_p25),
        qb_rank_to_0_100(.data$weekly_median_p50),
        qb_rank_to_0_100(.data$weekly_ceiling_p75),
        qb_rank_to_0_100(.data$weekly_ceiling_p90),
        qb_rank_to_0_100(.data$fantasy_points_sd, higher_is_better = FALSE),
        qb_rank_to_0_100(.data$weekly_bust_under8_rate, higher_is_better = FALSE)
      ),
      td_context_component_0to100 = qb_row_mean(
        qb_rank_to_0_100(.data$receiving_td_per_game),
        qb_rank_to_0_100(.data$team_wr_td_share_mean),
        qb_rank_to_0_100(.data$end_zone_targets_per_game),
        qb_rank_to_0_100(.data$end_zone_target_rate)
      ),
      age_development_component_0to100 = qb_row_mean(
        wr_age_window_score(.data$age),
        qb_rank_to_0_100(.data$games),
        qb_rank_to_0_100(.data$starter_weeks),
        qb_rank_to_0_100(.data$primary_role_weeks)
      ),
      shrunk_efficiency_component_0to100 = qb_row_mean(
        qb_rank_to_0_100(.data$catch_rate),
        qb_rank_to_0_100(.data$yards_per_route),
        qb_rank_to_0_100(.data$yards_per_target),
        qb_rank_to_0_100(.data$yac_per_reception),
        qb_rank_to_0_100(.data$first_reads_per_target)
      ),
      wr_production_anchor_historical_scaled = qb_row_mean(
        qb_rank_to_0_100(.data$wr_sos_anchor_ppg),
        qb_rank_to_0_100(.data$wr_sos_anchor_total_points),
        .data$production_component_0to100
      ),
      role_context_component_rebalanced = (
        0.26 * .data$volume_role_component_0to100 +
          0.24 * .data$first_down_role_component_0to100 +
          0.20 * .data$air_big_play_component_0to100 +
          0.14 * .data$range_stability_component_0to100 +
          0.08 * .data$shrunk_efficiency_component_0to100 +
          0.08 * .data$td_context_component_0to100
      ),
      wr_preseason_omfg_score = (
        0.80 * .data$wr_production_anchor_historical_scaled +
          0.20 * .data$role_context_component_rebalanced
      ),
      wr_anchor_board_score = qb_row_mean(
        qb_rank_to_0_100(.data$wr_sos_anchor_ppg),
        qb_rank_to_0_100(.data$wr_sos_anchor_total_points),
        .data$wr_preseason_omfg_score
      )
    ) |>
    dplyr::arrange(.data$target_next_season, dplyr::desc(.data$wr_anchor_board_score), .data$player)
}

build_wr_sos_feature_overlay_metrics <- function(wr_sos_feature_overlay) {
  load_model_core_packages()
  
  feature_cols <- c(
    "production_component_0to100",
    "volume_role_component_0to100",
    "first_down_role_component_0to100",
    "air_big_play_component_0to100",
    "range_stability_component_0to100",
    "td_context_component_0to100",
    "age_development_component_0to100",
    "shrunk_efficiency_component_0to100",
    "wr_production_anchor_historical_scaled",
    "role_context_component_rebalanced",
    "wr_preseason_omfg_score",
    "wr_anchor_board_score",
    "wr_sos_anchor_ppg",
    "wr_sos_anchor_total_points"
  )
  
  metric_rows <- list()
  idx <- 1L
  
  for (feature_col in feature_cols) {
    keep_ppg <- is.finite(wr_sos_feature_overlay[[feature_col]]) & is.finite(wr_sos_feature_overlay$target_next_ppg)
    
    metric_rows[[idx]] <- data.frame(
      feature = feature_col,
      target = "target_next_ppg",
      n = sum(keep_ppg),
      spearman = if (sum(keep_ppg) > 1) {
        suppressWarnings(stats::cor(
          wr_sos_feature_overlay[[feature_col]][keep_ppg],
          wr_sos_feature_overlay$target_next_ppg[keep_ppg],
          method = "spearman"
        ))
      } else {
        NA_real_
      },
      stringsAsFactors = FALSE
    )
    idx <- idx + 1L
    
    keep_total <- is.finite(wr_sos_feature_overlay[[feature_col]]) & is.finite(wr_sos_feature_overlay$target_next_total_points)
    
    metric_rows[[idx]] <- data.frame(
      feature = feature_col,
      target = "target_next_total_points",
      n = sum(keep_total),
      spearman = if (sum(keep_total) > 1) {
        suppressWarnings(stats::cor(
          wr_sos_feature_overlay[[feature_col]][keep_total],
          wr_sos_feature_overlay$target_next_total_points[keep_total],
          method = "spearman"
        ))
      } else {
        NA_real_
      },
      stringsAsFactors = FALSE
    )
    idx <- idx + 1L
  }
  
  dplyr::bind_rows(metric_rows) |>
    dplyr::arrange(target, dplyr::desc(spearman), feature)
}

run_wr_sos_feature_overlay_step <- function(
    wr_sos_anchor,
    write_output = TRUE,
    max_source_season = 2024L
) {
  load_model_core_packages()
  
  wr_sos_feature_overlay <- build_wr_sos_feature_overlay_table(
    wr_sos_anchor,
    max_source_season = max_source_season
  )
  wr_sos_feature_metrics <- build_wr_sos_feature_overlay_metrics(wr_sos_feature_overlay)
  
  if (write_output) {
    dir.create(model_paths$sos_output_dir, recursive = TRUE, showWarnings = FALSE)
    
    utils::write.csv(
      wr_sos_feature_overlay,
      file.path(model_paths$sos_output_dir, "wr_sos_feature_overlay_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    
    utils::write.csv(
      wr_sos_feature_metrics,
      file.path(model_paths$sos_output_dir, "wr_sos_feature_overlay_metrics_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    feature_table = wr_sos_feature_overlay,
    metrics = wr_sos_feature_metrics
  )
}

build_wr_sos_board_metrics <- function(wr_sos_production_board) {
  load_model_core_packages()
  
  metric_rows <- list()
  idx <- 1L
  
  for (predict_season in sort(unique(wr_sos_production_board$target_next_season))) {
    fold_df <- wr_sos_production_board |>
      dplyr::filter(.data$target_next_season == .env$predict_season)
    
    keep_ppg <- is.finite(fold_df$wr_sos_rank) & is.finite(fold_df$target_next_ppg)
    
    metric_rows[[idx]] <- data.frame(
      predict_season = predict_season,
      target = "target_next_ppg",
      n = sum(keep_ppg),
      spearman = if (sum(keep_ppg) > 1) {
        suppressWarnings(stats::cor(
          -fold_df$wr_sos_rank[keep_ppg],
          fold_df$target_next_ppg[keep_ppg],
          method = "spearman"
        ))
      } else {
        NA_real_
      },
      stringsAsFactors = FALSE
    )
    idx <- idx + 1L
    
    keep_total <- is.finite(fold_df$wr_sos_rank) & is.finite(fold_df$target_next_total_points)
    
    metric_rows[[idx]] <- data.frame(
      predict_season = predict_season,
      target = "target_next_total_points",
      n = sum(keep_total),
      spearman = if (sum(keep_total) > 1) {
        suppressWarnings(stats::cor(
          -fold_df$wr_sos_rank[keep_total],
          fold_df$target_next_total_points[keep_total],
          method = "spearman"
        ))
      } else {
        NA_real_
      },
      stringsAsFactors = FALSE
    )
    idx <- idx + 1L
  }
  
  dplyr::bind_rows(metric_rows) |>
    dplyr::arrange(predict_season, target)
}

build_wr_sos_weight_candidates <- function() {
  data.frame(
    candidate = c(
      "current_35_25_20_10_10",
      "anchor_heavy_45_20_15_10_10",
      "balanced_30_25_20_15_10",
      "omfg_heavy_30_20_25_15_10",
      "firstdown_heavy_30_20_20_20_10"
    ),
    w_anchor_total = c(0.35, 0.45, 0.30, 0.30, 0.30),
    w_anchor_board = c(0.25, 0.20, 0.25, 0.20, 0.20),
    w_omfg = c(0.20, 0.15, 0.20, 0.25, 0.20),
    w_first_down = c(0.10, 0.10, 0.15, 0.15, 0.20),
    w_volume = c(0.10, 0.10, 0.10, 0.10, 0.10),
    stringsAsFactors = FALSE
  )
}

get_wr_sos_production_candidate <- function() {
  "current_35_25_20_10_10"
}

build_wr_sos_production_board_from_weights <- function(wr_sos_features, weights_row) {
  load_model_core_packages()
  
  feature_table <- if (is.list(wr_sos_features) && "feature_table" %in% names(wr_sos_features)) {
    wr_sos_features$feature_table
  } else {
    wr_sos_features
  }
  
  feature_table |>
    dplyr::mutate(
      wr_sos_final_score = (
        weights_row$w_anchor_total[[1]] * qb_rank_to_0_100(.data$wr_sos_anchor_total_points) +
          weights_row$w_anchor_board[[1]] * .data$wr_anchor_board_score +
          weights_row$w_omfg[[1]] * .data$wr_preseason_omfg_score +
          weights_row$w_first_down[[1]] * .data$first_down_role_component_0to100 +
          weights_row$w_volume[[1]] * .data$volume_role_component_0to100
      )
    ) |>
    dplyr::group_by(.data$target_next_season) |>
    dplyr::arrange(dplyr::desc(.data$wr_sos_final_score), .data$player, .by_group = TRUE) |>
    dplyr::mutate(
      wr_sos_rank = dplyr::row_number()
    ) |>
    dplyr::ungroup()
}

run_wr_sos_production_board_step <- function(wr_sos_features, write_output = TRUE, output_dir = model_paths$sos_output_dir) {
  load_model_core_packages()
  
  production_candidate <- get_wr_sos_production_candidate()
  
  weights_row <- build_wr_sos_weight_candidates() |>
    dplyr::filter(.data$candidate == .env$production_candidate) |>
    dplyr::slice(1)
  
  wr_sos_production_board <- build_wr_sos_production_board_from_weights(wr_sos_features, weights_row) |>
    dplyr::mutate(
      wr_sos_weight_profile = .env$production_candidate,
      wr_sos_tier = dplyr::case_when(
        .data$wr_sos_rank <= 12 ~ "Tier 1",
        .data$wr_sos_rank <= 24 ~ "Tier 2",
        .data$wr_sos_rank <= 36 ~ "Tier 3",
        .data$wr_sos_rank <= 48 ~ "Tier 4",
        TRUE ~ "Tier 5"
      )
    )
  
  wr_sos_board_metrics <- build_wr_sos_board_metrics(wr_sos_production_board)
  
  if (write_output) {
    utils::write.csv(
      wr_sos_production_board,
      file.path(output_dir, "wr_sos_production_board_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    
    utils::write.csv(
      wr_sos_board_metrics,
      file.path(output_dir, "wr_sos_production_board_metrics_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    board = wr_sos_production_board,
    metrics = wr_sos_board_metrics,
    production_candidate = production_candidate
  )
}

run_wr_sos_weight_tuning <- function(wr_sos_features, validation_seasons = 2023:2025, write_output = TRUE) {
  load_model_core_packages()
  
  candidates <- build_wr_sos_weight_candidates()
  
  summary_rows <- list()
  metric_rows <- list()
  board_list <- list()
  
  for (i in seq_len(nrow(candidates))) {
    weights_row <- candidates[i, , drop = FALSE]
    candidate_name <- weights_row$candidate[[1]]
    
    board <- build_wr_sos_production_board_from_weights(wr_sos_features, weights_row)
    metrics <- build_wr_sos_board_metrics(board) |>
      dplyr::mutate(candidate = candidate_name)
    
    board_list[[candidate_name]] <- board
    metric_rows[[i]] <- metrics
    
    val_metrics <- metrics |>
      dplyr::filter(.data$predict_season %in% .env$validation_seasons)
    
    ppg_metrics <- val_metrics |>
      dplyr::filter(.data$target == "target_next_ppg")
    
    total_metrics <- val_metrics |>
      dplyr::filter(.data$target == "target_next_total_points")
    
    summary_rows[[i]] <- data.frame(
      candidate = candidate_name,
      avg_ppg_spearman = mean(ppg_metrics$spearman, na.rm = TRUE),
      min_ppg_spearman = min(ppg_metrics$spearman, na.rm = TRUE),
      avg_total_spearman = mean(total_metrics$spearman, na.rm = TRUE),
      min_total_spearman = min(total_metrics$spearman, na.rm = TRUE),
      combined_score = mean(c(
        mean(ppg_metrics$spearman, na.rm = TRUE),
        mean(total_metrics$spearman, na.rm = TRUE)
      ), na.rm = TRUE),
      stringsAsFactors = FALSE
    )
  }
  
  summary_df <- dplyr::bind_rows(summary_rows) |>
    dplyr::arrange(dplyr::desc(.data$combined_score), dplyr::desc(.data$avg_ppg_spearman), dplyr::desc(.data$avg_total_spearman))
  
  metrics_df <- dplyr::bind_rows(metric_rows) |>
    dplyr::select(candidate, predict_season, target, n, spearman) |>
    dplyr::arrange(candidate, predict_season, target)
  
  if (write_output) {
    utils::write.csv(
      summary_df,
      file.path(model_paths$sos_output_dir, "wr_sos_weight_tuning_summary_2023_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    
    utils::write.csv(
      metrics_df,
      file.path(model_paths$sos_output_dir, "wr_sos_weight_tuning_metrics_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    summary = summary_df,
    metrics = metrics_df,
    boards = board_list
  )
}

build_wr_sos_final_export <- function(wr_sos_board, write_output = TRUE, output_dir = model_paths$sos_output_dir) {
  load_model_core_packages()
  
  board_df <- if (is.list(wr_sos_board) && "board" %in% names(wr_sos_board)) {
    wr_sos_board$board
  } else {
    wr_sos_board
  }
  
  out <- board_df |>
    dplyr::transmute(
      season = .data$target_next_season,
      rank = .data$wr_sos_rank,
      tier = .data$wr_sos_tier,
      player,
      current_team = .data$team,
      next_team = .data$target_next_team,
      games,
      starter_weeks,
      primary_role_weeks,
      age,
      rookie_year,
      weight_profile = .data$wr_sos_weight_profile,
      final_score = .data$wr_sos_final_score,
      anchor_ppg = .data$wr_sos_anchor_ppg,
      anchor_total_points = .data$wr_sos_anchor_total_points,
      preseason_omfg = .data$wr_preseason_omfg_score,
      board_score = .data$wr_anchor_board_score,
      production = .data$production_component_0to100,
      volume_role = .data$volume_role_component_0to100,
      first_down_role = .data$first_down_role_component_0to100,
      air_big_play = .data$air_big_play_component_0to100,
      range_stability = .data$range_stability_component_0to100,
      td_context = .data$td_context_component_0to100,
      age_development = .data$age_development_component_0to100,
      shrunk_efficiency = .data$shrunk_efficiency_component_0to100,
      actual_next_ppg = .data$target_next_ppg,
      actual_next_total_points = .data$target_next_total_points
    ) |>
    dplyr::arrange(.data$season, .data$rank)
  
  if (write_output) {
    utils::write.csv(
      out,
      file.path(output_dir, "wr_sos_final_export_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

run_wr_sos_full_pipeline <- function(write_output = TRUE) {
  load_model_core_packages()
  
  wr_sos_target_table <- build_wr_sos_target_table()
  wr_sos_train <- run_wr_sos_training_step(write_output = write_output)
  wr_sos_baseline <- run_wr_sos_baseline_model_step(write_output = write_output)
  wr_sos_weighted <- run_wr_sos_weighted_two_year_baseline(write_output = write_output)
  wr_sos_compare <- compare_wr_sos_models(wr_sos_baseline, wr_sos_weighted)
  wr_sos_hybrid <- run_wr_sos_hybrid_baseline(wr_sos_baseline, wr_sos_weighted, write_output = write_output)
  wr_sos_all_compare <- compare_wr_sos_all_models(wr_sos_baseline, wr_sos_weighted, wr_sos_hybrid)
  wr_sos_anchor <- run_wr_sos_anchor_step(wr_sos_weighted, wr_sos_hybrid, write_output = write_output)
  wr_sos_features <- run_wr_sos_feature_overlay_step(wr_sos_anchor, write_output = write_output)
  wr_sos_board <- run_wr_sos_production_board_step(wr_sos_features, write_output = write_output)
  wr_sos_tuning <- run_wr_sos_weight_tuning(wr_sos_features, write_output = write_output)
  wr_sos_final_export <- build_wr_sos_final_export(wr_sos_board, write_output = write_output)
  
  list(
    wr_sos_target_table = wr_sos_target_table,
    wr_sos_train = wr_sos_train,
    wr_sos_baseline = wr_sos_baseline,
    wr_sos_weighted = wr_sos_weighted,
    wr_sos_compare = wr_sos_compare,
    wr_sos_hybrid = wr_sos_hybrid,
    wr_sos_all_compare = wr_sos_all_compare,
    wr_sos_anchor = wr_sos_anchor,
    wr_sos_features = wr_sos_features,
    wr_sos_board = wr_sos_board,
    wr_sos_tuning = wr_sos_tuning,
    wr_sos_final_export = wr_sos_final_export
  )
}

te_sos_handoff <- get_handoff_spec("TE", "season_over_season")

te_half_ppr_points_formula <- function(receiving_yards, receptions, total_td, rush_yards = 0) {
  wr_half_ppr_points_formula(receiving_yards, receptions, total_td, rush_yards)
}

te_age_window_score <- function(age_vec) {
  age_vec <- safe_numeric(age_vec)
  out <- 100 - pmin(abs(age_vec - 26) * 8, 100)
  out[!is.finite(age_vec)] <- NA_real_
  out
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
      adot = pick_first_existing_numeric(te_raw, c("aDOT", "aDOT_ply")),
      air_yards = pick_first_existing_numeric(te_raw, c("AY", "AY_ply")),
      air_yards_share = pick_first_existing_numeric(te_raw, c("AY_Share")),
      targets_primary = pick_first_existing_numeric(te_raw, c("TGT_ply")),
      targets_fallback = pick_first_existing_numeric(te_raw, c("TGT")),
      team_total_targets_source = pick_first_existing_numeric(te_raw, c("TM_TGT", "TM_TGT_off", "TGT_team")),
      target_share_total_source = pick_first_existing_numeric(te_raw, c("TGT_PCT")),
      targets_per_route_source = pick_first_existing_numeric(te_raw, c("TPRR")),
      receptions = pick_first_existing_numeric(te_raw, c("REC", "REC_ply")),
      catch_rate_source = pick_first_existing_numeric(te_raw, c("Catch_Rate", "Catch_Rate_ply")),
      receiving_yards = pick_first_existing_numeric(te_raw, c("YDS", "YDS_ply")),
      receiving_yards_per_game_source = pick_first_existing_numeric(te_raw, c("RecYDS_G")),
      team_rec_yards_share = pick_first_existing_numeric(te_raw, c("TM_RecYDS_PCT")),
      yards_per_route_source = pick_first_existing_numeric(te_raw, c("YPRR")),
      yards_per_target_source = pick_first_existing_numeric(te_raw, c("YPT")),
      yards_per_reception_source = pick_first_existing_numeric(te_raw, c("YPR")),
      yac_total = pick_first_existing_numeric(te_raw, c("YAC")),
      yac_per_reception_source = pick_first_existing_numeric(te_raw, c("YAC_REC")),
      yaco_rec = pick_first_existing_numeric(te_raw, c("YACO_rec", "YACO_REC")),
      receiving_td = pick_first_existing_numeric(te_raw, c("TD", "TD_ply")),
      team_rec_td_share = pick_first_existing_numeric(te_raw, c("TM_Rec_TD_PCT", "TM_RecTD_PCT")),
      end_zone_targets = pick_first_existing_numeric(te_raw, c("EZTGT")),
      end_zone_tds = pick_first_existing_numeric(te_raw, c("EZTD")),
      first_read_targets = pick_first_existing_numeric(te_raw, c("X1READ")),
      first_read_target_share = pick_first_existing_numeric(te_raw, c("X1READ_Rec_PCT", "X1READ_PCT")),
      missed_tackles_forced = pick_first_existing_numeric(te_raw, c("MTF_rec", "MTF_REC")),
      receiving_first_downs = pick_first_existing_numeric(te_raw, c("X1D_rec")),
      first_downs_per_route_source = pick_first_existing_numeric(te_raw, c("X1D_RR")),
      drops = pick_first_existing_numeric(te_raw, c("DRP")),
      drop_pct = pick_first_existing_numeric(te_raw, c("DROP_PCT", "DRP_PCT")),
      catchable_targets = pick_first_existing_numeric(te_raw, c("CTGT")),
      catchable_tgt_pct = pick_first_existing_numeric(te_raw, c("Catchable_TGT_PCT", "Catchable_TGT_Rate")),
      designed_targets = pick_first_existing_numeric(te_raw, c("DESIGN")),
      design_pct = pick_first_existing_numeric(te_raw, c("DESIGN_PCT")),
      contested_targets = pick_first_existing_numeric(te_raw, c("CT")),
      contested_catches = pick_first_existing_numeric(te_raw, c("CC")),
      contested_catch_pct = pick_first_existing_numeric(te_raw, c("Contested_Catch_PCT", "Contested_Catch_Rate")),
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
      target_share_total = dplyr::coalesce(
        .data$target_share_total_source,
        100 * safe_div(.data$targets, .data$team_total_targets_source)
      ),
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
        "targets_primary", "targets_fallback", "team_total_targets_source", "target_share_total_source",
        "targets_per_route_source", "catch_rate_source", "receiving_yards_per_game_source",
        "yards_per_route_source", "yards_per_target_source", "yards_per_reception_source",
        "yac_per_reception_source", "first_downs_per_route_source"
      ))
    ) |>
    dplyr::arrange(.data$season, .data$week, .data$team, .data$player)
  
  te_weekly <- fill_player_bio_fields(te_weekly)
  
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
      dplyr::semi_join(
        duplicate_keys,
        by = c("season", "week", "player_key")
      ) |>
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
      .data$season,
      .data$week,
      .data$player_key,
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

build_te_team_week_opportunity_table <- function(te_weekly = build_te_clean_weekly_master(), write_output = FALSE, output_dir = model_paths$foundation_output_dir) {
  load_model_core_packages()
  
  out <- te_weekly |>
    dplyr::filter(.data$te_model_eligible) |>
    dplyr::group_by(.data$season, .data$week, .data$team) |>
    dplyr::summarise(
      team_te_targets = sum(.data$targets, na.rm = TRUE),
      team_te_receptions = sum(.data$receptions, na.rm = TRUE),
      team_te_routes = sum(.data$routes, na.rm = TRUE),
      team_te_receiving_yards = sum(.data$receiving_yards, na.rm = TRUE),
      team_te_receiving_td = sum(.data$receiving_td, na.rm = TRUE),
      team_te_air_yards = sum(.data$air_yards, na.rm = TRUE),
      team_te_end_zone_targets = sum(.data$end_zone_targets, na.rm = TRUE),
      team_te_first_read_targets = sum(.data$first_read_targets, na.rm = TRUE),
      team_te_first_downs = sum(.data$receiving_first_downs, na.rm = TRUE),
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
    dplyr::filter(.data$te_model_eligible) |>
    dplyr::left_join(team_week, by = c("season", "week", "team")) |>
    dplyr::mutate(
      team_te_target_share = safe_div(.data$targets, .data$team_te_targets),
      team_te_reception_share = safe_div(.data$receptions, .data$team_te_receptions),
      team_te_route_share = safe_div(.data$routes, .data$team_te_routes),
      team_te_rec_yard_share = safe_div(.data$receiving_yards, .data$team_te_receiving_yards),
      team_te_td_share = safe_div(.data$receiving_td, .data$team_te_receiving_td),
      team_te_air_yard_share = safe_div(.data$air_yards, .data$team_te_air_yards),
      team_te_ez_target_share = safe_div(.data$end_zone_targets, .data$team_te_end_zone_targets),
      team_te_first_read_share = safe_div(.data$first_read_targets, .data$team_te_first_read_targets),
      team_te_first_down_share = safe_div(.data$receiving_first_downs, .data$team_te_first_downs),
      team_te_fantasy_share = safe_div(.data$half_ppr_points, .data$team_te_half_ppr),
      starter_flag = dplyr::if_else(!is.na(.data$depth_team) & .data$depth_team <= 2, 1L, 0L),
      primary_role_flag = dplyr::if_else(!is.na(.data$depth_team) & .data$depth_team <= 1, 1L, 0L)
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

build_te_weekly_role_usage_table <- function(
    te_share = build_te_player_share_table(),
    write_output = FALSE,
    output_dir = model_paths$foundation_output_dir
) {
  load_model_core_packages()
  
  out <- te_share |>
    dplyr::transmute(
      season,
      week,
      player,
      player_key,
      team,
      opponent,
      position,
      te_model_eligible,
      depth_team,
      te_depth_role,
      starter_flag,
      primary_role_flag,
      draft_day,
      report_status,
      practice_primary_injury,
      practice_secondary_injury,
      practice_status,
      rookie_year,
      age,
      routes,
      targets,
      receptions,
      receiving_yards,
      receiving_td,
      air_yards,
      end_zone_targets,
      first_read_targets,
      receiving_first_downs,
      rush_attempts,
      rush_yards,
      rush_td,
      total_td,
      scrimmage_yards,
      half_ppr_points,
      target_share_total,
      team_te_target_share,
      team_te_route_share,
      team_te_rec_yard_share,
      team_te_air_yard_share,
      team_te_first_read_share,
      team_te_first_down_share,
      team_te_fantasy_share
    )
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "te_weekly_role_usage_2021_2025_regular.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_te_player_season_combined_table <- function(
    te_weekly = build_te_clean_weekly_master(),
    te_share = build_te_player_share_table(te_weekly = te_weekly),
    write_output = FALSE,
    output_dir = model_paths$foundation_output_dir
) {
  load_model_core_packages()
  
  out <- te_share |>
    dplyr::filter(.data$te_model_eligible) |>
    dplyr::arrange(.data$season, .data$player_key, .data$week) |>
    dplyr::group_by(.data$season, .data$player_key) |>
    dplyr::summarise(
      player = first_non_missing(rev(.data$player)),
      team = first_non_missing(rev(.data$team)),
      teams_played = paste(unique(.data$team[!is.na(.data$team) & .data$team != ""]), collapse = "/"),
      games = dplyr::n_distinct(.data$week),
      starter_weeks = sum(.data$starter_flag, na.rm = TRUE),
      primary_role_weeks = sum(.data$primary_role_flag, na.rm = TRUE),
      best_depth_team = suppressWarnings(min(.data$depth_team, na.rm = TRUE)),
      te_depth_role = first_non_missing(rev(.data$te_depth_role)),
      draft_day = first_non_missing(rev(.data$draft_day)),
      rookie_year = suppressWarnings(min(.data$rookie_year, na.rm = TRUE)),
      age = suppressWarnings(max(.data$age, na.rm = TRUE)),
      routes = sum(.data$routes, na.rm = TRUE),
      targets = sum(.data$targets, na.rm = TRUE),
      receptions = sum(.data$receptions, na.rm = TRUE),
      receiving_yards = sum(.data$receiving_yards, na.rm = TRUE),
      receiving_td = sum(.data$receiving_td, na.rm = TRUE),
      air_yards = sum(.data$air_yards, na.rm = TRUE),
      end_zone_targets = sum(.data$end_zone_targets, na.rm = TRUE),
      first_read_targets = sum(.data$first_read_targets, na.rm = TRUE),
      receiving_first_downs = sum(.data$receiving_first_downs, na.rm = TRUE),
      rush_attempts = sum(.data$rush_attempts, na.rm = TRUE),
      rush_yards = sum(.data$rush_yards, na.rm = TRUE),
      rush_td = sum(.data$rush_td, na.rm = TRUE),
      total_td = sum(.data$total_td, na.rm = TRUE),
      scrimmage_yards = sum(.data$scrimmage_yards, na.rm = TRUE),
      fantasy_points = sum(.data$half_ppr_points, na.rm = TRUE),
      fantasy_points_per_game = ifelse(
        sum(!is.na(.data$half_ppr_points)) > 0,
        mean(.data$half_ppr_points, na.rm = TRUE),
        NA_real_
      ),
      fantasy_points_sd = stats::sd(.data$half_ppr_points, na.rm = TRUE),
      weekly_floor_p10 = suppressWarnings(stats::quantile(.data$half_ppr_points, probs = 0.10, na.rm = TRUE, names = FALSE)),
      weekly_floor_p25 = suppressWarnings(stats::quantile(.data$half_ppr_points, probs = 0.25, na.rm = TRUE, names = FALSE)),
      weekly_median_p50 = suppressWarnings(stats::quantile(.data$half_ppr_points, probs = 0.50, na.rm = TRUE, names = FALSE)),
      weekly_ceiling_p75 = suppressWarnings(stats::quantile(.data$half_ppr_points, probs = 0.75, na.rm = TRUE, names = FALSE)),
      weekly_ceiling_p90 = suppressWarnings(stats::quantile(.data$half_ppr_points, probs = 0.90, na.rm = TRUE, names = FALSE)),
      weekly_spike_15_rate = mean(.data$half_ppr_points >= 15, na.rm = TRUE),
      weekly_spike_20_rate = mean(.data$half_ppr_points >= 20, na.rm = TRUE),
      weekly_bust_under8_rate = mean(.data$half_ppr_points < 8, na.rm = TRUE),
      team_total_target_share_mean = mean(.data$target_share_total, na.rm = TRUE),
      team_te_target_share_mean = mean(.data$team_te_target_share, na.rm = TRUE),
      team_te_reception_share_mean = mean(.data$team_te_reception_share, na.rm = TRUE),
      team_te_route_share_mean = mean(.data$team_te_route_share, na.rm = TRUE),
      team_te_rec_yard_share_mean = mean(.data$team_te_rec_yard_share, na.rm = TRUE),
      team_te_td_share_mean = mean(.data$team_te_td_share, na.rm = TRUE),
      team_te_air_yard_share_mean = mean(.data$team_te_air_yard_share, na.rm = TRUE),
      team_te_ez_target_share_mean = mean(.data$team_te_ez_target_share, na.rm = TRUE),
      team_te_first_read_share_mean = mean(.data$team_te_first_read_share, na.rm = TRUE),
      team_te_first_down_share_mean = mean(.data$team_te_first_down_share, na.rm = TRUE),
      team_te_fantasy_share_mean = mean(.data$team_te_fantasy_share, na.rm = TRUE),
      .groups = "drop"
    ) |>
    dplyr::mutate(
      best_depth_team = ifelse(is.infinite(.data$best_depth_team), NA, .data$best_depth_team),
      rookie_year = ifelse(is.infinite(.data$rookie_year), NA, .data$rookie_year),
      age = ifelse(is.infinite(.data$age), NA, .data$age),
      qualified_4_games_current = .data$games >= 4,
      qualified_8_games_current = .data$games >= 8,
      next_season = .data$season + 1L,
      starter_rate = safe_div(.data$starter_weeks, .data$games),
      primary_role_rate = safe_div(.data$primary_role_weeks, .data$games),
      targets_per_game = safe_div(.data$targets, .data$games),
      routes_per_game = safe_div(.data$routes, .data$games),
      receptions_per_game = safe_div(.data$receptions, .data$games),
      receiving_yards_per_game = safe_div(.data$receiving_yards, .data$games),
      receiving_td_per_game = safe_div(.data$receiving_td, .data$games),
      air_yards_per_game = safe_div(.data$air_yards, .data$games),
      end_zone_targets_per_game = safe_div(.data$end_zone_targets, .data$games),
      first_read_targets_per_game = safe_div(.data$first_read_targets, .data$games),
      first_downs_per_game = safe_div(.data$receiving_first_downs, .data$games),
      rush_yards_per_game = safe_div(.data$rush_yards, .data$games),
      total_td_per_game = safe_div(.data$total_td, .data$games),
      scrimmage_yards_per_game = safe_div(.data$scrimmage_yards, .data$games),
      targets_per_route = safe_div(.data$targets, .data$routes),
      catch_rate = 100 * safe_div(.data$receptions, .data$targets),
      yards_per_route = safe_div(.data$receiving_yards, .data$routes),
      yards_per_target = safe_div(.data$receiving_yards, .data$targets),
      yards_per_reception = safe_div(.data$receiving_yards, .data$receptions),
      air_yards_per_target = safe_div(.data$air_yards, .data$targets),
      yac_per_reception = safe_div(.data$receiving_yards - .data$air_yards, .data$receptions),
      first_downs_per_target = safe_div(.data$receiving_first_downs, .data$targets),
      first_reads_per_target = safe_div(.data$first_read_targets, .data$targets),
      td_per_target = safe_div(.data$receiving_td, .data$targets),
      end_zone_target_rate = safe_div(.data$end_zone_targets, .data$targets)
    ) |>
    dplyr::arrange(.data$season, dplyr::desc(.data$fantasy_points_per_game), .data$player)
  
  duplicate_player_seasons <- out |>
    dplyr::count(.data$season, .data$player_key, name = "dup_n") |>
    dplyr::filter(.data$dup_n > 1)
  
  if (nrow(duplicate_player_seasons) > 0) {
    stop(
      paste0(
        "TE player-season table has ", nrow(duplicate_player_seasons),
        " duplicate player-season keys after aggregation."
      ),
      call. = FALSE
    )
  }
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "te_player_season_combined_table_2021_2025_regular.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_te_sos_inputs <- function(write_output = FALSE) {
  load_model_core_packages()
  
  te_clean_weekly_master <- build_te_clean_weekly_master(write_output = write_output)
  te_team_week_opportunity <- build_te_team_week_opportunity_table(
    te_weekly = te_clean_weekly_master,
    write_output = write_output
  )
  te_player_share_table <- build_te_player_share_table(
    te_weekly = te_clean_weekly_master,
    team_week = te_team_week_opportunity,
    write_output = write_output
  )
  te_weekly_role_usage <- build_te_weekly_role_usage_table(
    te_share = te_player_share_table,
    write_output = write_output
  )
  te_player_season_combined_table <- build_te_player_season_combined_table(
    te_weekly = te_clean_weekly_master,
    te_share = te_player_share_table,
    write_output = write_output
  )
  
  out <- list(
    position = "TE",
    mode = "season_over_season",
    handoff = te_sos_handoff,
    handoff_text = read_text_from_handoff(te_sos_handoff),
    te_clean_weekly_master = te_clean_weekly_master,
    te_team_week_opportunity = te_team_week_opportunity,
    te_player_share_table = te_player_share_table,
    te_weekly_role_usage = te_weekly_role_usage,
    te_player_season_combined_table = te_player_season_combined_table,
    player_season_index = build_sos_player_season_index("TE"),
    next_steps = c(
      "Build TE next-season targets from the player-season combined table.",
      "Translate TE receiving-role, opportunity, stability, and durability features into baseline, weighted, and anchor stages.",
      "Tune the TE production board weights before moving into TE WOW."
    )
  )
  
  if (write_output) {
    out$output_paths <- c(
      te_clean_weekly_master = file.path(model_paths$foundation_output_dir, "te_clean_weekly_master_2021_2025_regular.csv"),
      te_team_week_opportunity = file.path(model_paths$foundation_output_dir, "te_team_week_opportunity_2021_2025_regular.csv"),
      te_player_share_table = file.path(model_paths$foundation_output_dir, "te_player_share_table_2021_2025_regular.csv"),
      te_weekly_role_usage = file.path(model_paths$foundation_output_dir, "te_weekly_role_usage_2021_2025_regular.csv"),
      te_player_season_combined_table = file.path(model_paths$foundation_output_dir, "te_player_season_combined_table_2021_2025_regular.csv"),
      te_player_season_index = write_sos_player_season_index("TE")
    )
  }
  
  out
}

make_te_sos_output_manifest <- function(te_sos_result) {
  output_paths <- unname(te_sos_result$output_paths %||% character())
  output_labels <- names(te_sos_result$output_paths %||% character())
  
  data.frame(
    output_name = output_labels,
    output_path = output_paths,
    exists = file.exists(output_paths),
    stringsAsFactors = FALSE
  )
}

run_te_sos_pipeline <- function(write_output = TRUE) {
  load_model_core_packages()
  
  dir.create(model_paths$foundation_output_dir, recursive = TRUE, showWarnings = FALSE)
  dir.create(model_paths$sos_output_dir, recursive = TRUE, showWarnings = FALSE)
  
  te_sos_result <- build_te_sos_inputs(write_output = write_output)
  output_manifest <- make_te_sos_output_manifest(te_sos_result)
  
  list(
    result = te_sos_result,
    output_manifest = output_manifest
  )
}

build_te_sos_target_table <- function(
    te_player_season_combined_table = NULL,
    write_output = FALSE,
    output_dir = model_paths$sos_output_dir
) {
  load_model_core_packages()
  
  if (is.null(te_player_season_combined_table)) {
    te_player_season_combined_table <- build_te_player_season_combined_table(write_output = FALSE)
  }
  
  out <- te_player_season_combined_table |>
    dplyr::group_by(.data$season) |>
    dplyr::arrange(
      dplyr::desc(.data$fantasy_points),
      dplyr::desc(.data$fantasy_points_per_game),
      .data$player,
      .by_group = TRUE
    ) |>
    dplyr::mutate(
      target_next_points_rank_all = dplyr::row_number(),
      next_top6_points_all = as.integer(.data$target_next_points_rank_all <= 6),
      next_top12_points_all = as.integer(.data$target_next_points_rank_all <= 12),
      next_top18_points_all = as.integer(.data$target_next_points_rank_all <= 18),
      next_top24_points_all = as.integer(.data$target_next_points_rank_all <= 24)
    ) |>
    dplyr::ungroup() |>
    dplyr::transmute(
      player_key,
      target_next_season = .data$season,
      target_next_team = .data$team,
      target_next_games = .data$games,
      target_next_points_rank_all,
      target_next_total_points = .data$fantasy_points,
      target_next_ppg = .data$fantasy_points_per_game,
      next_top6_points_all,
      next_top12_points_all,
      next_top18_points_all,
      next_top24_points_all,
      qualified_4_games_next = as.integer(.data$target_next_games >= 4),
      qualified_8_games_next = as.integer(.data$target_next_games >= 8)
    )
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "te_sos_target_table_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_te_sos_training_frame <- function(
    write_output = FALSE,
    output_dir = model_paths$sos_output_dir,
    max_source_season = 2024L
) {
  load_model_core_packages()
  
  te_player_season_combined_table <- build_te_player_season_combined_table(write_output = FALSE)
  te_sos_target_table <- build_te_sos_target_table(te_player_season_combined_table, write_output = FALSE)
  
  out <- te_player_season_combined_table |>
    dplyr::mutate(
      target_next_season = .data$next_season,
      qualified_4_games_current = as.integer(.data$games >= 4),
      qualified_8_games_current = as.integer(.data$games >= 8)
    ) |>
    dplyr::left_join(
      te_sos_target_table,
      by = c("player_key", "target_next_season"),
      relationship = "many-to-one"
    ) |>
    dplyr::mutate(
      made_next_season = as.integer(!is.na(.data$target_next_ppg)),
      team_changed_next_season = dplyr::if_else(
        !is.na(.data$target_next_team) & .data$team != .data$target_next_team,
        1L,
        0L,
        missing = 0L
      )
    ) |>
    dplyr::filter(.data$season >= 2021, .data$season <= .env$max_source_season) |>
    dplyr::arrange(.data$season, dplyr::desc(.data$fantasy_points_per_game), .data$player)
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "te_sos_training_frame_2021_2024_to_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

make_te_sos_training_manifest <- function() {
  data.frame(
    output_name = c("te_sos_target_table", "te_sos_training_frame"),
    output_path = c(
      file.path(model_paths$sos_output_dir, "te_sos_target_table_2022_2025.csv"),
      file.path(model_paths$sos_output_dir, "te_sos_training_frame_2021_2024_to_2022_2025.csv")
    ),
    exists = c(
      file.exists(file.path(model_paths$sos_output_dir, "te_sos_target_table_2022_2025.csv")),
      file.exists(file.path(model_paths$sos_output_dir, "te_sos_training_frame_2021_2024_to_2022_2025.csv"))
    ),
    stringsAsFactors = FALSE
  )
}

run_te_sos_training_step <- function(write_output = TRUE) {
  load_model_core_packages()
  
  dir.create(model_paths$sos_output_dir, recursive = TRUE, showWarnings = FALSE)
  
  te_sos_target_table <- build_te_sos_target_table(write_output = write_output)
  te_sos_training_frame <- build_te_sos_training_frame(write_output = write_output)
  
  list(
    te_sos_target_table = te_sos_target_table,
    te_sos_training_frame = te_sos_training_frame,
    output_manifest = make_te_sos_training_manifest()
  )
}

build_te_sos_baseline_feature_set <- function() {
  load_model_core_packages()
  
  model_df <- build_te_sos_training_frame(write_output = FALSE)
  non_numeric_cols <- c("player_key", "player", "team", "target_next_team", "draft_day", "te_depth_role")
  numeric_cols <- setdiff(names(model_df), non_numeric_cols)
  
  model_df |>
    dplyr::mutate(
      dplyr::across(dplyr::any_of(numeric_cols), safe_numeric),
      target_next_ppg = safe_numeric(.data$target_next_ppg),
      target_next_total_points = safe_numeric(.data$target_next_total_points),
      qualified_4_games_next = safe_numeric(.data$qualified_4_games_next),
      qualified_8_games_next = safe_numeric(.data$qualified_8_games_next)
    )
}

run_te_sos_baseline_model_step <- function(
    write_output = TRUE,
    output_dir = model_paths$sos_output_dir
) {
  load_model_core_packages()
  
  model_df <- build_te_sos_baseline_feature_set()
  
  predictor_cols <- c(
    "games",
    "starter_weeks",
    "primary_role_weeks",
    "best_depth_team",
    "age",
    "rookie_year",
    "routes",
    "targets",
    "receptions",
    "receiving_yards",
    "receiving_td",
    "air_yards",
    "end_zone_targets",
    "first_read_targets",
    "receiving_first_downs",
    "rush_attempts",
    "rush_yards",
    "rush_td",
    "total_td",
    "scrimmage_yards",
    "fantasy_points",
    "fantasy_points_per_game",
    "fantasy_points_sd",
    "weekly_floor_p10",
    "weekly_floor_p25",
    "weekly_median_p50",
    "weekly_ceiling_p75",
    "weekly_ceiling_p90",
    "weekly_spike_15_rate",
    "weekly_spike_20_rate",
    "weekly_bust_under8_rate",
    "team_total_target_share_mean",
    "team_te_target_share_mean",
    "team_te_reception_share_mean",
    "team_te_route_share_mean",
    "team_te_rec_yard_share_mean",
    "team_te_td_share_mean",
    "team_te_air_yard_share_mean",
    "team_te_ez_target_share_mean",
    "team_te_first_read_share_mean",
    "team_te_first_down_share_mean",
    "team_te_fantasy_share_mean",
    "starter_rate",
    "primary_role_rate",
    "targets_per_game",
    "routes_per_game",
    "receptions_per_game",
    "receiving_yards_per_game",
    "receiving_td_per_game",
    "air_yards_per_game",
    "end_zone_targets_per_game",
    "first_read_targets_per_game",
    "first_downs_per_game",
    "rush_yards_per_game",
    "total_td_per_game",
    "scrimmage_yards_per_game",
    "targets_per_route",
    "catch_rate",
    "yards_per_route",
    "yards_per_target",
    "yards_per_reception",
    "air_yards_per_target",
    "yac_per_reception",
    "first_downs_per_target",
    "first_reads_per_target",
    "td_per_target",
    "end_zone_target_rate",
    "qualified_4_games_current",
    "qualified_8_games_current",
    "team_changed_next_season"
  )
  
  predictor_cols <- intersect(predictor_cols, names(model_df))
  
  predict_seasons <- sort(unique(model_df$target_next_season))
  predict_seasons <- predict_seasons[predict_seasons >= 2022 & predict_seasons <= 2025]
  
  prediction_list <- list()
  metric_list <- list()
  pred_idx <- 1L
  metric_idx <- 1L
  
  for (predict_season in predict_seasons) {
    train_df <- model_df |>
      dplyr::filter(
        target_next_season < predict_season,
        !is.na(.data$target_next_ppg),
        !is.na(.data$target_next_total_points)
      )
    
    test_df <- model_df |>
      dplyr::filter(
        target_next_season == predict_season,
        !is.na(.data$target_next_ppg),
        !is.na(.data$target_next_total_points)
      )
    
    if (nrow(train_df) == 0 || nrow(test_df) == 0) {
      next
    }
    
    imputed <- impute_numeric_medians(train_df, test_df, predictor_cols)
    train_df <- imputed$train
    test_df <- imputed$test
    
    ppg_formula <- stats::reformulate(predictor_cols, response = "target_next_ppg")
    total_formula <- stats::reformulate(predictor_cols, response = "target_next_total_points")
    
    ppg_model <- stats::lm(ppg_formula, data = train_df)
    total_model <- stats::lm(total_formula, data = train_df)
    
    pred_next_ppg <- as.numeric(stats::predict(ppg_model, newdata = test_df))
    pred_next_total_points <- as.numeric(stats::predict(total_model, newdata = test_df))
    
    fold_predictions <- test_df |>
      dplyr::transmute(
        train_through_season = predict_season - 1L,
        predict_season = .data$target_next_season,
        source_season = .data$season,
        player_key,
        player,
        current_team = .data$team,
        next_team = .data$target_next_team,
        target_next_games = .data$target_next_games,
        qualified_4_games_current,
        qualified_8_games_current,
        qualified_4_games_next,
        qualified_8_games_next,
        target_next_ppg,
        pred_next_ppg,
        target_next_total_points,
        pred_next_total_points
      )
    
    prediction_list[[pred_idx]] <- fold_predictions
    pred_idx <- pred_idx + 1L
    
    overall_ppg <- calc_regression_metrics(fold_predictions$target_next_ppg, fold_predictions$pred_next_ppg)
    overall_ppg$predict_season <- predict_season
    overall_ppg$target <- "target_next_ppg"
    overall_ppg$sample <- "overall"
    metric_list[[metric_idx]] <- overall_ppg
    metric_idx <- metric_idx + 1L
    
    overall_total <- calc_regression_metrics(fold_predictions$target_next_total_points, fold_predictions$pred_next_total_points)
    overall_total$predict_season <- predict_season
    overall_total$target <- "target_next_total_points"
    overall_total$sample <- "overall"
    metric_list[[metric_idx]] <- overall_total
    metric_idx <- metric_idx + 1L
    
    keep_4_4 <- fold_predictions$qualified_4_games_current == 1 & fold_predictions$qualified_4_games_next == 1
    
    qual_ppg <- calc_regression_metrics(
      fold_predictions$target_next_ppg[keep_4_4],
      fold_predictions$pred_next_ppg[keep_4_4]
    )
    qual_ppg$predict_season <- predict_season
    qual_ppg$target <- "target_next_ppg"
    qual_ppg$sample <- "qualified_4_4"
    metric_list[[metric_idx]] <- qual_ppg
    metric_idx <- metric_idx + 1L
    
    qual_total <- calc_regression_metrics(
      fold_predictions$target_next_total_points[keep_4_4],
      fold_predictions$pred_next_total_points[keep_4_4]
    )
    qual_total$predict_season <- predict_season
    qual_total$target <- "target_next_total_points"
    qual_total$sample <- "qualified_4_4"
    metric_list[[metric_idx]] <- qual_total
    metric_idx <- metric_idx + 1L
  }
  
  predictions <- dplyr::bind_rows(prediction_list)
  metrics <- dplyr::bind_rows(metric_list) |>
    dplyr::select(predict_season, target, sample, n, mae, rmse, spearman) |>
    dplyr::arrange(predict_season, target, sample)
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    
    utils::write.csv(
      predictions,
      file.path(output_dir, "te_sos_baseline_predictions_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    
    utils::write.csv(
      metrics,
      file.path(output_dir, "te_sos_baseline_metrics_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    predictions = predictions,
    metrics = metrics
  )
}

build_te_sos_weighted_two_year_frame <- function() {
  load_model_core_packages()
  
  te_season <- build_te_player_season_combined_table(write_output = FALSE) |>
    dplyr::arrange(.data$season, dplyr::desc(.data$fantasy_points_per_game), .data$player)
  
  te_target_frame <- te_season |>
    dplyr::transmute(
      player_key,
      target_next_season = .data$season,
      target_next_team = .data$team,
      target_next_games = .data$games,
      target_next_ppg = .data$fantasy_points_per_game,
      target_next_total_points = .data$fantasy_points,
      qualified_4_games_next = as.integer(.data$games >= 4),
      qualified_8_games_next = as.integer(.data$games >= 8)
    )
  
  te_prior_frame <- te_season |>
    dplyr::transmute(
      player_key,
      season = .data$season + 1L,
      prior_ppg = .data$fantasy_points_per_game,
      prior_total_points = .data$fantasy_points
    )
  
  te_season |>
    dplyr::mutate(
      target_next_season = .data$season + 1L
    ) |>
    dplyr::left_join(
      te_target_frame,
      by = c("player_key", "target_next_season"),
      relationship = "many-to-one"
    ) |>
    dplyr::left_join(
      te_prior_frame,
      by = c("player_key", "season"),
      relationship = "many-to-one"
    ) |>
    dplyr::mutate(
      weighted_two_year_ppg = dplyr::case_when(
        !is.na(.data$fantasy_points_per_game) & !is.na(.data$prior_ppg) ~ 0.65 * .data$fantasy_points_per_game + 0.35 * .data$prior_ppg,
        !is.na(.data$fantasy_points_per_game) ~ .data$fantasy_points_per_game,
        TRUE ~ .data$prior_ppg
      ),
      weighted_two_year_total_points = dplyr::case_when(
        !is.na(.data$fantasy_points) & !is.na(.data$prior_total_points) ~ 0.65 * .data$fantasy_points + 0.35 * .data$prior_total_points,
        !is.na(.data$fantasy_points) ~ .data$fantasy_points,
        TRUE ~ .data$prior_total_points
      )
    ) |>
    dplyr::filter(
      .data$target_next_season >= 2022,
      .data$target_next_season <= 2025,
      !is.na(.data$target_next_ppg),
      !is.na(.data$target_next_total_points)
    ) |>
    dplyr::arrange(.data$target_next_season, dplyr::desc(.data$weighted_two_year_ppg), .data$player)
}

run_te_sos_weighted_two_year_baseline <- function(write_output = TRUE, output_dir = model_paths$sos_output_dir) {
  load_model_core_packages()
  
  predictions <- build_te_sos_weighted_two_year_frame() |>
    dplyr::transmute(
      predict_season = .data$target_next_season,
      source_season = .data$season,
      player_key,
      player,
      current_team = .data$team,
      next_team = .data$target_next_team,
      qualified_4_games_current,
      qualified_8_games_current,
      qualified_4_games_next,
      qualified_8_games_next,
      target_next_ppg,
      pred_next_ppg = .data$weighted_two_year_ppg,
      target_next_total_points,
      pred_next_total_points = .data$weighted_two_year_total_points
    )
  
  metric_list <- list()
  idx <- 1L
  
  for (predict_season in sort(unique(predictions$predict_season))) {
    fold_df <- predictions |>
      dplyr::filter(.data$predict_season == .env$predict_season)
    
    overall_ppg <- calc_regression_metrics(fold_df$target_next_ppg, fold_df$pred_next_ppg)
    overall_ppg$predict_season <- predict_season
    overall_ppg$target <- "target_next_ppg"
    overall_ppg$sample <- "overall"
    metric_list[[idx]] <- overall_ppg
    idx <- idx + 1L
    
    qual_df <- fold_df |>
      dplyr::filter(.data$qualified_4_games_current == 1, .data$qualified_4_games_next == 1)
    
    qual_ppg <- calc_regression_metrics(qual_df$target_next_ppg, qual_df$pred_next_ppg)
    qual_ppg$predict_season <- predict_season
    qual_ppg$target <- "target_next_ppg"
    qual_ppg$sample <- "qualified_4_4"
    metric_list[[idx]] <- qual_ppg
    idx <- idx + 1L
    
    overall_total <- calc_regression_metrics(fold_df$target_next_total_points, fold_df$pred_next_total_points)
    overall_total$predict_season <- predict_season
    overall_total$target <- "target_next_total_points"
    overall_total$sample <- "overall"
    metric_list[[idx]] <- overall_total
    idx <- idx + 1L
    
    qual_total <- calc_regression_metrics(qual_df$target_next_total_points, qual_df$pred_next_total_points)
    qual_total$predict_season <- predict_season
    qual_total$target <- "target_next_total_points"
    qual_total$sample <- "qualified_4_4"
    metric_list[[idx]] <- qual_total
    idx <- idx + 1L
  }
  
  metrics <- dplyr::bind_rows(metric_list) |>
    dplyr::select(predict_season, target, sample, n, mae, rmse, spearman) |>
    dplyr::arrange(predict_season, target, sample)
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    
    utils::write.csv(
      predictions,
      file.path(output_dir, "te_sos_weighted_two_year_predictions_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    
    utils::write.csv(
      metrics,
      file.path(output_dir, "te_sos_weighted_two_year_metrics_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    predictions = predictions,
    metrics = metrics
  )
}

run_te_sos_hybrid_baseline <- function(
    te_sos_baseline,
    te_sos_weighted,
    write_output = TRUE,
    output_dir = model_paths$sos_output_dir
) {
  load_model_core_packages()
  
  hybrid_predictions <- te_sos_weighted$predictions |>
    dplyr::left_join(
      te_sos_baseline$predictions |>
        dplyr::select(
          predict_season,
          player_key,
          pred_next_ppg_linear = pred_next_ppg,
          pred_next_total_points_linear = pred_next_total_points
        ),
      by = c("predict_season", "player_key")
    ) |>
    dplyr::mutate(
      pred_next_ppg = 0.70 * .data$pred_next_ppg + 0.30 * .data$pred_next_ppg_linear,
      pred_next_total_points = 0.70 * .data$pred_next_total_points + 0.30 * .data$pred_next_total_points_linear
    )
  
  metric_list <- list()
  idx <- 1L
  
  for (predict_season in sort(unique(hybrid_predictions$predict_season))) {
    fold_df <- hybrid_predictions |>
      dplyr::filter(.data$predict_season == .env$predict_season)
    
    overall_ppg <- calc_regression_metrics(fold_df$target_next_ppg, fold_df$pred_next_ppg)
    overall_ppg$predict_season <- predict_season
    overall_ppg$target <- "target_next_ppg"
    overall_ppg$sample <- "overall"
    metric_list[[idx]] <- overall_ppg
    idx <- idx + 1L
    
    qual_df <- fold_df |>
      dplyr::filter(.data$qualified_4_games_current == 1, .data$qualified_4_games_next == 1)
    
    qual_ppg <- calc_regression_metrics(qual_df$target_next_ppg, qual_df$pred_next_ppg)
    qual_ppg$predict_season <- predict_season
    qual_ppg$target <- "target_next_ppg"
    qual_ppg$sample <- "qualified_4_4"
    metric_list[[idx]] <- qual_ppg
    idx <- idx + 1L
    
    overall_total <- calc_regression_metrics(fold_df$target_next_total_points, fold_df$pred_next_total_points)
    overall_total$predict_season <- predict_season
    overall_total$target <- "target_next_total_points"
    overall_total$sample <- "overall"
    metric_list[[idx]] <- overall_total
    idx <- idx + 1L
    
    qual_total <- calc_regression_metrics(qual_df$target_next_total_points, qual_df$pred_next_total_points)
    qual_total$predict_season <- predict_season
    qual_total$target <- "target_next_total_points"
    qual_total$sample <- "qualified_4_4"
    metric_list[[idx]] <- qual_total
    idx <- idx + 1L
  }
  
  hybrid_metrics <- dplyr::bind_rows(metric_list) |>
    dplyr::select(predict_season, target, sample, n, mae, rmse, spearman) |>
    dplyr::arrange(predict_season, target, sample)
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    
    utils::write.csv(
      hybrid_predictions,
      file.path(output_dir, "te_sos_hybrid_baseline_predictions_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    
    utils::write.csv(
      hybrid_metrics,
      file.path(output_dir, "te_sos_hybrid_baseline_metrics_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    predictions = hybrid_predictions,
    metrics = hybrid_metrics
  )
}

compare_te_sos_models <- function(te_sos_baseline, te_sos_weighted) {
  dplyr::bind_rows(
    te_sos_baseline$metrics |>
      dplyr::mutate(model = "linear_baseline"),
    te_sos_weighted$metrics |>
      dplyr::mutate(model = "weighted_two_year")
  ) |>
    dplyr::select(model, predict_season, target, sample, n, mae, rmse, spearman) |>
    dplyr::arrange(target, sample, predict_season, model)
}

compare_te_sos_all_models <- function(te_sos_baseline, te_sos_weighted, te_sos_hybrid) {
  dplyr::bind_rows(
    te_sos_baseline$metrics |>
      dplyr::mutate(model = "linear_baseline"),
    te_sos_weighted$metrics |>
      dplyr::mutate(model = "weighted_two_year"),
    te_sos_hybrid$metrics |>
      dplyr::mutate(model = "hybrid_70_30")
  ) |>
    dplyr::select(model, predict_season, target, sample, n, mae, rmse, spearman) |>
    dplyr::arrange(target, sample, predict_season, model)
}

build_te_sos_anchor_predictions <- function(
    te_sos_weighted,
    te_sos_hybrid,
    write_output = TRUE,
    output_dir = model_paths$sos_output_dir
) {
  load_model_core_packages()
  
  weighted_df <- te_sos_weighted$predictions |>
    dplyr::rename(
      weighted_pred_next_ppg = pred_next_ppg,
      weighted_pred_next_total_points = pred_next_total_points
    )
  
  hybrid_df <- te_sos_hybrid$predictions |>
    dplyr::rename(
      hybrid_pred_next_ppg = pred_next_ppg,
      hybrid_pred_next_total_points = pred_next_total_points
    )
  
  out <- dplyr::full_join(
    weighted_df,
    hybrid_df,
    by = c(
      "predict_season",
      "source_season",
      "player_key",
      "player",
      "current_team",
      "next_team",
      "qualified_4_games_current",
      "qualified_8_games_current",
      "qualified_4_games_next",
      "qualified_8_games_next",
      "target_next_ppg",
      "target_next_total_points"
    )
  ) |>
    dplyr::mutate(
      te_sos_anchor_ppg = dplyr::coalesce(.data$weighted_pred_next_ppg, .data$hybrid_pred_next_ppg),
      te_sos_anchor_total_points = dplyr::coalesce(.data$weighted_pred_next_total_points, .data$hybrid_pred_next_total_points),
      te_sos_anchor_model_ppg = dplyr::if_else(!is.na(.data$weighted_pred_next_ppg), "weighted_two_year", "hybrid_70_30"),
      te_sos_anchor_model_total_points = dplyr::if_else(!is.na(.data$weighted_pred_next_total_points), "weighted_two_year", "hybrid_70_30")
    ) |>
    dplyr::arrange(.data$predict_season, dplyr::desc(.data$te_sos_anchor_ppg), .data$player)
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    
    utils::write.csv(
      out,
      file.path(output_dir, "te_sos_anchor_predictions_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_te_sos_anchor_metrics <- function(te_sos_anchor_predictions) {
  load_model_core_packages()
  
  metric_list <- list()
  idx <- 1L
  
  for (predict_season in sort(unique(te_sos_anchor_predictions$predict_season))) {
    fold_df <- te_sos_anchor_predictions |>
      dplyr::filter(.data$predict_season == .env$predict_season)
    
    overall_ppg <- calc_regression_metrics(fold_df$target_next_ppg, fold_df$te_sos_anchor_ppg)
    overall_ppg$predict_season <- predict_season
    overall_ppg$target <- "target_next_ppg"
    overall_ppg$sample <- "overall"
    metric_list[[idx]] <- overall_ppg
    idx <- idx + 1L
    
    qual_df <- fold_df |>
      dplyr::filter(.data$qualified_4_games_current == 1, .data$qualified_4_games_next == 1)
    
    qual_ppg <- calc_regression_metrics(qual_df$target_next_ppg, qual_df$te_sos_anchor_ppg)
    qual_ppg$predict_season <- predict_season
    qual_ppg$target <- "target_next_ppg"
    qual_ppg$sample <- "qualified_4_4"
    metric_list[[idx]] <- qual_ppg
    idx <- idx + 1L
    
    overall_total <- calc_regression_metrics(fold_df$target_next_total_points, fold_df$te_sos_anchor_total_points)
    overall_total$predict_season <- predict_season
    overall_total$target <- "target_next_total_points"
    overall_total$sample <- "overall"
    metric_list[[idx]] <- overall_total
    idx <- idx + 1L
    
    qual_total <- calc_regression_metrics(qual_df$target_next_total_points, qual_df$te_sos_anchor_total_points)
    qual_total$predict_season <- predict_season
    qual_total$target <- "target_next_total_points"
    qual_total$sample <- "qualified_4_4"
    metric_list[[idx]] <- qual_total
    idx <- idx + 1L
  }
  
  dplyr::bind_rows(metric_list) |>
    dplyr::select(predict_season, target, sample, n, mae, rmse, spearman) |>
    dplyr::arrange(predict_season, target, sample)
}

run_te_sos_anchor_step <- function(te_sos_weighted, te_sos_hybrid, write_output = TRUE) {
  load_model_core_packages()
  
  te_sos_anchor_predictions <- build_te_sos_anchor_predictions(
    te_sos_weighted = te_sos_weighted,
    te_sos_hybrid = te_sos_hybrid,
    write_output = write_output
  )
  
  te_sos_anchor_metrics <- build_te_sos_anchor_metrics(te_sos_anchor_predictions)
  
  if (write_output) {
    utils::write.csv(
      te_sos_anchor_metrics,
      file.path(model_paths$sos_output_dir, "te_sos_anchor_metrics_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    predictions = te_sos_anchor_predictions,
    metrics = te_sos_anchor_metrics
  )
}

build_te_sos_feature_overlay_table <- function(te_sos_anchor, max_source_season = 2024L) {
  load_model_core_packages()
  
  te_anchor_predictions <- if (is.list(te_sos_anchor) && "predictions" %in% names(te_sos_anchor)) {
    te_sos_anchor$predictions
  } else {
    te_sos_anchor
  }
  
  te_train <- build_te_sos_training_frame(
    write_output = FALSE,
    max_source_season = max_source_season
  )
  
  te_train |>
    dplyr::left_join(
      te_anchor_predictions |>
        dplyr::select(
          predict_season,
          source_season,
          player_key,
          te_sos_anchor_ppg,
          te_sos_anchor_total_points,
          te_sos_anchor_model_ppg,
          te_sos_anchor_model_total_points
        ),
      by = c(
        "target_next_season" = "predict_season",
        "season" = "source_season",
        "player_key" = "player_key"
      ),
      relationship = "many-to-one"
    ) |>
    dplyr::mutate(
      starter_rate = dplyr::coalesce(.data$starter_rate, safe_div(.data$starter_weeks, .data$games)),
      primary_role_rate = dplyr::coalesce(.data$primary_role_rate, safe_div(.data$primary_role_weeks, .data$games)),
      total_td_per_game = dplyr::coalesce(.data$total_td_per_game, safe_div(.data$total_td, .data$games)),
      production_component_0to100 = qb_row_mean(
        qb_rank_to_0_100(.data$fantasy_points_per_game),
        qb_rank_to_0_100(.data$fantasy_points),
        qb_rank_to_0_100(.data$receiving_yards_per_game),
        qb_rank_to_0_100(.data$first_downs_per_game),
        qb_rank_to_0_100(.data$total_td_per_game)
      ),
      workload_opportunity_component_0to100 = qb_row_mean(
        qb_rank_to_0_100(.data$targets_per_game),
        qb_rank_to_0_100(.data$routes_per_game),
        qb_rank_to_0_100(.data$team_total_target_share_mean),
        qb_rank_to_0_100(.data$team_te_target_share_mean),
        qb_rank_to_0_100(.data$team_te_route_share_mean)
      ),
      receiving_role_component_0to100 = qb_row_mean(
        qb_rank_to_0_100(.data$receptions_per_game),
        qb_rank_to_0_100(.data$targets_per_route),
        qb_rank_to_0_100(.data$team_te_reception_share_mean),
        qb_rank_to_0_100(.data$team_te_first_read_share_mean),
        qb_rank_to_0_100(.data$end_zone_targets_per_game)
      ),
      weekly_stability_component_0to100 = qb_row_mean(
        qb_rank_to_0_100(.data$weekly_floor_p25),
        qb_rank_to_0_100(.data$weekly_median_p50),
        qb_rank_to_0_100(.data$weekly_ceiling_p75),
        qb_rank_to_0_100(.data$weekly_ceiling_p90),
        qb_rank_to_0_100(.data$fantasy_points_sd, higher_is_better = FALSE),
        qb_rank_to_0_100(.data$weekly_bust_under8_rate, higher_is_better = FALSE)
      ),
      efficiency_sustainability_component_0to100 = qb_row_mean(
        qb_rank_to_0_100(.data$catch_rate),
        qb_rank_to_0_100(.data$yards_per_route),
        qb_rank_to_0_100(.data$yards_per_target),
        qb_rank_to_0_100(.data$yac_per_reception),
        qb_rank_to_0_100(.data$td_per_target)
      ),
      durability_role_confidence_component_0to100 = qb_row_mean(
        te_age_window_score(.data$age),
        qb_rank_to_0_100(.data$games),
        qb_rank_to_0_100(.data$starter_weeks),
        qb_rank_to_0_100(.data$primary_role_weeks),
        qb_rank_to_0_100(.data$starter_rate),
        qb_rank_to_0_100(.data$primary_role_rate)
      ),
      te_production_anchor_historical_scaled = qb_row_mean(
        qb_rank_to_0_100(.data$te_sos_anchor_ppg),
        qb_rank_to_0_100(.data$te_sos_anchor_total_points),
        .data$production_component_0to100
      ),
      te_preseason_omfg_score = (
        0.22 * .data$te_production_anchor_historical_scaled +
          0.25 * .data$workload_opportunity_component_0to100 +
          0.18 * .data$receiving_role_component_0to100 +
          0.15 * .data$weekly_stability_component_0to100 +
          0.10 * .data$efficiency_sustainability_component_0to100 +
          0.10 * .data$durability_role_confidence_component_0to100
      ),
      te_anchor_board_score = qb_row_mean(
        qb_rank_to_0_100(.data$te_sos_anchor_ppg),
        qb_rank_to_0_100(.data$te_sos_anchor_total_points),
        .data$te_preseason_omfg_score
      )
    ) |>
    dplyr::arrange(.data$target_next_season, dplyr::desc(.data$te_anchor_board_score), .data$player)
}

build_te_sos_feature_overlay_metrics <- function(te_sos_feature_overlay) {
  load_model_core_packages()
  
  feature_cols <- c(
    "production_component_0to100",
    "workload_opportunity_component_0to100",
    "receiving_role_component_0to100",
    "weekly_stability_component_0to100",
    "efficiency_sustainability_component_0to100",
    "durability_role_confidence_component_0to100",
    "te_production_anchor_historical_scaled",
    "te_preseason_omfg_score",
    "te_anchor_board_score",
    "te_sos_anchor_ppg",
    "te_sos_anchor_total_points"
  )
  
  metric_rows <- list()
  idx <- 1L
  
  for (feature_col in feature_cols) {
    keep_ppg <- is.finite(te_sos_feature_overlay[[feature_col]]) & is.finite(te_sos_feature_overlay$target_next_ppg)
    
    metric_rows[[idx]] <- data.frame(
      feature = feature_col,
      target = "target_next_ppg",
      n = sum(keep_ppg),
      spearman = if (sum(keep_ppg) > 1) {
        suppressWarnings(stats::cor(
          te_sos_feature_overlay[[feature_col]][keep_ppg],
          te_sos_feature_overlay$target_next_ppg[keep_ppg],
          method = "spearman"
        ))
      } else {
        NA_real_
      },
      stringsAsFactors = FALSE
    )
    idx <- idx + 1L
    
    keep_total <- is.finite(te_sos_feature_overlay[[feature_col]]) & is.finite(te_sos_feature_overlay$target_next_total_points)
    
    metric_rows[[idx]] <- data.frame(
      feature = feature_col,
      target = "target_next_total_points",
      n = sum(keep_total),
      spearman = if (sum(keep_total) > 1) {
        suppressWarnings(stats::cor(
          te_sos_feature_overlay[[feature_col]][keep_total],
          te_sos_feature_overlay$target_next_total_points[keep_total],
          method = "spearman"
        ))
      } else {
        NA_real_
      },
      stringsAsFactors = FALSE
    )
    idx <- idx + 1L
  }
  
  dplyr::bind_rows(metric_rows) |>
    dplyr::arrange(target, dplyr::desc(spearman), feature)
}

run_te_sos_feature_overlay_step <- function(
    te_sos_anchor,
    write_output = TRUE,
    max_source_season = 2024L
) {
  load_model_core_packages()
  
  te_sos_feature_overlay <- build_te_sos_feature_overlay_table(
    te_sos_anchor,
    max_source_season = max_source_season
  )
  te_sos_feature_metrics <- build_te_sos_feature_overlay_metrics(te_sos_feature_overlay)
  
  if (write_output) {
    dir.create(model_paths$sos_output_dir, recursive = TRUE, showWarnings = FALSE)
    
    utils::write.csv(
      te_sos_feature_overlay,
      file.path(model_paths$sos_output_dir, "te_sos_feature_overlay_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    
    utils::write.csv(
      te_sos_feature_metrics,
      file.path(model_paths$sos_output_dir, "te_sos_feature_overlay_metrics_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    feature_table = te_sos_feature_overlay,
    metrics = te_sos_feature_metrics
  )
}

build_te_sos_board_metrics <- function(te_sos_production_board) {
  load_model_core_packages()
  
  metric_rows <- list()
  idx <- 1L
  
  for (predict_season in sort(unique(te_sos_production_board$target_next_season))) {
    fold_df <- te_sos_production_board |>
      dplyr::filter(.data$target_next_season == .env$predict_season)
    
    keep_ppg <- is.finite(fold_df$te_sos_rank) & is.finite(fold_df$target_next_ppg)
    
    metric_rows[[idx]] <- data.frame(
      predict_season = predict_season,
      target = "target_next_ppg",
      n = sum(keep_ppg),
      spearman = if (sum(keep_ppg) > 1) {
        suppressWarnings(stats::cor(
          -fold_df$te_sos_rank[keep_ppg],
          fold_df$target_next_ppg[keep_ppg],
          method = "spearman"
        ))
      } else {
        NA_real_
      },
      stringsAsFactors = FALSE
    )
    idx <- idx + 1L
    
    keep_total <- is.finite(fold_df$te_sos_rank) & is.finite(fold_df$target_next_total_points)
    
    metric_rows[[idx]] <- data.frame(
      predict_season = predict_season,
      target = "target_next_total_points",
      n = sum(keep_total),
      spearman = if (sum(keep_total) > 1) {
        suppressWarnings(stats::cor(
          -fold_df$te_sos_rank[keep_total],
          fold_df$target_next_total_points[keep_total],
          method = "spearman"
        ))
      } else {
        NA_real_
      },
      stringsAsFactors = FALSE
    )
    idx <- idx + 1L
  }
  
  dplyr::bind_rows(metric_rows) |>
    dplyr::arrange(predict_season, target)
}

build_te_sos_weight_candidates <- function() {
  data.frame(
    candidate = c(
      "current_35_25_20_10_10",
      "anchor_heavy_45_20_15_10_10",
      "balanced_30_25_20_15_10",
      "omfg_heavy_30_20_25_10_15",
      "receiving_heavy_30_20_20_15_15"
    ),
    w_anchor_total = c(0.35, 0.45, 0.30, 0.30, 0.30),
    w_anchor_board = c(0.25, 0.20, 0.25, 0.20, 0.20),
    w_omfg = c(0.20, 0.15, 0.20, 0.25, 0.20),
    w_receiving = c(0.10, 0.10, 0.15, 0.10, 0.15),
    w_workload = c(0.10, 0.10, 0.10, 0.15, 0.15),
    stringsAsFactors = FALSE
  )
}

get_te_sos_production_candidate <- function() {
  "anchor_heavy_45_20_15_10_10"
}

build_te_sos_production_board_from_weights <- function(te_sos_features, weights_row) {
  load_model_core_packages()
  
  feature_table <- if (is.list(te_sos_features) && "feature_table" %in% names(te_sos_features)) {
    te_sos_features$feature_table
  } else {
    te_sos_features
  }
  
  feature_table |>
    dplyr::mutate(
      te_sos_final_score = (
        weights_row$w_anchor_total[[1]] * qb_rank_to_0_100(.data$te_sos_anchor_total_points) +
          weights_row$w_anchor_board[[1]] * .data$te_anchor_board_score +
          weights_row$w_omfg[[1]] * .data$te_preseason_omfg_score +
          weights_row$w_receiving[[1]] * .data$receiving_role_component_0to100 +
          weights_row$w_workload[[1]] * .data$workload_opportunity_component_0to100
      )
    ) |>
    dplyr::group_by(.data$target_next_season) |>
    dplyr::arrange(dplyr::desc(.data$te_sos_final_score), .data$player, .by_group = TRUE) |>
    dplyr::mutate(
      te_sos_rank = dplyr::row_number()
    ) |>
    dplyr::ungroup()
}

run_te_sos_production_board_step <- function(te_sos_features, write_output = TRUE, output_dir = model_paths$sos_output_dir) {
  load_model_core_packages()
  
  production_candidate <- get_te_sos_production_candidate()
  
  weights_row <- build_te_sos_weight_candidates() |>
    dplyr::filter(.data$candidate == .env$production_candidate) |>
    dplyr::slice(1)
  
  te_sos_production_board <- build_te_sos_production_board_from_weights(te_sos_features, weights_row) |>
    dplyr::mutate(
      te_sos_weight_profile = .env$production_candidate,
      te_sos_tier = dplyr::case_when(
        .data$te_sos_rank <= 6 ~ "Tier 1",
        .data$te_sos_rank <= 12 ~ "Tier 2",
        .data$te_sos_rank <= 18 ~ "Tier 3",
        .data$te_sos_rank <= 24 ~ "Tier 4",
        TRUE ~ "Tier 5"
      )
    )
  
  te_sos_board_metrics <- build_te_sos_board_metrics(te_sos_production_board)
  
  if (write_output) {
    utils::write.csv(
      te_sos_production_board,
      file.path(output_dir, "te_sos_production_board_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    
    utils::write.csv(
      te_sos_board_metrics,
      file.path(output_dir, "te_sos_production_board_metrics_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    board = te_sos_production_board,
    metrics = te_sos_board_metrics,
    production_candidate = production_candidate
  )
}

run_te_sos_weight_tuning <- function(te_sos_features, validation_seasons = 2023:2025, write_output = TRUE) {
  load_model_core_packages()
  
  candidates <- build_te_sos_weight_candidates()
  
  summary_rows <- list()
  metric_rows <- list()
  board_list <- list()
  
  for (i in seq_len(nrow(candidates))) {
    weights_row <- candidates[i, , drop = FALSE]
    candidate_name <- weights_row$candidate[[1]]
    
    board <- build_te_sos_production_board_from_weights(te_sos_features, weights_row)
    metrics <- build_te_sos_board_metrics(board) |>
      dplyr::mutate(candidate = candidate_name)
    
    board_list[[candidate_name]] <- board
    metric_rows[[i]] <- metrics
    
    val_metrics <- metrics |>
      dplyr::filter(.data$predict_season %in% .env$validation_seasons)
    
    ppg_metrics <- val_metrics |>
      dplyr::filter(.data$target == "target_next_ppg")
    
    total_metrics <- val_metrics |>
      dplyr::filter(.data$target == "target_next_total_points")
    
    summary_rows[[i]] <- data.frame(
      candidate = candidate_name,
      avg_ppg_spearman = mean(ppg_metrics$spearman, na.rm = TRUE),
      min_ppg_spearman = min(ppg_metrics$spearman, na.rm = TRUE),
      avg_total_spearman = mean(total_metrics$spearman, na.rm = TRUE),
      min_total_spearman = min(total_metrics$spearman, na.rm = TRUE),
      combined_score = mean(c(
        mean(ppg_metrics$spearman, na.rm = TRUE),
        mean(total_metrics$spearman, na.rm = TRUE)
      ), na.rm = TRUE),
      stringsAsFactors = FALSE
    )
  }
  
  summary_df <- dplyr::bind_rows(summary_rows) |>
    dplyr::arrange(dplyr::desc(.data$combined_score), dplyr::desc(.data$avg_ppg_spearman), dplyr::desc(.data$avg_total_spearman))
  
  metrics_df <- dplyr::bind_rows(metric_rows) |>
    dplyr::select(candidate, predict_season, target, n, spearman) |>
    dplyr::arrange(candidate, predict_season, target)
  
  if (write_output) {
    utils::write.csv(
      summary_df,
      file.path(model_paths$sos_output_dir, "te_sos_weight_tuning_summary_2023_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    
    utils::write.csv(
      metrics_df,
      file.path(model_paths$sos_output_dir, "te_sos_weight_tuning_metrics_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    summary = summary_df,
    metrics = metrics_df,
    boards = board_list
  )
}

build_te_sos_final_export <- function(te_sos_board, write_output = TRUE, output_dir = model_paths$sos_output_dir) {
  load_model_core_packages()
  
  board_df <- if (is.list(te_sos_board) && "board" %in% names(te_sos_board)) {
    te_sos_board$board
  } else {
    te_sos_board
  }
  
  out <- board_df |>
    dplyr::filter(is.finite(.data$te_sos_final_score)) |>
    dplyr::transmute(
      season = .data$target_next_season,
      rank = .data$te_sos_rank,
      tier = .data$te_sos_tier,
      player,
      current_team = .data$team,
      next_team = .data$target_next_team,
      games,
      starter_weeks,
      primary_role_weeks,
      age,
      rookie_year,
      weight_profile = .data$te_sos_weight_profile,
      final_score = .data$te_sos_final_score,
      anchor_ppg = .data$te_sos_anchor_ppg,
      anchor_total_points = .data$te_sos_anchor_total_points,
      preseason_omfg = .data$te_preseason_omfg_score,
      board_score = .data$te_anchor_board_score,
      production = .data$production_component_0to100,
      workload_opportunity = .data$workload_opportunity_component_0to100,
      receiving_role = .data$receiving_role_component_0to100,
      weekly_stability = .data$weekly_stability_component_0to100,
      efficiency_sustainability = .data$efficiency_sustainability_component_0to100,
      durability_role_confidence = .data$durability_role_confidence_component_0to100,
      actual_next_ppg = .data$target_next_ppg,
      actual_next_total_points = .data$target_next_total_points
    ) |>
    dplyr::arrange(.data$season, .data$rank)
  
  if (write_output) {
    utils::write.csv(
      out,
      file.path(output_dir, "te_sos_final_export_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

run_te_sos_full_pipeline <- function(write_output = TRUE) {
  load_model_core_packages()
  
  te_sos_target_table <- build_te_sos_target_table()
  te_sos_train <- run_te_sos_training_step(write_output = write_output)
  te_sos_baseline <- run_te_sos_baseline_model_step(write_output = write_output)
  te_sos_weighted <- run_te_sos_weighted_two_year_baseline(write_output = write_output)
  te_sos_compare <- compare_te_sos_models(te_sos_baseline, te_sos_weighted)
  te_sos_hybrid <- run_te_sos_hybrid_baseline(te_sos_baseline, te_sos_weighted, write_output = write_output)
  te_sos_all_compare <- compare_te_sos_all_models(te_sos_baseline, te_sos_weighted, te_sos_hybrid)
  te_sos_anchor <- run_te_sos_anchor_step(te_sos_weighted, te_sos_hybrid, write_output = write_output)
  te_sos_features <- run_te_sos_feature_overlay_step(te_sos_anchor, write_output = write_output)
  te_sos_board <- run_te_sos_production_board_step(te_sos_features, write_output = write_output)
  te_sos_tuning <- run_te_sos_weight_tuning(te_sos_features, write_output = write_output)
  te_sos_final_export <- build_te_sos_final_export(te_sos_board, write_output = write_output)
  
  list(
    te_sos_target_table = te_sos_target_table,
    te_sos_train = te_sos_train,
    te_sos_baseline = te_sos_baseline,
    te_sos_weighted = te_sos_weighted,
    te_sos_compare = te_sos_compare,
    te_sos_hybrid = te_sos_hybrid,
    te_sos_all_compare = te_sos_all_compare,
    te_sos_anchor = te_sos_anchor,
    te_sos_features = te_sos_features,
    te_sos_board = te_sos_board,
    te_sos_tuning = te_sos_tuning,
    te_sos_final_export = te_sos_final_export
  )
}

k_age_window_score <- function(age_vec) {
  age_vec <- safe_numeric(age_vec)
  out <- 100 - pmin(abs(age_vec - 29) * 6, 100)
  out[!is.finite(age_vec)] <- NA_real_
  out
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
      team_total_line = pick_first_existing_numeric(k_raw, c("G_total_off", "total_line_off", "total_off")),
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
      fgm = dplyr::coalesce(
        .data$fgm_0_19, 0
      ) + dplyr::coalesce(.data$fgm_20_29, 0) + dplyr::coalesce(.data$fgm_30_39, 0) +
        dplyr::coalesce(.data$fgm_40_49, 0) + dplyr::coalesce(.data$fgm_50_plus, 0),
      fga = dplyr::coalesce(
        .data$fga_0_19, 0
      ) + dplyr::coalesce(.data$fga_20_29, 0) + dplyr::coalesce(.data$fga_30_39, 0) +
        dplyr::coalesce(.data$fga_40_49, 0) + dplyr::coalesce(.data$fga_50_plus, 0),
      fg_pct = dplyr::coalesce(.data$extra_points_pct * 0 + compute_k_fg_pct_from_df(k_raw), round(safe_div(.data$fgm, .data$fga) * 100, 1)),
      fantasy_points_calc = compute_k_fantasy_points_from_df(k_raw),
      fantasy_points_official = dplyr::coalesce(.data$fantasy_points_source, .data$fantasy_points_calc),
      regular_season_flag = TRUE
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
    dplyr::transmute(
      season,
      week,
      team,
      primary_kicker_key = .data$player_key
    )
  
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
      .data$season,
      .data$week,
      .data$player_key,
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
      fantasy_point_share = safe_div(.data$fantasy_points_official, .data$team_k_fantasy_points),
      starter_flag = dplyr::if_else(!is.na(.data$depth_team) & .data$depth_team <= 1, 1L, 0L)
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

build_k_player_season_combined_table <- function(
    k_weekly = build_k_clean_weekly_master(),
    k_share = build_k_player_share_table(k_weekly = k_weekly),
    write_output = FALSE,
    output_dir = model_paths$foundation_output_dir
) {
  load_model_core_packages()
  
  k_team_season_context <- k_share |>
    dplyr::group_by(.data$season, .data$team) |>
    dplyr::summarise(
      team_games = dplyr::n_distinct(.data$week),
      team_fga = sum(.data$fga, na.rm = TRUE),
      team_xpa = sum(.data$extra_points_attempt, na.rm = TRUE),
      team_fgm = sum(.data$fgm, na.rm = TRUE),
      team_xpm = sum(.data$extra_points_made, na.rm = TRUE),
      team_fga_40_49 = sum(.data$fga_40_49, na.rm = TRUE),
      team_fgm_40_49 = sum(.data$fgm_40_49, na.rm = TRUE),
      team_fga_50_plus = sum(.data$fga_50_plus, na.rm = TRUE),
      team_fgm_50_plus = sum(.data$fgm_50_plus, na.rm = TRUE),
      .groups = "drop"
    ) |>
    dplyr::mutate(
      team_total_kick_ops = dplyr::coalesce(.data$team_fga, 0) + dplyr::coalesce(.data$team_xpa, 0),
      team_fga_per_game = safe_div(.data$team_fga, .data$team_games),
      team_xpa_per_game = safe_div(.data$team_xpa, .data$team_games),
      team_total_kick_ops_per_game = safe_div(.data$team_total_kick_ops, .data$team_games),
      team_long_fg_att_per_game = safe_div(.data$team_fga_40_49 + .data$team_fga_50_plus, .data$team_games),
      team_long_fg_made_per_game = safe_div(.data$team_fgm_40_49 + .data$team_fgm_50_plus, .data$team_games),
      team_fg_settle_rate = safe_div(.data$team_fga, .data$team_total_kick_ops),
      team_fg_pct = round(safe_div(.data$team_fgm, .data$team_fga) * 100, 1),
      team_xp_pct = round(safe_div(.data$team_xpm, .data$team_xpa) * 100, 1)
    )
  
  out <- k_share |>
    dplyr::arrange(.data$season, .data$player_key, .data$week) |>
    dplyr::group_by(.data$season, .data$player_key) |>
    dplyr::summarise(
      player = first_non_missing(rev(.data$player)),
      team = first_non_missing(rev(.data$team)),
      teams_played = paste(unique(.data$team[!is.na(.data$team) & .data$team != ""]), collapse = "/"),
      games = dplyr::n_distinct(.data$week),
      starter_weeks = sum(.data$starter_flag, na.rm = TRUE),
      best_depth_team = suppressWarnings(min(.data$depth_team, na.rm = TRUE)),
      draft_day = first_non_missing(rev(.data$draft_day)),
      rookie_year = suppressWarnings(min(.data$rookie_year, na.rm = TRUE)),
      age = suppressWarnings(max(.data$age, na.rm = TRUE)),
      fga = sum(.data$fga, na.rm = TRUE),
      fgm = sum(.data$fgm, na.rm = TRUE),
      xpa = sum(.data$extra_points_attempt, na.rm = TRUE),
      xpm = sum(.data$extra_points_made, na.rm = TRUE),
      fga_40_49 = sum(.data$fga_40_49, na.rm = TRUE),
      fgm_40_49 = sum(.data$fgm_40_49, na.rm = TRUE),
      fga_50_plus = sum(.data$fga_50_plus, na.rm = TRUE),
      fgm_50_plus = sum(.data$fgm_50_plus, na.rm = TRUE),
      fantasy_points = sum(.data$fantasy_points_official, na.rm = TRUE),
      fantasy_points_per_game = mean(.data$fantasy_points_official, na.rm = TRUE),
      fantasy_points_sd = stats::sd(.data$fantasy_points_official, na.rm = TRUE),
      weekly_floor_p25 = suppressWarnings(stats::quantile(.data$fantasy_points_official, probs = 0.25, na.rm = TRUE, names = FALSE)),
      weekly_median_p50 = suppressWarnings(stats::quantile(.data$fantasy_points_official, probs = 0.50, na.rm = TRUE, names = FALSE)),
      weekly_ceiling_p75 = suppressWarnings(stats::quantile(.data$fantasy_points_official, probs = 0.75, na.rm = TRUE, names = FALSE)),
      weekly_ceiling_p90 = suppressWarnings(stats::quantile(.data$fantasy_points_official, probs = 0.90, na.rm = TRUE, names = FALSE)),
      fga_share_mean = mean(.data$fga_share, na.rm = TRUE),
      fgm_share_mean = mean(.data$fgm_share, na.rm = TRUE),
      xpa_share_mean = mean(.data$xpa_share, na.rm = TRUE),
      xpm_share_mean = mean(.data$xpm_share, na.rm = TRUE),
      fantasy_point_share_mean = mean(.data$fantasy_point_share, na.rm = TRUE),
      .groups = "drop"
    ) |>
    dplyr::mutate(
      best_depth_team = ifelse(is.infinite(.data$best_depth_team), NA, .data$best_depth_team),
      fg_pct = round(safe_div(.data$fgm, .data$fga) * 100, 1),
      xp_pct = round(safe_div(.data$xpm, .data$xpa) * 100, 1),
      starter_rate = safe_div(.data$starter_weeks, .data$games),
      fga_per_game = safe_div(.data$fga, .data$games),
      fgm_per_game = safe_div(.data$fgm, .data$games),
      xpa_per_game = safe_div(.data$xpa, .data$games),
      xpm_per_game = safe_div(.data$xpm, .data$games),
      long_fg_attempts_per_game = safe_div(.data$fga_40_49 + .data$fga_50_plus, .data$games),
      long_fg_made_per_game = safe_div(.data$fgm_40_49 + .data$fgm_50_plus, .data$games),
      qualified_4_games_current = .data$games >= 4,
      qualified_8_games_current = .data$games >= 8,
      next_season = .data$season + 1L
    ) |>
    dplyr::left_join(
      k_team_season_context |>
        dplyr::select(
          .data$season,
          .data$team,
          .data$team_fga_per_game,
          .data$team_xpa_per_game,
          .data$team_total_kick_ops_per_game,
          .data$team_long_fg_att_per_game,
          .data$team_long_fg_made_per_game,
          .data$team_fg_settle_rate,
          .data$team_fg_pct,
          .data$team_xp_pct
        ),
      by = c("season", "team")
    ) |>
    dplyr::arrange(.data$season, dplyr::desc(.data$fantasy_points_per_game))
  
  duplicate_player_seasons <- out |>
    dplyr::count(.data$season, .data$player_key, name = "dup_n") |>
    dplyr::filter(.data$dup_n > 1)
  
  if (nrow(duplicate_player_seasons) > 0) {
    stop(
      paste0(
        "K player-season table has ", nrow(duplicate_player_seasons),
        " duplicate player-season keys after aggregation."
      ),
      call. = FALSE
    )
  }
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "k_player_season_combined_table_2021_2025_regular.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_k_sos_inputs <- function(write_output = FALSE) {
  load_model_core_packages()
  
  k_clean_weekly_master <- build_k_clean_weekly_master(write_output = write_output)
  k_team_week_opportunity <- build_k_team_week_opportunity_table(
    k_weekly = k_clean_weekly_master,
    write_output = write_output
  )
  k_player_share_table <- build_k_player_share_table(
    k_weekly = k_clean_weekly_master,
    team_week = k_team_week_opportunity,
    write_output = write_output
  )
  k_weekly_role_usage <- build_k_weekly_role_usage_table(
    k_share = k_player_share_table,
    write_output = write_output
  )
  k_player_season_combined_table <- build_k_player_season_combined_table(
    k_weekly = k_clean_weekly_master,
    k_share = k_player_share_table,
    write_output = write_output
  )
  
  out <- list(
    position = "K",
    mode = "season_over_season",
    handoff = NULL,
    handoff_text = NA_character_,
    k_clean_weekly_master = k_clean_weekly_master,
    k_team_week_opportunity = k_team_week_opportunity,
    k_player_share_table = k_player_share_table,
    k_weekly_role_usage = k_weekly_role_usage,
    k_player_season_combined_table = k_player_season_combined_table,
    player_season_index = build_sos_player_season_index("K"),
    next_steps = c(
      "Use the reconstructed kicker weekly scoring fields as the base layer.",
      "Blend production, volume, accuracy, and long-range profile for preseason ordering.",
      "Extend the same foundation into the week-over-week kicker board."
    )
  )
  
  if (write_output) {
    out$output_paths <- c(
      k_clean_weekly_master = file.path(model_paths$foundation_output_dir, "k_clean_weekly_master_2021_2025_regular.csv"),
      k_team_week_opportunity = file.path(model_paths$foundation_output_dir, "k_team_week_opportunity_2021_2025_regular.csv"),
      k_player_share_table = file.path(model_paths$foundation_output_dir, "k_player_share_table_2021_2025_regular.csv"),
      k_weekly_role_usage = file.path(model_paths$foundation_output_dir, "k_weekly_role_usage_2021_2025_regular.csv"),
      k_player_season_combined_table = file.path(model_paths$foundation_output_dir, "k_player_season_combined_table_2021_2025_regular.csv"),
      k_player_season_index = write_sos_player_season_index("K")
    )
  }
  
  out
}

make_k_sos_output_manifest <- function(k_sos_result) {
  output_paths <- unname(k_sos_result$output_paths %||% character())
  output_labels <- names(k_sos_result$output_paths %||% character())
  
  data.frame(
    output_name = output_labels,
    output_path = output_paths,
    exists = file.exists(output_paths),
    stringsAsFactors = FALSE
  )
}

run_k_sos_pipeline <- function(write_output = TRUE) {
  load_model_core_packages()
  
  dir.create(model_paths$foundation_output_dir, recursive = TRUE, showWarnings = FALSE)
  dir.create(model_paths$sos_output_dir, recursive = TRUE, showWarnings = FALSE)
  
  k_sos_result <- build_k_sos_inputs(write_output = write_output)
  output_manifest <- make_k_sos_output_manifest(k_sos_result)
  
  list(
    result = k_sos_result,
    output_manifest = output_manifest
  )
}

build_k_sos_target_table <- function(k_player_season_combined_table = NULL) {
  load_model_core_packages()
  
  if (is.null(k_player_season_combined_table)) {
    k_player_season_combined_table <- build_k_player_season_combined_table(write_output = FALSE)
  }
  
  k_player_season_combined_table |>
    dplyr::transmute(
      player_key,
      target_next_season = season,
      target_next_team = team,
      target_next_games = games,
      target_next_starter_weeks = starter_weeks,
      target_next_best_depth_team = best_depth_team,
      target_next_total_points = fantasy_points,
      target_next_ppg = fantasy_points_per_game,
      qualified_4_games_next = as.integer(target_next_games >= 4),
      qualified_8_games_next = as.integer(target_next_games >= 8)
    )
}

build_k_sos_training_frame <- function(
    write_output = FALSE,
    output_dir = model_paths$sos_output_dir,
    max_predict_season = 2025L
) {
  load_model_core_packages()
  
  k_player_season_combined_table <- build_k_player_season_combined_table(write_output = FALSE)
  k_sos_target_table <- build_k_sos_target_table(k_player_season_combined_table)
  
  out <- k_player_season_combined_table |>
    dplyr::mutate(
      target_next_season = next_season
    ) |>
    dplyr::left_join(
      k_sos_target_table,
      by = c("player_key", "target_next_season"),
      relationship = "many-to-one"
    ) |>
    dplyr::mutate(
      team_changed_next_season = as.integer(!is.na(.data$target_next_team) & .data$team != .data$target_next_team)
    ) |>
    dplyr::filter(
      .data$target_next_season >= 2022,
      .data$target_next_season <= .env$max_predict_season
    )
  
  predictor_cols <- c(
    "games", "starter_weeks", "best_depth_team", "age", "rookie_year",
    "fantasy_points", "fantasy_points_per_game", "fantasy_points_sd",
    "weekly_floor_p25", "weekly_median_p50", "weekly_ceiling_p75", "weekly_ceiling_p90",
    "fga", "fgm", "fg_pct", "xpa", "xpm", "xp_pct",
    "fga_per_game", "fgm_per_game", "xpa_per_game", "xpm_per_game",
    "long_fg_attempts_per_game", "long_fg_made_per_game",
    "fga_share_mean", "fgm_share_mean", "xpa_share_mean", "xpm_share_mean",
    "fantasy_point_share_mean", "starter_rate",
    "qualified_4_games_current", "qualified_8_games_current", "team_changed_next_season"
  )
  
  predictor_cols <- intersect(predictor_cols, names(out))
  
  out <- out |>
    dplyr::mutate(
      dplyr::across(dplyr::all_of(predictor_cols), safe_numeric),
      target_next_ppg = safe_numeric(.data$target_next_ppg),
      target_next_total_points = safe_numeric(.data$target_next_total_points),
      qualified_4_games_next = safe_numeric(.data$qualified_4_games_next),
      qualified_8_games_next = safe_numeric(.data$qualified_8_games_next)
    )
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, "k_sos_training_frame_2021_2024_to_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    utils::write.csv(
      k_sos_target_table,
      file.path(output_dir, "k_sos_target_table_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    k_sos_training_frame = out,
    k_sos_target_table = k_sos_target_table
  )
}

run_k_sos_training_step <- function(write_output = TRUE) {
  build_k_sos_training_frame(write_output = write_output)
}

build_k_sos_baseline_feature_set <- function() {
  k_sos_training_frame <- build_k_sos_training_frame(write_output = FALSE)$k_sos_training_frame
  
  predictor_cols <- c(
    "games", "starter_weeks", "best_depth_team", "age", "rookie_year",
    "fantasy_points", "fantasy_points_per_game", "fantasy_points_sd",
    "weekly_floor_p25", "weekly_median_p50", "weekly_ceiling_p75", "weekly_ceiling_p90",
    "fga", "fgm", "fg_pct", "xpa", "xpm", "xp_pct",
    "fga_per_game", "fgm_per_game", "xpa_per_game", "xpm_per_game",
    "long_fg_attempts_per_game", "long_fg_made_per_game",
    "fga_share_mean", "fgm_share_mean", "xpa_share_mean", "xpm_share_mean",
    "fantasy_point_share_mean", "starter_rate",
    "qualified_4_games_current", "qualified_8_games_current", "team_changed_next_season"
  )
  
  predictor_cols <- intersect(predictor_cols, names(k_sos_training_frame))
  
  k_sos_training_frame |>
    dplyr::mutate(
      dplyr::across(dplyr::all_of(predictor_cols), safe_numeric),
      target_next_ppg = safe_numeric(.data$target_next_ppg),
      target_next_total_points = safe_numeric(.data$target_next_total_points),
      qualified_4_games_next = safe_numeric(.data$qualified_4_games_next),
      qualified_8_games_next = safe_numeric(.data$qualified_8_games_next)
    )
}

run_k_sos_baseline_model_step <- function(write_output = TRUE, output_dir = model_paths$sos_output_dir) {
  load_model_core_packages()
  
  model_df <- build_k_sos_baseline_feature_set()
  
  predictor_cols <- c(
    "games", "starter_weeks", "best_depth_team", "age", "rookie_year",
    "fantasy_points", "fantasy_points_per_game", "fantasy_points_sd",
    "weekly_floor_p25", "weekly_median_p50", "weekly_ceiling_p75", "weekly_ceiling_p90",
    "fga", "fgm", "fg_pct", "xpa", "xpm", "xp_pct",
    "fga_per_game", "fgm_per_game", "xpa_per_game", "xpm_per_game",
    "long_fg_attempts_per_game", "long_fg_made_per_game",
    "fga_share_mean", "fgm_share_mean", "xpa_share_mean", "xpm_share_mean",
    "fantasy_point_share_mean", "starter_rate",
    "qualified_4_games_current", "qualified_8_games_current", "team_changed_next_season"
  )
  
  predictor_cols <- intersect(predictor_cols, names(model_df))
  
  predict_seasons <- sort(unique(model_df$target_next_season))
  predict_seasons <- predict_seasons[predict_seasons >= 2022 & predict_seasons <= 2025]
  
  prediction_list <- list()
  metric_list <- list()
  pred_idx <- 1L
  metric_idx <- 1L
  
  for (predict_season in predict_seasons) {
    train_df <- model_df |>
      dplyr::filter(
        .data$target_next_season < predict_season,
        !is.na(.data$target_next_ppg),
        !is.na(.data$target_next_total_points)
      )
    
    test_df <- model_df |>
      dplyr::filter(
        .data$target_next_season == predict_season,
        !is.na(.data$target_next_ppg),
        !is.na(.data$target_next_total_points)
      )
    
    if (nrow(train_df) == 0 || nrow(test_df) == 0) {
      next
    }
    
    imputed <- impute_numeric_medians(train_df, test_df, predictor_cols)
    train_df <- imputed$train
    test_df <- imputed$test
    
    ppg_formula <- stats::reformulate(predictor_cols, response = "target_next_ppg")
    total_formula <- stats::reformulate(predictor_cols, response = "target_next_total_points")
    
    ppg_model <- stats::lm(ppg_formula, data = train_df)
    total_model <- stats::lm(total_formula, data = train_df)
    
    pred_next_ppg <- as.numeric(stats::predict(ppg_model, newdata = test_df))
    pred_next_total_points <- as.numeric(stats::predict(total_model, newdata = test_df))
    
    fold_predictions <- test_df |>
      dplyr::transmute(
        train_through_season = predict_season - 1L,
        predict_season = target_next_season,
        source_season = season,
        player_key,
        player,
        current_team = team,
        next_team = target_next_team,
        target_next_games,
        qualified_4_games_current,
        qualified_8_games_current,
        qualified_4_games_next,
        qualified_8_games_next,
        target_next_ppg,
        pred_next_ppg,
        target_next_total_points,
        pred_next_total_points
      )
    
    prediction_list[[pred_idx]] <- fold_predictions
    pred_idx <- pred_idx + 1L
    
    overall_ppg <- calc_regression_metrics(fold_predictions$target_next_ppg, fold_predictions$pred_next_ppg)
    overall_ppg$predict_season <- predict_season
    overall_ppg$target <- "target_next_ppg"
    overall_ppg$sample <- "overall"
    metric_list[[metric_idx]] <- overall_ppg
    metric_idx <- metric_idx + 1L
    
    overall_total <- calc_regression_metrics(fold_predictions$target_next_total_points, fold_predictions$pred_next_total_points)
    overall_total$predict_season <- predict_season
    overall_total$target <- "target_next_total_points"
    overall_total$sample <- "overall"
    metric_list[[metric_idx]] <- overall_total
    metric_idx <- metric_idx + 1L
    
    keep_4_4 <- fold_predictions$qualified_4_games_current == 1 & fold_predictions$qualified_4_games_next == 1
    
    qual_ppg <- calc_regression_metrics(
      fold_predictions$target_next_ppg[keep_4_4],
      fold_predictions$pred_next_ppg[keep_4_4]
    )
    qual_ppg$predict_season <- predict_season
    qual_ppg$target <- "target_next_ppg"
    qual_ppg$sample <- "qualified_4_4"
    metric_list[[metric_idx]] <- qual_ppg
    metric_idx <- metric_idx + 1L
    
    qual_total <- calc_regression_metrics(
      fold_predictions$target_next_total_points[keep_4_4],
      fold_predictions$pred_next_total_points[keep_4_4]
    )
    qual_total$predict_season <- predict_season
    qual_total$target <- "target_next_total_points"
    qual_total$sample <- "qualified_4_4"
    metric_list[[metric_idx]] <- qual_total
    metric_idx <- metric_idx + 1L
  }
  
  predictions <- dplyr::bind_rows(prediction_list)
  metrics <- dplyr::bind_rows(metric_list) |>
    dplyr::select(predict_season, target, sample, n, mae, rmse, spearman) |>
    dplyr::arrange(predict_season, target, sample)
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    
    utils::write.csv(
      predictions,
      file.path(output_dir, "k_sos_baseline_predictions_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    
    utils::write.csv(
      metrics,
      file.path(output_dir, "k_sos_baseline_metrics_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    predictions = predictions,
    metrics = metrics
  )
}

build_k_sos_weighted_two_year_frame <- function() {
  load_model_core_packages()
  
  k_season <- build_k_player_season_combined_table(write_output = FALSE) |>
    dplyr::mutate(
      qualified_4_games_current = as.integer(.data$games >= 4),
      qualified_8_games_current = as.integer(.data$games >= 8)
    )
  
  k_target_frame <- k_season |>
    dplyr::transmute(
      player_key,
      target_next_season = season,
      target_next_team = team,
      target_next_games = games,
      target_next_ppg = fantasy_points_per_game,
      target_next_total_points = fantasy_points,
      qualified_4_games_next = as.integer(games >= 4),
      qualified_8_games_next = as.integer(games >= 8)
    )
  
  k_prior_frame <- k_season |>
    dplyr::transmute(
      player_key,
      season = season + 1L,
      prior_ppg = fantasy_points_per_game,
      prior_total_points = fantasy_points
    )
  
  k_season |>
    dplyr::mutate(target_next_season = season + 1L) |>
    dplyr::left_join(
      k_target_frame,
      by = c("player_key", "target_next_season"),
      relationship = "many-to-one"
    ) |>
    dplyr::left_join(
      k_prior_frame,
      by = c("player_key", "season"),
      relationship = "many-to-one"
    ) |>
    dplyr::mutate(
      weighted_two_year_ppg = dplyr::case_when(
        !is.na(.data$fantasy_points_per_game) & !is.na(.data$prior_ppg) ~ 0.65 * .data$fantasy_points_per_game + 0.35 * .data$prior_ppg,
        !is.na(.data$fantasy_points_per_game) ~ .data$fantasy_points_per_game,
        TRUE ~ .data$prior_ppg
      ),
      weighted_two_year_total_points = dplyr::case_when(
        !is.na(.data$fantasy_points) & !is.na(.data$prior_total_points) ~ 0.65 * .data$fantasy_points + 0.35 * .data$prior_total_points,
        !is.na(.data$fantasy_points) ~ .data$fantasy_points,
        TRUE ~ .data$prior_total_points
      )
    ) |>
    dplyr::filter(
      .data$target_next_season >= 2022,
      .data$target_next_season <= 2025,
      !is.na(.data$target_next_ppg),
      !is.na(.data$target_next_total_points)
    ) |>
    dplyr::arrange(.data$target_next_season, dplyr::desc(.data$weighted_two_year_ppg), .data$player)
}

run_k_sos_weighted_two_year_baseline <- function(write_output = TRUE, output_dir = model_paths$sos_output_dir) {
  load_model_core_packages()
  
  predictions <- build_k_sos_weighted_two_year_frame() |>
    dplyr::transmute(
      predict_season = target_next_season,
      source_season = season,
      player_key,
      player,
      current_team = team,
      next_team = target_next_team,
      qualified_4_games_current,
      qualified_8_games_current,
      qualified_4_games_next,
      qualified_8_games_next,
      target_next_ppg,
      pred_next_ppg = weighted_two_year_ppg,
      target_next_total_points,
      pred_next_total_points = weighted_two_year_total_points
    )
  
  metric_list <- list()
  idx <- 1L
  
  for (predict_season in sort(unique(predictions$predict_season))) {
    fold_df <- predictions |>
      dplyr::filter(.data$predict_season == .env$predict_season)
    
    overall_ppg <- calc_regression_metrics(fold_df$target_next_ppg, fold_df$pred_next_ppg)
    overall_ppg$predict_season <- predict_season
    overall_ppg$target <- "target_next_ppg"
    overall_ppg$sample <- "overall"
    metric_list[[idx]] <- overall_ppg
    idx <- idx + 1L
    
    qual_df <- fold_df |>
      dplyr::filter(.data$qualified_4_games_current == 1, .data$qualified_4_games_next == 1)
    
    qual_ppg <- calc_regression_metrics(qual_df$target_next_ppg, qual_df$pred_next_ppg)
    qual_ppg$predict_season <- predict_season
    qual_ppg$target <- "target_next_ppg"
    qual_ppg$sample <- "qualified_4_4"
    metric_list[[idx]] <- qual_ppg
    idx <- idx + 1L
    
    overall_total <- calc_regression_metrics(fold_df$target_next_total_points, fold_df$pred_next_total_points)
    overall_total$predict_season <- predict_season
    overall_total$target <- "target_next_total_points"
    overall_total$sample <- "overall"
    metric_list[[idx]] <- overall_total
    idx <- idx + 1L
    
    qual_total <- calc_regression_metrics(qual_df$target_next_total_points, qual_df$pred_next_total_points)
    qual_total$predict_season <- predict_season
    qual_total$target <- "target_next_total_points"
    qual_total$sample <- "qualified_4_4"
    metric_list[[idx]] <- qual_total
    idx <- idx + 1L
  }
  
  metrics <- dplyr::bind_rows(metric_list) |>
    dplyr::select(predict_season, target, sample, n, mae, rmse, spearman) |>
    dplyr::arrange(predict_season, target, sample)
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    
    utils::write.csv(
      predictions,
      file.path(output_dir, "k_sos_weighted_two_year_predictions_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    
    utils::write.csv(
      metrics,
      file.path(output_dir, "k_sos_weighted_two_year_metrics_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    predictions = predictions,
    metrics = metrics
  )
}

run_k_sos_hybrid_baseline <- function(k_sos_baseline, k_sos_weighted, write_output = TRUE, output_dir = model_paths$sos_output_dir) {
  load_model_core_packages()
  
  hybrid_predictions <- k_sos_weighted$predictions |>
    dplyr::left_join(
      k_sos_baseline$predictions |>
        dplyr::select(
          predict_season,
          player_key,
          pred_next_ppg_linear = pred_next_ppg,
          pred_next_total_points_linear = pred_next_total_points
        ),
      by = c("predict_season", "player_key")
    ) |>
    dplyr::mutate(
      pred_next_ppg = 0.70 * .data$pred_next_ppg + 0.30 * .data$pred_next_ppg_linear,
      pred_next_total_points = 0.70 * .data$pred_next_total_points + 0.30 * .data$pred_next_total_points_linear
    )
  
  metric_list <- list()
  idx <- 1L
  
  for (predict_season in sort(unique(hybrid_predictions$predict_season))) {
    fold_df <- hybrid_predictions |>
      dplyr::filter(.data$predict_season == .env$predict_season)
    
    overall_ppg <- calc_regression_metrics(fold_df$target_next_ppg, fold_df$pred_next_ppg)
    overall_ppg$predict_season <- predict_season
    overall_ppg$target <- "target_next_ppg"
    overall_ppg$sample <- "overall"
    metric_list[[idx]] <- overall_ppg
    idx <- idx + 1L
    
    qual_df <- fold_df |>
      dplyr::filter(.data$qualified_4_games_current == 1, .data$qualified_4_games_next == 1)
    
    qual_ppg <- calc_regression_metrics(qual_df$target_next_ppg, qual_df$pred_next_ppg)
    qual_ppg$predict_season <- predict_season
    qual_ppg$target <- "target_next_ppg"
    qual_ppg$sample <- "qualified_4_4"
    metric_list[[idx]] <- qual_ppg
    idx <- idx + 1L
    
    overall_total <- calc_regression_metrics(fold_df$target_next_total_points, fold_df$pred_next_total_points)
    overall_total$predict_season <- predict_season
    overall_total$target <- "target_next_total_points"
    overall_total$sample <- "overall"
    metric_list[[idx]] <- overall_total
    idx <- idx + 1L
    
    qual_total <- calc_regression_metrics(qual_df$target_next_total_points, qual_df$pred_next_total_points)
    qual_total$predict_season <- predict_season
    qual_total$target <- "target_next_total_points"
    qual_total$sample <- "qualified_4_4"
    metric_list[[idx]] <- qual_total
    idx <- idx + 1L
  }
  
  hybrid_metrics <- dplyr::bind_rows(metric_list) |>
    dplyr::select(predict_season, target, sample, n, mae, rmse, spearman) |>
    dplyr::arrange(predict_season, target, sample)
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    
    utils::write.csv(
      hybrid_predictions,
      file.path(output_dir, "k_sos_hybrid_baseline_predictions_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    
    utils::write.csv(
      hybrid_metrics,
      file.path(output_dir, "k_sos_hybrid_baseline_metrics_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    predictions = hybrid_predictions,
    metrics = hybrid_metrics
  )
}

compare_k_sos_models <- function(k_sos_baseline, k_sos_weighted) {
  dplyr::bind_rows(
    k_sos_baseline$metrics |>
      dplyr::mutate(model = "linear_baseline"),
    k_sos_weighted$metrics |>
      dplyr::mutate(model = "weighted_two_year")
  ) |>
    dplyr::select(model, predict_season, target, sample, n, mae, rmse, spearman) |>
    dplyr::arrange(target, sample, predict_season, model)
}

compare_k_sos_all_models <- function(k_sos_baseline, k_sos_weighted, k_sos_hybrid) {
  dplyr::bind_rows(
    k_sos_baseline$metrics |>
      dplyr::mutate(model = "linear_baseline"),
    k_sos_weighted$metrics |>
      dplyr::mutate(model = "weighted_two_year"),
    k_sos_hybrid$metrics |>
      dplyr::mutate(model = "hybrid_70_30")
  ) |>
    dplyr::select(model, predict_season, target, sample, n, mae, rmse, spearman) |>
    dplyr::arrange(target, sample, predict_season, model)
}

build_k_sos_anchor_predictions <- function(k_sos_weighted, k_sos_hybrid, write_output = TRUE, output_dir = model_paths$sos_output_dir) {
  load_model_core_packages()
  
  weighted_df <- k_sos_weighted$predictions |>
    dplyr::rename(
      weighted_pred_next_ppg = pred_next_ppg,
      weighted_pred_next_total_points = pred_next_total_points
    )
  
  hybrid_df <- k_sos_hybrid$predictions |>
    dplyr::rename(
      hybrid_pred_next_ppg = pred_next_ppg,
      hybrid_pred_next_total_points = pred_next_total_points
    )
  
  out <- dplyr::full_join(
    weighted_df,
    hybrid_df,
    by = c(
      "predict_season",
      "source_season",
      "player_key",
      "player",
      "current_team",
      "next_team",
      "qualified_4_games_current",
      "qualified_8_games_current",
      "qualified_4_games_next",
      "qualified_8_games_next",
      "target_next_ppg",
      "target_next_total_points"
    )
  ) |>
    dplyr::mutate(
      k_sos_anchor_ppg = dplyr::coalesce(.data$weighted_pred_next_ppg, .data$hybrid_pred_next_ppg),
      k_sos_anchor_total_points = dplyr::coalesce(.data$weighted_pred_next_total_points, .data$hybrid_pred_next_total_points),
      k_sos_anchor_model_ppg = dplyr::if_else(!is.na(.data$weighted_pred_next_ppg), "weighted_two_year", "hybrid_70_30"),
      k_sos_anchor_model_total_points = dplyr::if_else(!is.na(.data$weighted_pred_next_total_points), "weighted_two_year", "hybrid_70_30")
    ) |>
    dplyr::arrange(.data$predict_season, dplyr::desc(.data$k_sos_anchor_ppg), .data$player)
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    
    utils::write.csv(
      out,
      file.path(output_dir, "k_sos_anchor_predictions_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_k_sos_anchor_metrics <- function(k_sos_anchor_predictions) {
  load_model_core_packages()
  
  metric_list <- list()
  idx <- 1L
  
  for (predict_season in sort(unique(k_sos_anchor_predictions$predict_season))) {
    fold_df <- k_sos_anchor_predictions |>
      dplyr::filter(.data$predict_season == .env$predict_season)
    
    overall_ppg <- calc_regression_metrics(fold_df$target_next_ppg, fold_df$k_sos_anchor_ppg)
    overall_ppg$predict_season <- predict_season
    overall_ppg$target <- "target_next_ppg"
    overall_ppg$sample <- "overall"
    metric_list[[idx]] <- overall_ppg
    idx <- idx + 1L
    
    qual_df <- fold_df |>
      dplyr::filter(.data$qualified_4_games_current == 1, .data$qualified_4_games_next == 1)
    
    qual_ppg <- calc_regression_metrics(qual_df$target_next_ppg, qual_df$k_sos_anchor_ppg)
    qual_ppg$predict_season <- predict_season
    qual_ppg$target <- "target_next_ppg"
    qual_ppg$sample <- "qualified_4_4"
    metric_list[[idx]] <- qual_ppg
    idx <- idx + 1L
    
    overall_total <- calc_regression_metrics(fold_df$target_next_total_points, fold_df$k_sos_anchor_total_points)
    overall_total$predict_season <- predict_season
    overall_total$target <- "target_next_total_points"
    overall_total$sample <- "overall"
    metric_list[[idx]] <- overall_total
    idx <- idx + 1L
    
    qual_total <- calc_regression_metrics(qual_df$target_next_total_points, qual_df$k_sos_anchor_total_points)
    qual_total$predict_season <- predict_season
    qual_total$target <- "target_next_total_points"
    qual_total$sample <- "qualified_4_4"
    metric_list[[idx]] <- qual_total
    idx <- idx + 1L
  }
  
  dplyr::bind_rows(metric_list) |>
    dplyr::select(predict_season, target, sample, n, mae, rmse, spearman) |>
    dplyr::arrange(predict_season, target, sample)
}

run_k_sos_anchor_step <- function(k_sos_weighted, k_sos_hybrid, write_output = TRUE) {
  load_model_core_packages()
  
  k_sos_anchor_predictions <- build_k_sos_anchor_predictions(
    k_sos_weighted = k_sos_weighted,
    k_sos_hybrid = k_sos_hybrid,
    write_output = write_output
  )
  
  k_sos_anchor_metrics <- build_k_sos_anchor_metrics(k_sos_anchor_predictions)
  
  if (write_output) {
    utils::write.csv(
      k_sos_anchor_metrics,
      file.path(model_paths$sos_output_dir, "k_sos_anchor_metrics_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    predictions = k_sos_anchor_predictions,
    metrics = k_sos_anchor_metrics
  )
}

build_k_sos_feature_overlay_table <- function(k_sos_anchor, max_predict_season = 2025L) {
  load_model_core_packages()
  
  k_anchor_predictions <- if (is.list(k_sos_anchor) && "predictions" %in% names(k_sos_anchor)) {
    k_sos_anchor$predictions
  } else {
    k_sos_anchor
  }
  
  k_train <- build_k_sos_training_frame(
    write_output = FALSE,
    max_predict_season = max_predict_season
  )$k_sos_training_frame
  
  k_train |>
    dplyr::left_join(
      k_anchor_predictions |>
        dplyr::select(
          predict_season,
          source_season,
          player_key,
          k_sos_anchor_ppg,
          k_sos_anchor_total_points,
          k_sos_anchor_model_ppg,
          k_sos_anchor_model_total_points
        ),
      by = c(
        "target_next_season" = "predict_season",
        "season" = "source_season",
        "player_key" = "player_key"
      )
    ) |>
    dplyr::mutate(
      starter_rate = dplyr::coalesce(.data$starter_rate, safe_div(.data$starter_weeks, .data$games)),
      production_component_0to100 = qb_row_mean(
        qb_rank_to_0_100(.data$fantasy_points_per_game),
        qb_rank_to_0_100(.data$fantasy_points),
        qb_rank_to_0_100(.data$fgm_per_game),
        qb_rank_to_0_100(.data$xpm_per_game)
      ),
      volume_opportunity_component_0to100 = qb_row_mean(
        qb_rank_to_0_100(.data$fga_per_game),
        qb_rank_to_0_100(.data$xpa_per_game),
        qb_rank_to_0_100(.data$long_fg_attempts_per_game),
        qb_rank_to_0_100(.data$fantasy_point_share_mean)
      ),
      team_opportunity_diagnostic_component_0to100 = qb_row_mean(
        qb_rank_to_0_100(.data$team_fga_per_game),
        qb_rank_to_0_100(.data$team_xpa_per_game),
        qb_rank_to_0_100(.data$team_total_kick_ops_per_game),
        qb_rank_to_0_100(.data$team_long_fg_att_per_game)
      ),
      team_fg_settle_diagnostic_component_0to100 = qb_row_mean(
        qb_rank_to_0_100(.data$team_fg_settle_rate)
      ),
      accuracy_range_component_0to100 = qb_row_mean(
        qb_rank_to_0_100(.data$fg_pct),
        qb_rank_to_0_100(.data$xp_pct),
        qb_rank_to_0_100(.data$weekly_floor_p25),
        qb_rank_to_0_100(.data$weekly_median_p50),
        qb_rank_to_0_100(.data$weekly_ceiling_p75),
        qb_rank_to_0_100(.data$fantasy_points_sd, higher_is_better = FALSE)
      ),
      distance_profile_component_0to100 = qb_row_mean(
        qb_rank_to_0_100(.data$long_fg_made_per_game),
        qb_rank_to_0_100(.data$long_fg_attempts_per_game),
        qb_rank_to_0_100(safe_div(.data$fgm_40_49 + .data$fgm_50_plus, .data$fga_40_49 + .data$fga_50_plus))
      ),
      durability_role_confidence_component_0to100 = qb_row_mean(
        k_age_window_score(.data$age),
        qb_rank_to_0_100(.data$games),
        qb_rank_to_0_100(.data$starter_weeks),
        qb_rank_to_0_100(.data$starter_rate),
        qb_rank_to_0_100(.data$best_depth_team, higher_is_better = FALSE)
      ),
      # Keep SOS scoring player-centered. Team opportunity and FG-settle
      # fields remain diagnostics because they are less stable across seasons.
      k_preseason_omfg_score = (
        0.30 * .data$production_component_0to100 +
          0.25 * .data$volume_opportunity_component_0to100 +
          0.20 * .data$accuracy_range_component_0to100 +
          0.10 * .data$distance_profile_component_0to100 +
          0.15 * .data$durability_role_confidence_component_0to100
      ),
      k_anchor_board_score = qb_row_mean(
        qb_rank_to_0_100(.data$k_sos_anchor_ppg),
        qb_rank_to_0_100(.data$k_sos_anchor_total_points),
        .data$k_preseason_omfg_score
      )
    ) |>
    dplyr::arrange(.data$target_next_season, dplyr::desc(.data$k_anchor_board_score), .data$player)
}

build_k_sos_feature_overlay_metrics <- function(k_sos_feature_overlay) {
  load_model_core_packages()
  
  feature_cols <- c(
    "production_component_0to100",
    "volume_opportunity_component_0to100",
    "team_opportunity_diagnostic_component_0to100",
    "team_fg_settle_diagnostic_component_0to100",
    "accuracy_range_component_0to100",
    "distance_profile_component_0to100",
    "durability_role_confidence_component_0to100",
    "k_preseason_omfg_score",
    "k_anchor_board_score",
    "k_sos_anchor_ppg",
    "k_sos_anchor_total_points"
  )
  
  metric_rows <- list()
  idx <- 1L
  
  for (feature_col in feature_cols) {
    keep_ppg <- is.finite(k_sos_feature_overlay[[feature_col]]) & is.finite(k_sos_feature_overlay$target_next_ppg)
    
    metric_rows[[idx]] <- data.frame(
      feature = feature_col,
      target = "target_next_ppg",
      n = sum(keep_ppg),
      spearman = if (sum(keep_ppg) > 1) {
        suppressWarnings(stats::cor(
          k_sos_feature_overlay[[feature_col]][keep_ppg],
          k_sos_feature_overlay$target_next_ppg[keep_ppg],
          method = "spearman"
        ))
      } else {
        NA_real_
      },
      stringsAsFactors = FALSE
    )
    idx <- idx + 1L
    
    keep_total <- is.finite(k_sos_feature_overlay[[feature_col]]) & is.finite(k_sos_feature_overlay$target_next_total_points)
    
    metric_rows[[idx]] <- data.frame(
      feature = feature_col,
      target = "target_next_total_points",
      n = sum(keep_total),
      spearman = if (sum(keep_total) > 1) {
        suppressWarnings(stats::cor(
          k_sos_feature_overlay[[feature_col]][keep_total],
          k_sos_feature_overlay$target_next_total_points[keep_total],
          method = "spearman"
        ))
      } else {
        NA_real_
      },
      stringsAsFactors = FALSE
    )
    idx <- idx + 1L
  }
  
  dplyr::bind_rows(metric_rows) |>
    dplyr::arrange(target, dplyr::desc(spearman), feature)
}

run_k_sos_feature_overlay_step <- function(
    k_sos_anchor,
    write_output = TRUE,
    max_predict_season = 2025L
) {
  load_model_core_packages()
  
  k_sos_feature_overlay <- build_k_sos_feature_overlay_table(
    k_sos_anchor,
    max_predict_season = max_predict_season
  )
  k_sos_feature_metrics <- build_k_sos_feature_overlay_metrics(k_sos_feature_overlay)
  
  if (write_output) {
    dir.create(model_paths$sos_output_dir, recursive = TRUE, showWarnings = FALSE)
    
    utils::write.csv(
      k_sos_feature_overlay,
      file.path(model_paths$sos_output_dir, "k_sos_feature_overlay_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    
    utils::write.csv(
      k_sos_feature_metrics,
      file.path(model_paths$sos_output_dir, "k_sos_feature_overlay_metrics_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    feature_table = k_sos_feature_overlay,
    metrics = k_sos_feature_metrics
  )
}

build_k_sos_board_metrics <- function(k_sos_production_board) {
  load_model_core_packages()
  
  metric_rows <- list()
  idx <- 1L
  
  for (predict_season in sort(unique(k_sos_production_board$target_next_season))) {
    fold_df <- k_sos_production_board |>
      dplyr::filter(.data$target_next_season == .env$predict_season)
    
    keep_ppg <- is.finite(fold_df$k_sos_rank) & is.finite(fold_df$target_next_ppg)
    
    metric_rows[[idx]] <- data.frame(
      predict_season = predict_season,
      target = "target_next_ppg",
      n = sum(keep_ppg),
      spearman = if (sum(keep_ppg) > 1) {
        suppressWarnings(stats::cor(
          -fold_df$k_sos_rank[keep_ppg],
          fold_df$target_next_ppg[keep_ppg],
          method = "spearman"
        ))
      } else {
        NA_real_
      },
      stringsAsFactors = FALSE
    )
    idx <- idx + 1L
    
    keep_total <- is.finite(fold_df$k_sos_rank) & is.finite(fold_df$target_next_total_points)
    
    metric_rows[[idx]] <- data.frame(
      predict_season = predict_season,
      target = "target_next_total_points",
      n = sum(keep_total),
      spearman = if (sum(keep_total) > 1) {
        suppressWarnings(stats::cor(
          -fold_df$k_sos_rank[keep_total],
          fold_df$target_next_total_points[keep_total],
          method = "spearman"
        ))
      } else {
        NA_real_
      },
      stringsAsFactors = FALSE
    )
    idx <- idx + 1L
  }
  
  dplyr::bind_rows(metric_rows) |>
    dplyr::arrange(predict_season, target)
}

build_k_sos_weight_candidates <- function() {
  data.frame(
    candidate = c(
      "current_35_25_20_10_10",
      "anchor_heavy_45_20_15_10_10",
      "volume_heavy_30_20_20_20_10",
      "accuracy_heavy_30_20_20_10_20",
      "balanced_30_25_20_15_10"
    ),
    w_anchor_total = c(0.35, 0.45, 0.30, 0.30, 0.30),
    w_anchor_board = c(0.25, 0.20, 0.20, 0.20, 0.25),
    w_omfg = c(0.20, 0.15, 0.20, 0.20, 0.20),
    w_volume = c(0.10, 0.10, 0.20, 0.10, 0.15),
    w_accuracy = c(0.10, 0.10, 0.10, 0.20, 0.10),
    stringsAsFactors = FALSE
  )
}

get_k_sos_production_candidate <- function() {
  "anchor_heavy_45_20_15_10_10"
}

build_k_sos_production_board_from_weights <- function(k_sos_features, weights_row) {
  load_model_core_packages()
  
  feature_table <- if (is.list(k_sos_features) && "feature_table" %in% names(k_sos_features)) {
    k_sos_features$feature_table
  } else {
    k_sos_features
  }
  
  feature_table |>
    dplyr::mutate(
      k_sos_final_score = (
        weights_row$w_anchor_total[[1]] * qb_rank_to_0_100(.data$k_sos_anchor_total_points) +
          weights_row$w_anchor_board[[1]] * .data$k_anchor_board_score +
          weights_row$w_omfg[[1]] * .data$k_preseason_omfg_score +
          weights_row$w_volume[[1]] * .data$volume_opportunity_component_0to100 +
          weights_row$w_accuracy[[1]] * .data$accuracy_range_component_0to100
      )
    ) |>
    dplyr::group_by(.data$target_next_season) |>
    dplyr::arrange(dplyr::desc(.data$k_sos_final_score), .data$player, .by_group = TRUE) |>
    dplyr::mutate(
      k_sos_rank = dplyr::row_number()
    ) |>
    dplyr::ungroup()
}

run_k_sos_production_board_step <- function(k_sos_features, write_output = TRUE, output_dir = model_paths$sos_output_dir) {
  load_model_core_packages()
  
  production_candidate <- get_k_sos_production_candidate()
  
  weights_row <- build_k_sos_weight_candidates() |>
    dplyr::filter(.data$candidate == .env$production_candidate) |>
    dplyr::slice(1)
  
  k_sos_production_board <- build_k_sos_production_board_from_weights(k_sos_features, weights_row) |>
    dplyr::mutate(
      k_sos_weight_profile = .env$production_candidate,
      k_sos_tier = dplyr::case_when(
        .data$k_sos_rank <= 3 ~ "Tier 1",
        .data$k_sos_rank <= 8 ~ "Tier 2",
        .data$k_sos_rank <= 16 ~ "Tier 3",
        .data$k_sos_rank <= 24 ~ "Tier 4",
        TRUE ~ "Tier 5"
      )
    )
  
  k_sos_board_metrics <- build_k_sos_board_metrics(k_sos_production_board)
  
  if (write_output) {
    utils::write.csv(
      k_sos_production_board,
      file.path(output_dir, "k_sos_production_board_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    
    utils::write.csv(
      k_sos_board_metrics,
      file.path(output_dir, "k_sos_production_board_metrics_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    board = k_sos_production_board,
    metrics = k_sos_board_metrics,
    production_candidate = production_candidate
  )
}

run_k_sos_weight_tuning <- function(k_sos_features, validation_seasons = 2023:2025, write_output = TRUE) {
  load_model_core_packages()
  
  candidates <- build_k_sos_weight_candidates()
  
  summary_rows <- list()
  metric_rows <- list()
  board_list <- list()
  
  for (i in seq_len(nrow(candidates))) {
    weights_row <- candidates[i, , drop = FALSE]
    candidate_name <- weights_row$candidate[[1]]
    
    board <- build_k_sos_production_board_from_weights(k_sos_features, weights_row)
    metrics <- build_k_sos_board_metrics(board) |>
      dplyr::mutate(candidate = candidate_name)
    
    board_list[[candidate_name]] <- board
    metric_rows[[i]] <- metrics
    
    val_metrics <- metrics |>
      dplyr::filter(.data$predict_season %in% .env$validation_seasons)
    
    ppg_metrics <- val_metrics |>
      dplyr::filter(.data$target == "target_next_ppg")
    
    total_metrics <- val_metrics |>
      dplyr::filter(.data$target == "target_next_total_points")
    
    summary_rows[[i]] <- data.frame(
      candidate = candidate_name,
      avg_ppg_spearman = mean(ppg_metrics$spearman, na.rm = TRUE),
      min_ppg_spearman = min(ppg_metrics$spearman, na.rm = TRUE),
      avg_total_spearman = mean(total_metrics$spearman, na.rm = TRUE),
      min_total_spearman = min(total_metrics$spearman, na.rm = TRUE),
      combined_score = mean(c(
        mean(ppg_metrics$spearman, na.rm = TRUE),
        mean(total_metrics$spearman, na.rm = TRUE)
      ), na.rm = TRUE),
      stringsAsFactors = FALSE
    )
  }
  
  summary_df <- dplyr::bind_rows(summary_rows) |>
    dplyr::arrange(dplyr::desc(.data$combined_score), dplyr::desc(.data$avg_ppg_spearman), dplyr::desc(.data$avg_total_spearman))
  
  metrics_df <- dplyr::bind_rows(metric_rows) |>
    dplyr::select(candidate, predict_season, target, n, spearman) |>
    dplyr::arrange(candidate, predict_season, target)
  
  if (write_output) {
    utils::write.csv(
      summary_df,
      file.path(model_paths$sos_output_dir, "k_sos_weight_tuning_summary_2023_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    
    utils::write.csv(
      metrics_df,
      file.path(model_paths$sos_output_dir, "k_sos_weight_tuning_metrics_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  list(
    summary = summary_df,
    metrics = metrics_df,
    boards = board_list
  )
}

build_k_sos_final_export <- function(k_sos_board, write_output = TRUE, output_dir = model_paths$sos_output_dir) {
  load_model_core_packages()
  
  board_df <- if (is.list(k_sos_board) && "board" %in% names(k_sos_board)) {
    k_sos_board$board
  } else {
    k_sos_board
  }
  
  out <- board_df |>
    dplyr::filter(is.finite(.data$k_sos_final_score)) |>
    dplyr::transmute(
      season = .data$target_next_season,
      rank = .data$k_sos_rank,
      tier = .data$k_sos_tier,
      player,
      current_team = .data$team,
      next_team = .data$target_next_team,
      games,
      starter_weeks,
      age,
      rookie_year,
      weight_profile = .data$k_sos_weight_profile,
      final_score = .data$k_sos_final_score,
      anchor_ppg = .data$k_sos_anchor_ppg,
      anchor_total_points = .data$k_sos_anchor_total_points,
      preseason_omfg = .data$k_preseason_omfg_score,
      board_score = .data$k_anchor_board_score,
      production = .data$production_component_0to100,
      volume_opportunity = .data$volume_opportunity_component_0to100,
      team_opportunity_diagnostic = .data$team_opportunity_diagnostic_component_0to100,
      team_fg_settle_diagnostic = .data$team_fg_settle_diagnostic_component_0to100,
      accuracy_range = .data$accuracy_range_component_0to100,
      distance_profile = .data$distance_profile_component_0to100,
      durability_role_confidence = .data$durability_role_confidence_component_0to100,
      team_fga_per_game = .data$team_fga_per_game,
      team_xpa_per_game = .data$team_xpa_per_game,
      team_total_kick_ops_per_game = .data$team_total_kick_ops_per_game,
      team_fg_settle_rate = .data$team_fg_settle_rate,
      actual_next_ppg = .data$target_next_ppg,
      actual_next_total_points = .data$target_next_total_points
    ) |>
    dplyr::arrange(.data$season, .data$rank)
  
  if (write_output) {
    utils::write.csv(
      out,
      file.path(output_dir, "k_sos_final_export_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

run_k_sos_full_pipeline <- function(write_output = TRUE) {
  load_model_core_packages()
  
  k_sos_target_table <- build_k_sos_target_table()
  k_sos_train <- run_k_sos_training_step(write_output = write_output)
  k_sos_baseline <- run_k_sos_baseline_model_step(write_output = write_output)
  k_sos_weighted <- run_k_sos_weighted_two_year_baseline(write_output = write_output)
  k_sos_compare <- compare_k_sos_models(k_sos_baseline, k_sos_weighted)
  k_sos_hybrid <- run_k_sos_hybrid_baseline(k_sos_baseline, k_sos_weighted, write_output = write_output)
  k_sos_all_compare <- compare_k_sos_all_models(k_sos_baseline, k_sos_weighted, k_sos_hybrid)
  k_sos_anchor <- run_k_sos_anchor_step(k_sos_weighted, k_sos_hybrid, write_output = write_output)
  k_sos_features <- run_k_sos_feature_overlay_step(k_sos_anchor, write_output = write_output)
  k_sos_board <- run_k_sos_production_board_step(k_sos_features, write_output = write_output)
  k_sos_tuning <- run_k_sos_weight_tuning(k_sos_features, write_output = write_output)
  k_sos_final_export <- build_k_sos_final_export(k_sos_board, write_output = write_output)
  
  list(
    k_sos_target_table = k_sos_target_table,
    k_sos_train = k_sos_train,
    k_sos_baseline = k_sos_baseline,
    k_sos_weighted = k_sos_weighted,
    k_sos_compare = k_sos_compare,
    k_sos_hybrid = k_sos_hybrid,
    k_sos_all_compare = k_sos_all_compare,
    k_sos_anchor = k_sos_anchor,
    k_sos_features = k_sos_features,
    k_sos_board = k_sos_board,
    k_sos_tuning = k_sos_tuning,
    k_sos_final_export = k_sos_final_export
  )
}

build_core_sos_lock_summary <- function(write_output = FALSE, output_dir = model_paths$sos_output_dir) {
  load_model_core_packages()
  
  out <- data.frame(
    position = c("QB", "RB", "WR", "TE", "K", "DST"),
    production_candidate = c(
      get_qb_sos_production_candidate(),
      get_rb_sos_production_candidate(),
      get_wr_sos_production_candidate(),
      get_te_sos_production_candidate(),
      get_k_sos_production_candidate(),
      get_dst_sos_production_candidate()
    ),
    final_export_path = c(
      file.path(output_dir, "qb_sos_final_export_2022_2025.csv"),
      file.path(output_dir, "rb_sos_final_export_2022_2025.csv"),
      file.path(output_dir, "wr_sos_final_export_2022_2025.csv"),
      file.path(output_dir, "te_sos_final_export_2022_2025.csv"),
      file.path(output_dir, "k_sos_final_export_2022_2025.csv"),
      file.path(output_dir, "dst_sos_final_export_2022_2025.csv")
    ),
    board_metrics_path = c(
      file.path(output_dir, "qb_sos_production_board_metrics_2022_2025.csv"),
      file.path(output_dir, "rb_sos_production_board_metrics_2022_2025.csv"),
      file.path(output_dir, "wr_sos_production_board_metrics_2022_2025.csv"),
      file.path(output_dir, "te_sos_production_board_metrics_2022_2025.csv"),
      file.path(output_dir, "k_sos_production_board_metrics_2022_2025.csv"),
      file.path(output_dir, "dst_sos_production_board_metrics_2022_2025.csv")
    ),
    tuning_summary_path = c(
      file.path(output_dir, "qb_sos_weight_tuning_summary_2023_2025.csv"),
      file.path(output_dir, "rb_sos_weight_tuning_summary_2023_2025.csv"),
      file.path(output_dir, "wr_sos_weight_tuning_summary_2023_2025.csv"),
      file.path(output_dir, "te_sos_weight_tuning_summary_2023_2025.csv"),
      file.path(output_dir, "k_sos_weight_tuning_summary_2023_2025.csv"),
      file.path(output_dir, "dst_sos_weight_tuning_summary_2023_2025.csv")
    ),
    stringsAsFactors = FALSE
  )
  
  out$final_export_exists <- file.exists(out$final_export_path)
  out$board_metrics_exists <- file.exists(out$board_metrics_path)
  out$tuning_summary_exists <- file.exists(out$tuning_summary_path)
  
  if (write_output) {
    utils::write.csv(
      out,
      file.path(output_dir, "core_sos_lock_summary_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

build_core_sos_output_manifest <- function(write_output = FALSE, output_dir = model_paths$sos_output_dir) {
  out <- data.frame(
    position = c(
      "QB", "QB", "QB",
      "RB", "RB", "RB",
      "WR", "WR", "WR",
      "TE", "TE", "TE",
      "K", "K", "K",
      "DST", "DST", "DST"
    ),
    artifact = c(
      "final_export", "production_board_metrics", "weight_tuning_summary",
      "final_export", "production_board_metrics", "weight_tuning_summary",
      "final_export", "production_board_metrics", "weight_tuning_summary",
      "final_export", "production_board_metrics", "weight_tuning_summary",
      "final_export", "production_board_metrics", "weight_tuning_summary",
      "final_export", "production_board_metrics", "weight_tuning_summary"
    ),
    output_path = c(
      file.path(output_dir, "qb_sos_final_export_2022_2025.csv"),
      file.path(output_dir, "qb_sos_production_board_metrics_2022_2025.csv"),
      file.path(output_dir, "qb_sos_weight_tuning_summary_2023_2025.csv"),
      file.path(output_dir, "rb_sos_final_export_2022_2025.csv"),
      file.path(output_dir, "rb_sos_production_board_metrics_2022_2025.csv"),
      file.path(output_dir, "rb_sos_weight_tuning_summary_2023_2025.csv"),
      file.path(output_dir, "wr_sos_final_export_2022_2025.csv"),
      file.path(output_dir, "wr_sos_production_board_metrics_2022_2025.csv"),
      file.path(output_dir, "wr_sos_weight_tuning_summary_2023_2025.csv"),
      file.path(output_dir, "te_sos_final_export_2022_2025.csv"),
      file.path(output_dir, "te_sos_production_board_metrics_2022_2025.csv"),
      file.path(output_dir, "te_sos_weight_tuning_summary_2023_2025.csv"),
      file.path(output_dir, "k_sos_final_export_2022_2025.csv"),
      file.path(output_dir, "k_sos_production_board_metrics_2022_2025.csv"),
      file.path(output_dir, "k_sos_weight_tuning_summary_2023_2025.csv"),
      file.path(output_dir, "dst_sos_final_export_2022_2025.csv"),
      file.path(output_dir, "dst_sos_production_board_metrics_2022_2025.csv"),
      file.path(output_dir, "dst_sos_weight_tuning_summary_2023_2025.csv")
    ),
    stringsAsFactors = FALSE
  )
  
  out$exists <- file.exists(out$output_path)
  
  if (write_output) {
    utils::write.csv(
      out,
      file.path(output_dir, "core_sos_output_manifest_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  out
}

message("Season-over-season model script loaded.")
message("Available builders: build_qb_sos_inputs(), build_rb_sos_inputs(), build_wr_sos_inputs(), build_te_sos_inputs(), build_k_sos_inputs(), build_dst_clean_weekly_master()")
message("QB runners: run_qb_sos_pipeline(), run_qb_sos_full_pipeline()")
message("RB runners: run_rb_sos_pipeline(), run_rb_sos_training_step(), run_rb_sos_full_pipeline()")
message("WR runners: run_wr_sos_pipeline(), run_wr_sos_training_step(), run_wr_sos_full_pipeline()")
message("TE runners: run_te_sos_pipeline(), run_te_sos_training_step(), run_te_sos_full_pipeline()")
message("K runners: run_k_sos_pipeline(), run_k_sos_training_step(), run_k_sos_full_pipeline()")
message("DST runner: run_dst_sos_full_pipeline()")
message("Core SOS helpers: build_core_sos_lock_summary(), build_core_sos_output_manifest()")
message("QB SOS objects are auto-created when getOption('sos.autorun_qb', TRUE) is TRUE.")
message("TE SOS objects available after run_te_sos_full_pipeline(): te_sos_target_table, te_sos_train, te_sos_baseline, te_sos_weighted, te_sos_compare, te_sos_hybrid, te_sos_all_compare, te_sos_anchor, te_sos_features, te_sos_board, te_sos_tuning, te_sos_final_export")

# -----------------------------------------------------------------------------
# DST season-over-season model
# -----------------------------------------------------------------------------
# DST is a team unit.  The defensive team is the modeling key; TM is the
# opponent and Player is retained only as the display name.

dst_sos_pick_num <- function(df, choices, default = NA_real_) {
  out <- rep(NA_real_, nrow(df))
  for (nm in choices[choices %in% names(df)]) {
    candidate <- suppressWarnings(as.numeric(df[[nm]]))
    out <- dplyr::coalesce(out, candidate)
  }
  out[is.na(out)] <- default
  out
}

dst_sos_pick_chr <- function(df, choices, default = NA_character_) {
  out <- rep(default, nrow(df))
  for (nm in choices[choices %in% names(df)]) {
    candidate <- trimws(as.character(df[[nm]]))
    candidate[candidate %in% c("", "NA", "NaN")] <- NA_character_
    out <- dplyr::coalesce(out, candidate)
  }
  out
}

dst_sos_normalize_team <- function(x) {
  x <- toupper(trimws(as.character(x)))
  dplyr::recode(
    x,
    LA = "LAR",
    CLV = "CLE",
    HST = "HOU",
    BLT = "BAL",
    ARZ = "ARI",
    JAC = "JAX",
    SD = "LAC",
    OAK = "LV",
    STL = "LAR",
    .default = x
  )
}

dst_sos_score_rank <- function(x, higher_is_better = TRUE) {
  x <- suppressWarnings(as.numeric(x))
  if (!higher_is_better) x <- -x
  out <- rep(50, length(x))
  ok <- is.finite(x)
  if (sum(ok) > 1) {
    out[ok] <- 100 * (rank(x[ok], ties.method = "average") - 1) / (sum(ok) - 1)
  } else if (sum(ok) == 1) {
    out[ok] <- 50
  }
  out[!is.finite(x)] <- NA_real_
  out
}

dst_sos_safe_cor <- function(x, y) {
  ok <- is.finite(x) & is.finite(y)
  if (sum(ok) < 3 || length(unique(x[ok])) < 2 || length(unique(y[ok])) < 2) {
    return(NA_real_)
  }
  suppressWarnings(stats::cor(x[ok], y[ok], method = "spearman"))
}

build_dst_clean_weekly_master <- function(write_output = FALSE, output_dir = model_paths$foundation_output_dir) {
  load_model_core_packages()
  
  raw <- load_all_positions_hybrid() |>
    dplyr::filter(as.character(.data$POS) == "DST")
  
  out <- data.frame(
    season = as.integer(dst_sos_pick_num(raw, c("SEA", "season"))),
    week = as.integer(dst_sos_pick_num(raw, c("WK", "week"))),
    game_number = dst_sos_pick_num(raw, c("G", "game_number")),
    player = dst_sos_pick_chr(raw, c("Player", "player_name", "Name")),
    player_key = tolower(gsub("[^a-z0-9]+", " ", dst_sos_pick_chr(raw, c("Player", "player_name", "Name")))) ,
    team = dst_sos_normalize_team(dst_sos_pick_chr(raw, c("TM_DEF", "defense_team", "team"))),
    opponent = dst_sos_normalize_team(dst_sos_pick_chr(raw, c("TM", "opponent_team", "opponent"))),
    position = "DST",
    dst_fantasy_points = dst_sos_pick_num(raw, c("DST_ftpts", "DST_Fantasy_Target", "fantasyPts")),
    sacks = dst_sos_pick_num(raw, c("SACK_def_team", "SACK_def", "sacks", "SACK"), 0),
    interceptions = dst_sos_pick_num(raw, c("INT_def_team", "INT_def", "interceptions", "INT"), 0),
    fumbles = dst_sos_pick_num(raw, c("FUM_def_team", "FUM_def", "fumbles", "FUM"), 0),
    safeties = dst_sos_pick_num(raw, c("safety_def_team", "safety_def", "safeties", "SAF"), 0),
    defensive_tds = dst_sos_pick_num(raw, c("Def_TDs_team", "Def_TDs", "TD_def"), 0),
    kicking_tds = dst_sos_pick_num(raw, c("K_TDs_team", "K_TDs"), 0),
    punting_tds = dst_sos_pick_num(raw, c("P_TDs_team", "P_TDs"), 0),
    points_allowed = dst_sos_pick_num(raw, c(
      "PTs_allw_team", "PTs_allw", "avg_PTs_allw", "avg_total_PTs_allw",
      "avg_DST_Proj_PtsAllowed", "DST_Proj_PtsAllowed", "points_allowed"
    )),
    defensive_plays = dst_sos_pick_num(raw, c("total_plys_def_team", "total_plys_def", "total_def")),
    opponent_sacks_allowed = dst_sos_pick_num(raw, c("SACK_off", "sack_allw_off", "sack_allw_pass_off"), 0),
    opponent_interceptions = dst_sos_pick_num(raw, c("INT_off", "interceptions_off"), 0),
    opponent_fumbles_lost = dst_sos_pick_num(raw, c("fumble_lost_pass_off", "fumble_lost_rush_off", "FUM_off"), 0),
    opponent_points_scored = dst_sos_pick_num(raw, c("Pts_scr", "points_scored", "total_points_off")),
    opponent_total_line = dst_sos_pick_num(raw, c("G_total_off", "total_line_off", "total_off")),
    opponent_spread = dst_sos_pick_num(raw, c("spread_line_off", "spread_line")),
    game_day = dst_sos_pick_chr(raw, c("gameday_off", "gameday")),
    game_time = dst_sos_pick_chr(raw, c("gametime_off", "gametime")),
    stringsAsFactors = FALSE
  ) |>
    dplyr::mutate(
      season = as.integer(season),
      week = as.integer(week),
      points_allowed = dplyr::coalesce(points_allowed, opponent_points_scored),
      games_played = 1L,
      turnovers = dplyr::coalesce(interceptions, 0) + dplyr::coalesce(fumbles, 0),
      big_plays = dplyr::coalesce(sacks, 0) +
        2 * dplyr::coalesce(interceptions, 0) +
        2 * dplyr::coalesce(fumbles, 0) +
        2 * dplyr::coalesce(safeties, 0) +
        6 * (dplyr::coalesce(defensive_tds, 0) + dplyr::coalesce(kicking_tds, 0) + dplyr::coalesce(punting_tds, 0))
    ) |>
    dplyr::filter(season >= 2021, season <= 2025, !is.na(week), week <= 18, !is.na(team))
  
  # These source rows were multiplied by non-unique kicker joins. Values below
  # are reconstructed from the offense scoring inputs used to create PTs_allw.
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
    "defensive_plays", "opponent_sacks_allowed", "opponent_interceptions",
    "opponent_fumbles_lost", "opponent_points_scored"
  )
  conflicting_keys <- out |>
    dplyr::group_by(season, week, team) |>
    dplyr::summarise(
      dplyr::across(
        dplyr::all_of(conflict_columns),
        ~ dplyr::n_distinct(.x[!is.na(.x)])
      ),
      .groups = "drop"
    ) |>
    dplyr::filter(dplyr::if_any(dplyr::all_of(conflict_columns), ~ .x > 1))
  if (nrow(conflicting_keys) > 0) {
    stop(
      "DST source has unresolved conflicting team-week rows; repair the upstream join before modeling.",
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
    stop("DST clean weekly master contains duplicated team-week keys after cleanup.", call. = FALSE)
  }
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(out, file.path(output_dir, "dst_clean_weekly_master_2021_2025_regular.csv"), row.names = FALSE, na = "")
  }
  out
}

build_dst_sos_inputs <- function(dst_weekly = build_dst_clean_weekly_master()) {
  dst_season <- dst_weekly |>
    dplyr::group_by(season, team, player) |>
    dplyr::summarise(
      games = dplyr::n_distinct(week),
      total_fantasy_points = sum(dst_fantasy_points, na.rm = TRUE),
      fantasy_points_per_game = mean(dst_fantasy_points, na.rm = TRUE),
      sacks_per_game = mean(sacks, na.rm = TRUE),
      turnovers_per_game = mean(turnovers, na.rm = TRUE),
      big_plays_per_game = mean(big_plays, na.rm = TRUE),
      points_allowed_per_game = mean(points_allowed, na.rm = TRUE),
      defensive_plays_per_game = mean(defensive_plays, na.rm = TRUE),
      opponent_sacks_allowed_per_game = mean(opponent_sacks_allowed, na.rm = TRUE),
      opponent_turnovers_per_game = mean(opponent_interceptions + opponent_fumbles_lost, na.rm = TRUE),
      opponent_points_scored_per_game = mean(opponent_points_scored, na.rm = TRUE),
      opponent_total_line_mean = mean(opponent_total_line, na.rm = TRUE),
      .groups = "drop"
    ) |>
    dplyr::group_by(team) |>
    dplyr::arrange(season, .by_group = TRUE) |>
    dplyr::mutate(
      source_season = season,
      predict_season = dplyr::lead(season),
      target_next_ppg = dplyr::lead(fantasy_points_per_game),
      target_next_total_points = dplyr::lead(total_fantasy_points),
      prior_ppg = dplyr::lag(fantasy_points_per_game),
      prior_total_points = dplyr::lag(total_fantasy_points)
    ) |>
    dplyr::ungroup()
  
  features <- dst_season |>
    dplyr::group_by(season) |>
    dplyr::mutate(
      dst_sos_anchor_ppg = fantasy_points_per_game,
      dst_sos_anchor_total_points = total_fantasy_points,
      dst_sos_anchor_component_0to100 = rowMeans(cbind(
        dst_sos_score_rank(fantasy_points_per_game),
        dst_sos_score_rank(total_fantasy_points)
      ), na.rm = TRUE),
      production_component_0to100 = rowMeans(cbind(
        dst_sos_score_rank(fantasy_points_per_game),
        dst_sos_score_rank(total_fantasy_points)
      ), na.rm = TRUE),
      playmaking_component_0to100 = rowMeans(cbind(
        dst_sos_score_rank(sacks_per_game),
        dst_sos_score_rank(turnovers_per_game),
        dst_sos_score_rank(big_plays_per_game)
      ), na.rm = TRUE),
      prevention_component_0to100 = dst_sos_score_rank(points_allowed_per_game, higher_is_better = FALSE),
      volume_opportunity_component_0to100 = rowMeans(cbind(
        dst_sos_score_rank(defensive_plays_per_game),
        dst_sos_score_rank(games)
      ), na.rm = TRUE),
      durability_role_confidence_component_0to100 = dst_sos_score_rank(games),
      matchup_context_component_0to100 = dst_sos_score_rank(opponent_total_line_mean, higher_is_better = FALSE),
      opponent_environment_component_0to100 = rowMeans(cbind(
        dst_sos_score_rank(opponent_sacks_allowed_per_game),
        dst_sos_score_rank(opponent_turnovers_per_game),
        dst_sos_score_rank(opponent_points_scored_per_game, higher_is_better = FALSE)
      ), na.rm = TRUE)
    ) |>
    dplyr::ungroup() |>
    dplyr::mutate(
      dplyr::across(
        c(production_component_0to100, playmaking_component_0to100, prevention_component_0to100,
          volume_opportunity_component_0to100, durability_role_confidence_component_0to100,
          matchup_context_component_0to100, opponent_environment_component_0to100),
        ~ ifelse(is.nan(.x), NA_real_, .x)
      )
    )
  
  list(
    weekly = dst_weekly,
    season = dst_season,
    features = features,
    train = dplyr::filter(features, !is.na(predict_season), predict_season >= 2022, predict_season <= 2025),
    target_table = dplyr::select(features, team, player, source_season, predict_season, target_next_ppg, target_next_total_points)
  )
}

dst_sos_weight_candidates <- function() {
  list(
    anchor_matchup_40_20_15_10_10_5 = c(anchor = .40, production = .20, playmaking = .15, prevention = .10, durability = .10, opponent_environment = .05),
    matchup_heavy_35_20_15_10_10_10 = c(anchor = .35, production = .20, playmaking = .15, prevention = .10, durability = .10, opponent_environment = .10),
    balanced_matchup_30_20_20_15_10_5 = c(anchor = .30, production = .20, playmaking = .20, prevention = .15, durability = .10, opponent_environment = .05),
    prevention_matchup_30_20_15_20_5_10 = c(anchor = .30, production = .20, playmaking = .15, prevention = .20, durability = .05, opponent_environment = .10),
    volume_matchup_30_15_20_15_10_10 = c(anchor = .30, production = .15, playmaking = .20, prevention = .15, durability = .10, opponent_environment = .10)
  )
}

dst_sos_apply_weights <- function(df, weights) {
  if ("dst_sos_anchor_component_0to100" %in% names(df)) {
    anchor <- ifelse(is.finite(df$dst_sos_anchor_component_0to100), df$dst_sos_anchor_component_0to100, 50)
  } else {
    anchor <- dst_sos_score_rank(df$dst_sos_anchor_ppg) * .5 + dst_sos_score_rank(df$dst_sos_anchor_total_points) * .5
  }
  production <- ifelse(is.finite(df$production_component_0to100), df$production_component_0to100, 50)
  playmaking <- ifelse(is.finite(df$playmaking_component_0to100), df$playmaking_component_0to100, 50)
  prevention <- ifelse(is.finite(df$prevention_component_0to100), df$prevention_component_0to100, 50)
  durability <- ifelse(is.finite(df$durability_role_confidence_component_0to100), df$durability_role_confidence_component_0to100, 50)
  opponent_environment <- ifelse(is.finite(df$opponent_environment_component_0to100), df$opponent_environment_component_0to100, 50)
  weighted <- weights[["anchor"]] * anchor +
    weights[["production"]] * production +
    weights[["playmaking"]] * playmaking +
    weights[["prevention"]] * prevention +
    weights[["durability"]] * durability +
    weights[["opponent_environment"]] * opponent_environment
  as.numeric(weighted)
}

dst_sos_tier <- function(score) {
  cut(score, breaks = c(-Inf, 20, 40, 60, 80, Inf), labels = c("D", "C", "B", "A-", "A+"), right = FALSE)
}

run_dst_sos_full_pipeline <- function(write_output = TRUE) {
  load_model_core_packages()
  inputs <- build_dst_sos_inputs(build_dst_clean_weekly_master(write_output = write_output))
  candidates <- dst_sos_weight_candidates()
  
  metrics <- do.call(rbind, lapply(names(candidates), function(candidate) {
    score <- dst_sos_apply_weights(inputs$train, candidates[[candidate]])
    data.frame(
      model = candidate,
      predict_season = inputs$train$predict_season,
      target_next_ppg = inputs$train$target_next_ppg,
      target_next_total_points = inputs$train$target_next_total_points,
      score = score,
      stringsAsFactors = FALSE
    ) |>
      dplyr::group_by(predict_season) |>
      dplyr::summarise(
        n = sum(is.finite(score) & is.finite(target_next_ppg)),
        spearman_ppg = dst_sos_safe_cor(score, target_next_ppg),
        spearman_total = dst_sos_safe_cor(score, target_next_total_points),
        .groups = "drop"
      ) |>
      dplyr::mutate(model = candidate, .before = 1)
  }))
  
  tuning_summary <- metrics |>
    dplyr::group_by(model) |>
    dplyr::summarise(
      avg_ppg_spearman = mean(spearman_ppg, na.rm = TRUE),
      min_ppg_spearman = min(spearman_ppg, na.rm = TRUE),
      avg_total_spearman = mean(spearman_total, na.rm = TRUE),
      min_total_spearman = min(spearman_total, na.rm = TRUE),
      combined_score = mean(c(avg_ppg_spearman, avg_total_spearman), na.rm = TRUE),
      .groups = "drop"
    ) |>
    dplyr::arrange(dplyr::desc(combined_score))
  
  production_candidate <- tuning_summary$model[[1]]
  board <- inputs$features
  board$dst_sos_weight_profile <- production_candidate
  board$dst_sos_final_score <- dst_sos_apply_weights(board, candidates[[production_candidate]])
  board <- board |>
    dplyr::mutate(
      dst_sos_tier = dst_sos_tier(dst_sos_final_score),
      dst_sos_rank = dplyr::dense_rank(dplyr::desc(dst_sos_final_score)),
      dst_sos_projected_ppg = dst_sos_anchor_ppg,
      dst_sos_projected_total_points = dst_sos_anchor_total_points
    ) |>
    dplyr::arrange(source_season, dst_sos_rank)
  
  final_export <- board |>
    dplyr::select(
      source_season, predict_season, dst_sos_rank, dst_sos_tier, player, team,
      games, fantasy_points_per_game, total_fantasy_points,
      dst_sos_weight_profile, dst_sos_final_score,
      dst_sos_projected_ppg, dst_sos_projected_total_points,
      dst_sos_anchor_component_0to100,
      production_component_0to100, playmaking_component_0to100,
      prevention_component_0to100, volume_opportunity_component_0to100,
      durability_role_confidence_component_0to100, matchup_context_component_0to100,
      opponent_environment_component_0to100,
      target_next_ppg, target_next_total_points
    )
  
  if (write_output) {
    dir.create(model_paths$sos_output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(final_export, file.path(model_paths$sos_output_dir, "dst_sos_final_export_2022_2025.csv"), row.names = FALSE, na = "")
    utils::write.csv(metrics, file.path(model_paths$sos_output_dir, "dst_sos_production_board_metrics_2022_2025.csv"), row.names = FALSE, na = "")
    utils::write.csv(tuning_summary, file.path(model_paths$sos_output_dir, "dst_sos_weight_tuning_summary_2023_2025.csv"), row.names = FALSE, na = "")
  }
  
  result <- list(
    dst_sos_inputs = inputs,
    dst_sos_target_table = inputs$target_table,
    dst_sos_train = inputs$train,
    dst_sos_features = inputs$features,
    dst_sos_board = board,
    dst_sos_metrics = metrics,
    dst_sos_tuning = list(summary = tuning_summary, production_candidate = production_candidate),
    dst_sos_final_export = final_export
  )
  for (nm in names(result)) assign(nm, result[[nm]], envir = .GlobalEnv)
  result
}

run_dst_sos_holdout_pipeline <- function(test_predict_season = 2025L, write_output = TRUE) {
  load_model_core_packages()
  inputs <- build_dst_sos_inputs(build_dst_clean_weekly_master(write_output = write_output))
  candidates <- dst_sos_weight_candidates()
  
  metric_rows <- do.call(rbind, lapply(names(candidates), function(candidate) {
    score <- dst_sos_apply_weights(inputs$train, candidates[[candidate]])
    data.frame(
      model = candidate,
      predict_season = inputs$train$predict_season,
      target_next_ppg = inputs$train$target_next_ppg,
      target_next_total_points = inputs$train$target_next_total_points,
      score = score,
      stringsAsFactors = FALSE
    ) |>
      dplyr::group_by(predict_season) |>
      dplyr::summarise(
        n = sum(is.finite(score) & is.finite(target_next_ppg)),
        spearman_ppg = dst_sos_safe_cor(score, target_next_ppg),
        spearman_total = dst_sos_safe_cor(score, target_next_total_points),
        .groups = "drop"
      ) |>
      dplyr::mutate(model = candidate, .before = 1)
  }))
  
  training_summary <- metric_rows |>
    dplyr::filter(predict_season < test_predict_season) |>
    dplyr::group_by(model) |>
    dplyr::summarise(
      train_seasons = paste(sort(unique(predict_season)), collapse = ","),
      avg_ppg_spearman = mean(spearman_ppg, na.rm = TRUE),
      min_ppg_spearman = min(spearman_ppg, na.rm = TRUE),
      avg_total_spearman = mean(spearman_total, na.rm = TRUE),
      min_total_spearman = min(spearman_total, na.rm = TRUE),
      combined_score = mean(c(avg_ppg_spearman, avg_total_spearman), na.rm = TRUE),
      .groups = "drop"
    ) |>
    dplyr::arrange(dplyr::desc(combined_score))
  
  production_candidate <- training_summary$model[[1]]
  test_metrics <- metric_rows |>
    dplyr::filter(predict_season == test_predict_season) |>
    dplyr::arrange(dplyr::desc(spearman_total))
  
  holdout_board <- inputs$features |>
    dplyr::filter(predict_season == test_predict_season)
  holdout_board$dst_sos_holdout_weight_profile <- production_candidate
  holdout_board$dst_sos_holdout_score <- dst_sos_apply_weights(
    holdout_board,
    candidates[[production_candidate]]
  )
  holdout_board <- holdout_board |>
    dplyr::mutate(
      dst_sos_holdout_rank = dplyr::dense_rank(dplyr::desc(dst_sos_holdout_score)),
      dst_sos_holdout_tier = dst_sos_tier(dst_sos_holdout_score)
    ) |>
    dplyr::arrange(dst_sos_holdout_rank)
  
  if (write_output) {
    dir.create(model_paths$sos_output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      training_summary,
      file.path(model_paths$sos_output_dir, paste0("dst_sos_holdout_tuning_through_", test_predict_season - 1L, ".csv")),
      row.names = FALSE,
      na = ""
    )
    utils::write.csv(
      test_metrics,
      file.path(model_paths$sos_output_dir, paste0("dst_sos_holdout_test_metrics_", test_predict_season, ".csv")),
      row.names = FALSE,
      na = ""
    )
    utils::write.csv(
      holdout_board,
      file.path(model_paths$sos_output_dir, paste0("dst_sos_holdout_final_export_", test_predict_season, ".csv")),
      row.names = FALSE,
      na = ""
    )
  }
  
  result <- list(
    dst_sos_holdout_inputs = inputs,
    dst_sos_holdout_training_summary = training_summary,
    dst_sos_holdout_test_metrics = test_metrics,
    dst_sos_holdout_production_candidate = production_candidate,
    dst_sos_holdout_final_export = holdout_board
  )
  for (nm in names(result)) assign(nm, result[[nm]], envir = .GlobalEnv)
  result
}

run_dst_sos_walk_forward_pipeline <- function(
    test_predict_seasons = c(2023L, 2024L, 2025L),
    write_output = TRUE
) {
  load_model_core_packages()
  inputs <- build_dst_sos_inputs(build_dst_clean_weekly_master(write_output = write_output))
  candidates <- dst_sos_weight_candidates()
  test_predict_seasons <- sort(unique(as.integer(test_predict_seasons)))
  
  metric_rows <- do.call(rbind, lapply(names(candidates), function(candidate) {
    score <- dst_sos_apply_weights(inputs$train, candidates[[candidate]])
    data.frame(
      model = candidate,
      predict_season = inputs$train$predict_season,
      target_next_ppg = inputs$train$target_next_ppg,
      target_next_total_points = inputs$train$target_next_total_points,
      score = score,
      stringsAsFactors = FALSE
    ) |>
      dplyr::group_by(predict_season) |>
      dplyr::summarise(
        n = sum(is.finite(score) & is.finite(target_next_ppg)),
        spearman_ppg = dst_sos_safe_cor(score, target_next_ppg),
        spearman_total = dst_sos_safe_cor(score, target_next_total_points),
        .groups = "drop"
      ) |>
      dplyr::mutate(model = candidate, .before = 1)
  }))
  
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
  
  for (test_season in test_predict_seasons) {
    training_summary <- metric_rows |>
      dplyr::filter(predict_season < test_season) |>
      dplyr::group_by(model) |>
      dplyr::summarise(
        train_seasons = paste(sort(unique(predict_season)), collapse = ","),
        avg_ppg_spearman = safe_mean(spearman_ppg),
        min_ppg_spearman = safe_min(spearman_ppg),
        avg_total_spearman = safe_mean(spearman_total),
        min_total_spearman = safe_min(spearman_total),
        .groups = "drop"
      ) |>
      dplyr::mutate(
        test_predict_season = test_season,
        combined_score = rowMeans(
          cbind(avg_ppg_spearman, avg_total_spearman),
          na.rm = TRUE
        ),
        .before = 1
      ) |>
      dplyr::arrange(dplyr::desc(combined_score), dplyr::desc(avg_total_spearman))
    
    production_candidate <- training_summary$model[[1]]
    selected_test_metrics <- metric_rows |>
      dplyr::filter(
        predict_season == test_season,
        model == production_candidate
      ) |>
      dplyr::mutate(
        test_predict_season = test_season,
        selected_model = TRUE,
        .before = 1
      )
    
    test_metrics <- metric_rows |>
      dplyr::filter(predict_season == test_season) |>
      dplyr::mutate(
        test_predict_season = test_season,
        selected_model = model == production_candidate,
        selected_profile = production_candidate,
        .before = 1
      )
    
    fold_tuning[[as.character(test_season)]] <- training_summary
    fold_test_metrics[[as.character(test_season)]] <- test_metrics
    fold_summary[[as.character(test_season)]] <- data.frame(
      test_predict_season = test_season,
      train_predict_seasons = training_summary$train_seasons[[1]],
      selected_model = production_candidate,
      test_n = selected_test_metrics$n[[1]],
      test_spearman_ppg = selected_test_metrics$spearman_ppg[[1]],
      test_spearman_total = selected_test_metrics$spearman_total[[1]],
      stringsAsFactors = FALSE
    )
    
    board <- inputs$features |>
      dplyr::filter(predict_season == test_season)
    board$dst_sos_walk_forward_weight_profile <- production_candidate
    board$dst_sos_walk_forward_score <- dst_sos_apply_weights(
      board,
      candidates[[production_candidate]]
    )
    board <- board |>
      dplyr::group_by(predict_season) |>
      dplyr::mutate(
        dst_sos_walk_forward_rank = dplyr::dense_rank(dplyr::desc(dst_sos_walk_forward_score)),
        dst_sos_walk_forward_tier = dst_sos_tier(dst_sos_walk_forward_score)
      ) |>
      dplyr::ungroup() |>
      dplyr::arrange(predict_season, dst_sos_walk_forward_rank)
    fold_boards[[as.character(test_season)]] <- board
  }
  
  walk_forward_tuning <- dplyr::bind_rows(fold_tuning)
  walk_forward_summary <- dplyr::bind_rows(fold_summary)
  walk_forward_test_metrics <- dplyr::bind_rows(fold_test_metrics)
  walk_forward_final_export <- dplyr::bind_rows(fold_boards)
  
  if (write_output) {
    dir.create(model_paths$sos_output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      walk_forward_tuning,
      file.path(model_paths$sos_output_dir, "dst_sos_walk_forward_tuning_2023_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    utils::write.csv(
      walk_forward_summary,
      file.path(model_paths$sos_output_dir, "dst_sos_walk_forward_summary_2023_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    utils::write.csv(
      walk_forward_test_metrics,
      file.path(model_paths$sos_output_dir, "dst_sos_walk_forward_test_metrics_2023_2025.csv"),
      row.names = FALSE,
      na = ""
    )
    utils::write.csv(
      walk_forward_final_export,
      file.path(model_paths$sos_output_dir, "dst_sos_walk_forward_final_export_2023_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  result <- list(
    dst_sos_walk_forward_inputs = inputs,
    dst_sos_walk_forward_tuning = walk_forward_tuning,
    dst_sos_walk_forward_summary = walk_forward_summary,
    dst_sos_walk_forward_test_metrics = walk_forward_test_metrics,
    dst_sos_walk_forward_final_export = walk_forward_final_export
  )
  for (nm in names(result)) assign(nm, result[[nm]], envir = .GlobalEnv)
  result
}

# Strict 2025 holdout across every SOS position. Profiles are selected from
# earlier predict seasons only; the 2025 rows are never used for selection.
run_core_sos_walk_forward_2025 <- function(
    test_predict_season = 2025L,
    validation_seasons = NULL,
    write_output = TRUE
) {
  load_model_core_packages()
  
  test_predict_season <- as.integer(test_predict_season[[1]])
  if (is.null(validation_seasons)) {
    validation_seasons <- seq.int(2023L, test_predict_season - 1L)
  }
  validation_seasons <- sort(unique(as.integer(validation_seasons)))
  
  position_specs <- list(
    QB = list(
      feature_object = "qb_sos_features",
      feature_file = "qb_sos_feature_overlay_2022_2025.csv",
      full_runner = run_qb_sos_full_pipeline,
      full_result = "qb_sos_features",
      tuning = run_qb_sos_weight_tuning,
      candidates = build_qb_sos_weight_candidates,
      board = build_qb_sos_production_board_from_weights,
      metrics = build_qb_sos_board_metrics
    ),
    RB = list(
      feature_object = "rb_sos_features",
      feature_file = "rb_sos_feature_overlay_2022_2025.csv",
      full_runner = run_rb_sos_full_pipeline,
      full_result = "rb_sos_features",
      tuning = run_rb_sos_weight_tuning,
      candidates = build_rb_sos_weight_candidates,
      board = build_rb_sos_production_board_from_weights,
      metrics = build_rb_sos_board_metrics
    ),
    WR = list(
      feature_object = "wr_sos_features",
      feature_file = "wr_sos_feature_overlay_2022_2025.csv",
      full_runner = run_wr_sos_full_pipeline,
      full_result = "wr_sos_features",
      tuning = run_wr_sos_weight_tuning,
      candidates = build_wr_sos_weight_candidates,
      board = build_wr_sos_production_board_from_weights,
      metrics = build_wr_sos_board_metrics
    ),
    TE = list(
      feature_object = "te_sos_features",
      feature_file = "te_sos_feature_overlay_2022_2025.csv",
      full_runner = run_te_sos_full_pipeline,
      full_result = "te_sos_features",
      tuning = run_te_sos_weight_tuning,
      candidates = build_te_sos_weight_candidates,
      board = build_te_sos_production_board_from_weights,
      metrics = build_te_sos_board_metrics
    ),
    K = list(
      feature_object = "k_sos_features",
      feature_file = "k_sos_feature_overlay_2022_2025.csv",
      full_runner = run_k_sos_full_pipeline,
      full_result = "k_sos_features",
      tuning = run_k_sos_weight_tuning,
      candidates = build_k_sos_weight_candidates,
      board = build_k_sos_production_board_from_weights,
      metrics = build_k_sos_board_metrics
    )
  )
  
  tuning_rows <- list()
  test_rows <- list()
  selected_boards <- list()
  
  for (position in names(position_specs)) {
    spec <- position_specs[[position]]
    if (exists(spec$feature_object, envir = .GlobalEnv, inherits = FALSE)) {
      features <- get(spec$feature_object, envir = .GlobalEnv, inherits = FALSE)
    } else if (file.exists(file.path(model_paths$sos_output_dir, spec$feature_file))) {
      features <- read_csv_flexible(
        file.path(model_paths$sos_output_dir, spec$feature_file)
      )
    } else {
      full_run <- spec$full_runner(write_output = FALSE)
      features <- full_run[[spec$full_result]]
    }
    tuning <- do.call(
      spec$tuning,
      list(features, validation_seasons = validation_seasons, write_output = FALSE)
    )
    selected_model <- tuning$summary$candidate[[1]]
    weights_row <- spec$candidates() |>
      dplyr::filter(.data$candidate == .env$selected_model) |>
      dplyr::slice(1)
    
    board <- spec$board(features, weights_row)
    metrics <- spec$metrics(board) |>
      dplyr::filter(.data$predict_season == .env$test_predict_season) |>
      dplyr::mutate(
        position = .env$position,
        selected_model = .env$selected_model,
        train_predict_seasons = paste(validation_seasons, collapse = ","),
        .before = 1
      )
    
    tuning_rows[[position]] <- tuning$summary |>
      dplyr::mutate(
        position = .env$position,
        test_predict_season = .env$test_predict_season,
        train_predict_seasons = paste(validation_seasons, collapse = ","),
        selected_model = .env$selected_model,
        .before = 1
      )
    test_rows[[position]] <- metrics
    board_season_col <- if ("predict_season" %in% names(board)) {
      "predict_season"
    } else if ("target_next_season" %in% names(board)) {
      "target_next_season"
    } else {
      NA_character_
    }
    selected_board <- if (is.na(board_season_col)) {
      board[0, , drop = FALSE]
    } else {
      board[
        suppressWarnings(as.integer(board[[board_season_col]])) == test_predict_season,
        ,
        drop = FALSE
      ]
    }
    selected_boards[[position]] <- selected_board |>
      dplyr::mutate(
        position = .env$position,
        selected_model = .env$selected_model,
        .before = 1
      )
  }
  
  dst_holdout <- run_dst_sos_holdout_pipeline(
    test_predict_season = test_predict_season,
    write_output = write_output
  )
  dst_selected_model <- dst_holdout$dst_sos_holdout_production_candidate
  dst_test_metrics <- dst_holdout$dst_sos_holdout_test_metrics |>
    dplyr::filter(.data$model == .env$dst_selected_model) |>
    dplyr::transmute(
      position = "DST",
      selected_model = .env$dst_selected_model,
      predict_season = .data$predict_season,
      n = .data$n,
      target_next_ppg = .data$spearman_ppg,
      target_next_total_points = .data$spearman_total,
      train_predict_seasons = paste(validation_seasons, collapse = ",")
    ) |>
    tidyr::pivot_longer(
      cols = c("target_next_ppg", "target_next_total_points"),
      names_to = "target",
      values_to = "spearman"
    )
  dst_tuning <- dst_holdout$dst_sos_holdout_training_summary |>
    dplyr::mutate(
      position = "DST",
      test_predict_season = .env$test_predict_season,
      selected_model = .env$dst_selected_model,
      .before = 1
    )
  
  tuning <- dplyr::bind_rows(c(tuning_rows, list(dst_tuning))) |>
    dplyr::arrange(.data$position, dplyr::desc(.data$combined_score))
  test_metrics <- dplyr::bind_rows(c(test_rows, list(dst_test_metrics))) |>
    dplyr::arrange(.data$position, .data$target)
  selected_export <- dplyr::bind_rows(c(
    selected_boards,
    list(
      dst_holdout$dst_sos_holdout_final_export |>
        dplyr::mutate(
          position = "DST",
          selected_model = .env$dst_selected_model,
          .before = 1
        )
    )
  ))
  
  ppg_metrics <- test_metrics |>
    dplyr::filter(.data$target == "target_next_ppg") |>
    dplyr::transmute(
      position,
      selected_model,
      test_predict_season = .data$predict_season,
      train_predict_seasons,
      n_ppg = .data$n,
      spearman_ppg = .data$spearman
    )
  total_metrics <- test_metrics |>
    dplyr::filter(.data$target == "target_next_total_points") |>
    dplyr::transmute(
      position,
      n_total = .data$n,
      spearman_total = .data$spearman
    )
  summary <- ppg_metrics |>
    dplyr::left_join(total_metrics, by = "position") |>
    dplyr::arrange(.data$position)
  
  if (write_output) {
    dir.create(model_paths$sos_output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      tuning,
      file.path(model_paths$sos_output_dir, "core_sos_walk_forward_2025_tuning.csv"),
      row.names = FALSE,
      na = ""
    )
    utils::write.csv(
      test_metrics,
      file.path(model_paths$sos_output_dir, "core_sos_walk_forward_2025_test_metrics.csv"),
      row.names = FALSE,
      na = ""
    )
    utils::write.csv(
      summary,
      file.path(model_paths$sos_output_dir, "core_sos_walk_forward_2025_summary.csv"),
      row.names = FALSE,
      na = ""
    )
    utils::write.csv(
      selected_export,
      file.path(model_paths$sos_output_dir, "core_sos_walk_forward_2025_selected_export.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  
  result <- list(
    tuning = tuning,
    test_metrics = test_metrics,
    summary = summary,
    selected_export = selected_export,
    test_predict_season = test_predict_season,
    validation_seasons = validation_seasons
  )
  assign("core_sos_walk_forward_2025", result, envir = .GlobalEnv)
  result
}

get_dst_sos_production_candidate <- function() {
  path <- file.path(model_paths$sos_output_dir, "dst_sos_weight_tuning_summary_2023_2025.csv")
  if (file.exists(path)) utils::read.csv(path, stringsAsFactors = FALSE)$model[[1]] else NA_character_
}

message("DST SOS runner: run_dst_sos_full_pipeline()")
message("DST SOS holdout runner: run_dst_sos_holdout_pipeline()")
message("DST SOS walk-forward runner: run_dst_sos_walk_forward_pipeline()")

# -----------------------------------------------------------------------------
# SOS tier-finish probabilities
# -----------------------------------------------------------------------------

sos_probability_output_dir <- function() {
  file.path(model_paths$model_root_dir, "outputs", "probabilities")
}

sos_prob_collapse_player_seasons <- function(df) {
  required <- c("season", "player", "current_team", "next_team", "rank", "final_score")
  missing <- setdiff(required, names(df))
  if (length(missing) > 0) {
    stop("SOS probability input is missing columns: ", paste(missing, collapse = ", "), call. = FALSE)
  }
  
  if (!"actual_next_ppg" %in% names(df)) df$actual_next_ppg <- NA_real_
  if (!"actual_next_total_points" %in% names(df)) df$actual_next_total_points <- NA_real_
  if (!"games" %in% names(df)) df$games <- NA_real_
  
  x <- df |>
    dplyr::mutate(
      season = as.integer(.data$season),
      .player_key = tolower(trimws(as.character(.data$player))),
      .current_team = trimws(dplyr::coalesce(as.character(.data$current_team), "")),
      .next_team = trimws(dplyr::coalesce(as.character(.data$next_team), "")),
      .rank_num = sos_prob_num(.data$rank),
      .final_score_num = sos_prob_num(.data$final_score),
      .games_num = sos_prob_num(.data$games),
      actual_next_ppg = sos_prob_num(.data$actual_next_ppg),
      actual_next_total_points = sos_prob_num(.data$actual_next_total_points)
    )
  
  target_segments <- x |>
    dplyr::filter(is.finite(.data$actual_next_ppg) | is.finite(.data$actual_next_total_points)) |>
    dplyr::distinct(
      .data$season, .data$.player_key, .data$.next_team,
      .data$actual_next_ppg, .data$actual_next_total_points
    ) |>
    dplyr::group_by(.data$season, .data$.player_key, .data$.next_team) |>
    dplyr::summarise(
      segment_total = if (any(is.finite(.data$actual_next_total_points))) {
        max(.data$actual_next_total_points[is.finite(.data$actual_next_total_points)])
      } else {
        NA_real_
      },
      segment_ppg = if (any(is.finite(.data$actual_next_ppg))) {
        max(.data$actual_next_ppg[is.finite(.data$actual_next_ppg)])
      } else {
        NA_real_
      },
      .groups = "drop"
    ) |>
    dplyr::mutate(
      segment_games = dplyr::if_else(
        is.finite(.data$segment_total) & is.finite(.data$segment_ppg) & .data$segment_ppg != 0,
        .data$segment_total / .data$segment_ppg,
        NA_real_
      )
    )
  
  target_totals <- target_segments |>
    dplyr::group_by(.data$season, .data$.player_key) |>
    dplyr::summarise(
      actual_next_total_points = if (any(is.finite(.data$segment_total))) {
        sum(.data$segment_total[is.finite(.data$segment_total)])
      } else {
        NA_real_
      },
      inferred_next_games = if (any(is.finite(.data$segment_games) & .data$segment_games > 0)) {
        sum(.data$segment_games[is.finite(.data$segment_games) & .data$segment_games > 0])
      } else {
        NA_real_
      },
      fallback_next_ppg = if (any(is.finite(.data$segment_ppg))) {
        max(.data$segment_ppg[is.finite(.data$segment_ppg)])
      } else {
        NA_real_
      },
      target_teams = paste(sort(unique(.data$.next_team[nzchar(.data$.next_team)])), collapse = "/"),
      .groups = "drop"
    ) |>
    dplyr::mutate(
      actual_next_ppg = dplyr::if_else(
        is.finite(.data$actual_next_total_points) & is.finite(.data$inferred_next_games) & .data$inferred_next_games > 0,
        .data$actual_next_total_points / .data$inferred_next_games,
        .data$fallback_next_ppg
      )
    )
  
  team_labels <- x |>
    dplyr::group_by(.data$season, .data$.player_key) |>
    dplyr::summarise(
      source_teams = paste(sort(unique(.data$.current_team[nzchar(.data$.current_team)])), collapse = "/"),
      listed_target_teams = paste(sort(unique(.data$.next_team[nzchar(.data$.next_team)])), collapse = "/"),
      .groups = "drop"
    )
  
  representative <- x |>
    dplyr::arrange(
      .data$season, .data$.player_key,
      dplyr::desc(is.finite(.data$.final_score_num)),
      dplyr::desc(.data$.final_score_num),
      dplyr::desc(.data$.games_num),
      .data$.rank_num
    ) |>
    dplyr::group_by(.data$season, .data$.player_key) |>
    dplyr::slice_head(n = 1L) |>
    dplyr::ungroup() |>
    dplyr::select(
      -dplyr::any_of(c(
        "actual_next_ppg", "actual_next_total_points", ".current_team", ".next_team",
        ".rank_num", ".final_score_num", ".games_num"
      ))
    )
  
  representative |>
    dplyr::left_join(team_labels, by = c("season", ".player_key"), relationship = "one-to-one") |>
    dplyr::left_join(target_totals, by = c("season", ".player_key"), relationship = "one-to-one") |>
    dplyr::mutate(
      current_team = dplyr::if_else(nzchar(.data$source_teams), .data$source_teams, as.character(.data$current_team)),
      next_team = dplyr::case_when(
        nzchar(dplyr::coalesce(.data$target_teams, "")) ~ .data$target_teams,
        nzchar(.data$listed_target_teams) ~ .data$listed_target_teams,
        TRUE ~ as.character(.data$next_team)
      )
    ) |>
    dplyr::select(-dplyr::any_of(c(
      ".player_key", "source_teams", "listed_target_teams", "target_teams",
      "inferred_next_games", "fallback_next_ppg"
    ))) |>
    dplyr::group_by(.data$season) |>
    dplyr::mutate(rank = rank(-sos_prob_num(.data$final_score), ties.method = "first", na.last = "keep")) |>
    dplyr::ungroup()
}

sos_prob_num <- function(x) suppressWarnings(as.numeric(x))
sos_prob_clamp <- function(x, lower = 0.01, upper = 0.99) pmin(pmax(x, lower), upper)

sos_prob_rank_score <- function(rank, group_n) {
  rank <- sos_prob_num(rank)
  group_n <- sos_prob_num(group_n)
  out <- rep(NA_real_, length(rank))
  keep <- is.finite(rank) & is.finite(group_n) & group_n > 1
  out[keep] <- 100 * (group_n[keep] - rank[keep]) / (group_n[keep] - 1)
  out[is.finite(rank) & is.finite(group_n) & group_n == 1] <- 50
  out
}

sos_prob_z <- function(x) {
  x <- sos_prob_num(x)
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

sos_prob_targets <- function(position) {
  switch(
    toupper(position),
    QB = c(top3 = 3L, top6 = 6L, top12 = 12L, top18 = 18L),
    RB = c(top6 = 6L, top12 = 12L, top24 = 24L, top36 = 36L),
    WR = c(top6 = 6L, top12 = 12L, top24 = 24L, top36 = 36L, top48 = 48L),
    TE = c(top3 = 3L, top6 = 6L, top12 = 12L, top18 = 18L),
    c(top12 = 12L)
  )
}

sos_prob_fit_predict <- function(df, target_col) {
  target <- suppressWarnings(as.integer(df[[target_col]]))
  train <- df[!is.na(target), , drop = FALSE]
  target_train <- target[!is.na(target)]
  if (length(target_train) < 25 || length(unique(target_train)) < 2) {
    base_rate <- mean(target_train, na.rm = TRUE)
    if (!is.finite(base_rate)) base_rate <- 0
    return(sos_prob_clamp(rep(base_rate, nrow(df))))
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
    return(sos_prob_clamp(rep(base_rate, nrow(df))))
  }
  pred <- try(suppressWarnings(stats::predict(fit, newdata = df, type = "response")), silent = TRUE)
  if (inherits(pred, "try-error")) pred <- rep(mean(target_train, na.rm = TRUE), nrow(df))
  sos_prob_clamp(as.numeric(pred))
}

build_position_sos_tier_probabilities <- function(position, write_output = TRUE) {
  load_model_core_packages()
  position <- toupper(position)
  input_path <- file.path(model_paths$sos_output_dir, paste0(tolower(position), "_sos_final_export_2022_2025.csv"))
  if (!file.exists(input_path)) stop("Missing SOS final export: ", input_path, call. = FALSE)
  
  df <- utils::read.csv(input_path, stringsAsFactors = FALSE, check.names = FALSE) |>
    sos_prob_collapse_player_seasons()
  thresholds <- sos_prob_targets(position)
  calibration_profile <- if (position == "QB") {
    build_qb_sos_probability_calibration_profile(write_output = write_output)
  } else {
    NULL
  }
  board_score <- if ("board_score" %in% names(df)) sos_prob_num(df$board_score) else rep(NA_real_, nrow(df))
  
  out <- df |>
    dplyr::mutate(
      position = position,
      season = as.integer(.data$season),
      rank = sos_prob_num(.data$rank),
      final_score = sos_prob_num(.data$final_score),
      preseason_omfg = sos_prob_num(.data$preseason_omfg),
      board_score = board_score,
      actual_next_ppg = sos_prob_num(.data$actual_next_ppg),
      actual_next_total_points = sos_prob_num(.data$actual_next_total_points)
    ) |>
    dplyr::group_by(.data$season) |>
    dplyr::mutate(
      field_size = dplyr::n(),
      actual_ppg_rank = dplyr::if_else(is.finite(.data$actual_next_ppg), rank(-.data$actual_next_ppg, ties.method = "min", na.last = "keep"), NA_real_),
      actual_total_rank = dplyr::if_else(is.finite(.data$actual_next_total_points), rank(-.data$actual_next_total_points, ties.method = "min", na.last = "keep"), NA_real_)
    ) |>
    dplyr::ungroup() |>
    dplyr::mutate(
      rank_score_0to100 = sos_prob_rank_score(.data$rank, .data$field_size),
      model_score_z = sos_prob_z(.data$final_score),
      rank_score_z = sos_prob_z(.data$rank_score_0to100),
      omfg_score_z = sos_prob_z(.data$preseason_omfg),
      board_score_z = sos_prob_z(.data$board_score)
    )
  
  for (target_name in names(thresholds)) {
    cutoff <- thresholds[[target_name]]
    ppg_outcome_col <- paste0("actual_ppg_", target_name)
    total_outcome_col <- paste0("actual_total_", target_name)
    ppg_prob_col <- paste0("prob_ppg_", target_name)
    total_prob_col <- paste0("prob_total_", target_name)
    out[[ppg_outcome_col]] <- ifelse(is.finite(out$actual_ppg_rank), as.integer(out$actual_ppg_rank <= cutoff), NA_integer_)
    out[[total_outcome_col]] <- ifelse(is.finite(out$actual_total_rank), as.integer(out$actual_total_rank <= cutoff), NA_integer_)
    raw_ppg_probability <- sos_prob_fit_predict(out, ppg_outcome_col)
    raw_total_probability <- sos_prob_fit_predict(out, total_outcome_col)
    if (position == "QB") {
      out[[paste0("raw_", ppg_prob_col)]] <- raw_ppg_probability
      out[[paste0("raw_", total_prob_col)]] <- raw_total_probability
      out[[ppg_prob_col]] <- sos_prob_apply_oof_calibration(
        raw_ppg_probability,
        paste0("ppg_", target_name),
        calibration_profile
      )
      out[[total_prob_col]] <- sos_prob_apply_oof_calibration(
        raw_total_probability,
        paste0("total_", target_name),
        calibration_profile
      )
    } else {
      out[[ppg_prob_col]] <- raw_ppg_probability
      out[[total_prob_col]] <- raw_total_probability
    }
  }
  
  probability_cols <- grep("^prob_(ppg|total)_", names(out), value = TRUE)
  raw_probability_cols <- grep("^raw_prob_(ppg|total)_", names(out), value = TRUE)
  keep_cols <- unique(c(
    "position", "season", "rank", "tier", "player", "current_team", "next_team",
    "weight_profile", "final_score", "preseason_omfg", "board_score",
    raw_probability_cols, probability_cols,
    "actual_ppg_rank", "actual_total_rank", "actual_next_ppg", "actual_next_total_points"
  ))
  keep_cols <- keep_cols[keep_cols %in% names(out)]
  export <- out |>
    dplyr::select(dplyr::all_of(keep_cols)) |>
    dplyr::arrange(.data$season, .data$rank)
  
  summary_rows <- list()
  idx <- 1L
  for (target_name in names(thresholds)) {
    cutoff <- thresholds[[target_name]]
    for (scope in c("ppg", "total")) {
      outcome_col <- paste0("actual_", scope, "_", target_name)
      prob_col <- paste0("prob_", scope, "_", target_name)
      keep <- !is.na(out[[outcome_col]]) & is.finite(out[[prob_col]])
      summary_rows[[idx]] <- data.frame(
        position = position,
        model_family = "SOS",
        target = paste0(scope, "_", target_name),
        cutoff = cutoff,
        rows = sum(keep),
        actual_rate = mean(out[[outcome_col]][keep], na.rm = TRUE),
        avg_predicted_probability = mean(out[[prob_col]][keep], na.rm = TRUE),
        calibration_adjustment_applied = if (position == "QB") {
          profile_row <- calibration_profile[calibration_profile$target == paste0(scope, "_", target_name), , drop = FALSE]
          nrow(profile_row) == 1 && isTRUE(profile_row$adjustment_enabled[1])
        } else {
          FALSE
        },
        stringsAsFactors = FALSE
      )
      idx <- idx + 1L
    }
  }
  summary <- dplyr::bind_rows(summary_rows)
  
  if (write_output) {
    output_dir <- sos_probability_output_dir()
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(export, file.path(output_dir, paste0(tolower(position), "_sos_tier_probability_export_2022_2025.csv")), row.names = FALSE, na = "")
    utils::write.csv(summary, file.path(output_dir, paste0(tolower(position), "_sos_tier_probability_summary_2022_2025.csv")), row.names = FALSE, na = "")
  }
  list(export = export, summary = summary)
}

build_core_sos_tier_probabilities <- function(positions = c("QB", "RB", "WR", "TE"), write_output = TRUE) {
  load_model_core_packages()
  results <- lapply(positions, build_position_sos_tier_probabilities, write_output = write_output)
  names(results) <- positions
  summary <- dplyr::bind_rows(lapply(results, `[[`, "summary"))
  if (write_output) {
    output_dir <- sos_probability_output_dir()
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(summary, file.path(output_dir, "core_sos_tier_probability_summary_2022_2025.csv"), row.names = FALSE, na = "")
  }
  result <- list(results = results, summary = summary)
  assign("core_sos_tier_probabilities", result, envir = .GlobalEnv)
  result
}

build_core_sos_probability_lift_audit <- function(
    positions = c("QB", "RB", "WR", "TE"),
    write_output = TRUE
) {
  load_model_core_packages()
  output_dir <- sos_probability_output_dir()
  audit_rows <- list()
  idx <- 1L
  
  for (position in toupper(positions)) {
    input_path <- file.path(output_dir, paste0(tolower(position), "_sos_tier_probability_export_2022_2025.csv"))
    if (!file.exists(input_path)) {
      build_position_sos_tier_probabilities(position, write_output = TRUE)
    }
    df <- utils::read.csv(input_path, stringsAsFactors = FALSE, check.names = FALSE)
    probability_cols <- grep("^prob_(ppg|total)_top[0-9]+$", names(df), value = TRUE)
    
    for (prob_col in probability_cols) {
      scope <- if (grepl("^prob_ppg_", prob_col)) "ppg" else "total"
      cutoff <- suppressWarnings(as.integer(sub(".*_top", "", prob_col)))
      rank_col <- if (scope == "ppg") "actual_ppg_rank" else "actual_total_rank"
      if (!rank_col %in% names(df) || !is.finite(cutoff)) next
      
      tmp <- data.frame(
        probability = sos_prob_num(df[[prob_col]]),
        actual_rank = sos_prob_num(df[[rank_col]])
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
          model_family = "SOS",
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
      file.path(output_dir, "core_sos_tier_probability_lift_audit_2022_2025.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  assign("core_sos_tier_probability_lift_audit", out, envir = .GlobalEnv)
  out
}

sos_prob_walk_forward_fit <- function(train_df, test_df, outcome_col) {
  predictor_cols <- c("final_score", "rank_score_0to100", "preseason_omfg", "board_score")
  target <- suppressWarnings(as.integer(train_df[[outcome_col]]))
  keep <- !is.na(target)
  train_base_rate <- mean(target[keep], na.rm = TRUE)
  if (!is.finite(train_base_rate)) train_base_rate <- 0
  
  if (sum(keep) < 25 || length(unique(target[keep])) < 2) {
    return(list(
      probability = sos_prob_clamp(rep(train_base_rate, nrow(test_df))),
      fit_method = "training_base_rate",
      n_train = sum(keep),
      train_base_rate = train_base_rate
    ))
  }
  
  train_model <- data.frame(target_outcome = target[keep])
  test_model <- data.frame(row_id = seq_len(nrow(test_df)))
  z_cols <- character()
  
  for (predictor_col in predictor_cols) {
    train_values <- sos_prob_num(train_df[[predictor_col]])
    test_values <- sos_prob_num(test_df[[predictor_col]])
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
      probability = sos_prob_clamp(rep(train_base_rate, nrow(test_df))),
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
    probability = sos_prob_clamp(as.numeric(probability)),
    fit_method = fit_method,
    n_train = sum(keep),
    train_base_rate = train_base_rate
  )
}

sos_prob_auc <- function(actual, probability) {
  keep <- !is.na(actual) & is.finite(probability)
  actual <- as.integer(actual[keep])
  probability <- probability[keep]
  n_pos <- sum(actual == 1L)
  n_neg <- sum(actual == 0L)
  if (n_pos == 0 || n_neg == 0) return(NA_real_)
  ranks <- rank(probability, ties.method = "average")
  (sum(ranks[actual == 1L]) - n_pos * (n_pos + 1) / 2) / (n_pos * n_neg)
}

sos_prob_calibration_stats <- function(actual, probability) {
  keep <- !is.na(actual) & is.finite(probability)
  actual <- as.integer(actual[keep])
  probability <- sos_prob_clamp(probability[keep], 0.001, 0.999)
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

run_position_sos_probability_walk_forward <- function(
    position,
    test_seasons = NULL,
    write_output = TRUE
) {
  load_model_core_packages()
  position_label <- toupper(position)
  input_path <- file.path(
    model_paths$sos_output_dir,
    paste0(tolower(position_label), "_sos_final_export_2022_2025.csv")
  )
  if (!file.exists(input_path)) stop("Missing SOS final export: ", input_path, call. = FALSE)
  
  df <- utils::read.csv(input_path, stringsAsFactors = FALSE, check.names = FALSE) |>
    sos_prob_collapse_player_seasons()
  thresholds <- sos_prob_targets(position_label)
  board_score <- if ("board_score" %in% names(df)) sos_prob_num(df$board_score) else rep(NA_real_, nrow(df))
  frame <- df |>
    dplyr::mutate(
      season = as.integer(.data$season),
      rank = sos_prob_num(.data$rank),
      final_score = sos_prob_num(.data$final_score),
      preseason_omfg = sos_prob_num(.data$preseason_omfg),
      board_score = board_score,
      actual_next_ppg = sos_prob_num(.data$actual_next_ppg),
      actual_next_total_points = sos_prob_num(.data$actual_next_total_points)
    ) |>
    dplyr::group_by(.data$season) |>
    dplyr::mutate(
      field_size = dplyr::n(),
      actual_ppg_rank = dplyr::if_else(
        is.finite(.data$actual_next_ppg),
        rank(-.data$actual_next_ppg, ties.method = "min", na.last = "keep"),
        NA_real_
      ),
      actual_total_rank = dplyr::if_else(
        is.finite(.data$actual_next_total_points),
        rank(-.data$actual_next_total_points, ties.method = "min", na.last = "keep"),
        NA_real_
      )
    ) |>
    dplyr::ungroup() |>
    dplyr::mutate(rank_score_0to100 = sos_prob_rank_score(.data$rank, .data$field_size))
  
  for (target_name in names(thresholds)) {
    cutoff <- thresholds[[target_name]]
    frame[[paste0("actual_ppg_", target_name)]] <- ifelse(
      is.finite(frame$actual_ppg_rank), as.integer(frame$actual_ppg_rank <= cutoff), NA_integer_
    )
    frame[[paste0("actual_total_", target_name)]] <- ifelse(
      is.finite(frame$actual_total_rank), as.integer(frame$actual_total_rank <= cutoff), NA_integer_
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
      for (scope in c("ppg", "total")) {
        outcome_col <- paste0("actual_", scope, "_", target_name)
        rank_col <- paste0("actual_", scope, "_rank")
        fitted <- sos_prob_walk_forward_fit(train, test, outcome_col)
        prediction_rows[[idx]] <- test |>
          dplyr::transmute(
            position = position_label,
            model_family = "SOS",
            test_season = test_season,
            train_seasons = train_seasons_label,
            target = paste0(scope, "_", target_name),
            cutoff = cutoff,
            player = .data$player,
            current_team = .data$current_team,
            next_team = .data$next_team,
            model_rank = .data$rank,
            final_score = .data$final_score,
            preseason_omfg = .data$preseason_omfg,
            probability = fitted$probability,
            actual_hit = .data[[outcome_col]],
            actual_rank = .data[[rank_col]],
            fit_method = fitted$fit_method,
            n_train = fitted$n_train,
            train_base_rate = fitted$train_base_rate
          )
        idx <- idx + 1L
      }
    }
  }
  
  predictions <- dplyr::bind_rows(prediction_rows) |>
    dplyr::filter(!is.na(.data$actual_hit), is.finite(.data$probability)) |>
    dplyr::arrange(.data$test_season, .data$target, dplyr::desc(.data$probability))
  if (nrow(predictions) == 0) stop("No SOS walk-forward probability rows were produced for ", position_label, call. = FALSE)
  
  metric_groups <- split(
    predictions,
    interaction(predictions$test_season, predictions$target, drop = TRUE)
  )
  metrics <- dplyr::bind_rows(lapply(metric_groups, function(x) {
    x <- x[order(x$probability), , drop = FALSE]
    x$probability_decile <- dplyr::ntile(x$probability, 10)
    top <- x[x$probability_decile == 10L, , drop = FALSE]
    bottom <- x[x$probability_decile == 1L, , drop = FALSE]
    calibration <- sos_prob_calibration_stats(x$actual_hit, x$probability)
    base_rate <- mean(x$actual_hit)
    data.frame(
      position = position_label,
      model_family = "SOS",
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
      auc = sos_prob_auc(x$actual_hit, x$probability),
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
      model_family = "SOS",
      lift_vs_base = .data$actual_rate / .data$base_rate,
      .before = 1
    )
  
  list(predictions = predictions, metrics = metrics, deciles = deciles)
}

run_core_sos_probability_walk_forward <- function(
    positions = c("QB", "RB", "WR", "TE"),
    test_seasons = NULL,
    write_output = TRUE
) {
  load_model_core_packages()
  positions <- toupper(positions)
  results <- lapply(
    positions,
    run_position_sos_probability_walk_forward,
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
    calibration <- sos_prob_calibration_stats(x$actual_hit, x$probability)
    base_rate <- mean(x$actual_hit)
    data.frame(
      position = x$position[1],
      model_family = "SOS",
      target = x$target[1],
      cutoff = x$cutoff[1],
      test_seasons = paste(sort(unique(x$test_season)), collapse = ","),
      rows = nrow(x),
      actual_rate = base_rate,
      avg_probability = mean(x$probability),
      absolute_calibration_error = abs(mean(x$probability) - base_rate),
      brier_score = mean((x$probability - x$actual_hit)^2),
      log_loss = mean(-(x$actual_hit * log(x$probability) + (1 - x$actual_hit) * log(1 - x$probability))),
      auc = sos_prob_auc(x$actual_hit, x$probability),
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
    output_dir <- sos_probability_output_dir()
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    season_min <- min(predictions$test_season)
    season_max <- max(predictions$test_season)
    suffix <- paste0(season_min, "_", season_max)
    utils::write.csv(predictions, file.path(output_dir, paste0("core_sos_probability_walk_forward_predictions_", suffix, ".csv")), row.names = FALSE, na = "")
    utils::write.csv(metrics, file.path(output_dir, paste0("core_sos_probability_walk_forward_metrics_", suffix, ".csv")), row.names = FALSE, na = "")
    utils::write.csv(deciles, file.path(output_dir, paste0("core_sos_probability_walk_forward_deciles_", suffix, ".csv")), row.names = FALSE, na = "")
    utils::write.csv(summary, file.path(output_dir, paste0("core_sos_probability_walk_forward_summary_", suffix, ".csv")), row.names = FALSE, na = "")
  }
  result <- list(results = results, predictions = predictions, metrics = metrics, deciles = deciles, summary = summary)
  assign("core_sos_probability_walk_forward", result, envir = .GlobalEnv)
  result
}

build_qb_sos_probability_calibration_profile <- function(
    blend_weight = 0.50,
    min_relative_gain = 0.001,
    write_output = TRUE
) {
  blend_weight <- max(0, min(1, as.numeric(blend_weight)))
  min_relative_gain <- max(0, as.numeric(min_relative_gain))
  walk_forward <- run_position_sos_probability_walk_forward(
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
        train_logit <- stats::qlogis(sos_prob_clamp(train$probability, 0.001, 0.999))
        fit <- try(
          suppressWarnings(stats::glm(train$actual_hit ~ train_logit, family = stats::binomial())),
          silent = TRUE
        )
        if (inherits(fit, "try-error") || length(unique(train$actual_hit)) < 2) {
          calibrated_probability <- test$probability
        } else {
          test_logit <- stats::qlogis(sos_prob_clamp(test$probability, 0.001, 0.999))
          calibrated_probability <- stats::plogis(
            unname(stats::coef(fit)[1]) + unname(stats::coef(fit)[2]) * test_logit
          )
        }
        adjusted_probability <- sos_prob_clamp(
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
    
    full_logit <- stats::qlogis(sos_prob_clamp(target_rows$probability, 0.001, 0.999))
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
      model_family = "SOS",
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
    output_dir <- sos_probability_output_dir()
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      profile,
      file.path(output_dir, "qb_sos_probability_calibration_profile.csv"),
      row.names = FALSE,
      na = ""
    )
  }
  assign("qb_sos_probability_calibration_profile", profile, envir = .GlobalEnv)
  profile
}

sos_prob_apply_oof_calibration <- function(probability, target_label, profile) {
  probability <- sos_prob_clamp(sos_prob_num(probability))
  if (is.null(profile) || nrow(profile) == 0) return(probability)
  profile_row <- profile[profile$target == target_label, , drop = FALSE]
  if (nrow(profile_row) != 1 || !isTRUE(profile_row$adjustment_enabled[1])) return(probability)
  calibrated <- stats::plogis(
    profile_row$calibration_intercept[1] +
      profile_row$calibration_slope[1] * stats::qlogis(sos_prob_clamp(probability, 0.001, 0.999))
  )
  sos_prob_clamp(
    (1 - profile_row$blend_weight[1]) * probability +
      profile_row$blend_weight[1] * calibrated
  )
}

sos_prob_enforce_nested <- function(df, probability_cols) {
  probability_cols <- probability_cols[probability_cols %in% names(df)]
  if (length(probability_cols) < 2L || nrow(df) == 0L) return(df)
  probability_matrix <- as.matrix(df[probability_cols])
  adjusted <- t(apply(probability_matrix, 1L, function(values) {
    values <- sos_prob_clamp(as.numeric(values))
    if (any(!is.finite(values))) return(values)
    sos_prob_clamp(stats::isoreg(seq_along(values), values)$yf)
  }))
  colnames(adjusted) <- probability_cols
  df[probability_cols] <- adjusted
  df
}

# -----------------------------------------------------------------------------
# Future-season SOS production inference
# -----------------------------------------------------------------------------

sos_production_output_dir <- function() {
  file.path(model_paths$model_root_dir, "outputs", "production")
}

sos_build_future_anchor_predictions <- function(position, prediction_season) {
  load_model_core_packages()
  position <- toupper(position)
  prediction_season <- as.integer(prediction_season[[1]])
  source_season <- prediction_season - 1L
  
  season_table <- switch(
    position,
    QB = build_qb_player_season_combined_table(write_output = FALSE),
    RB = build_rb_player_season_combined_table(write_output = FALSE),
    WR = build_wr_player_season_combined_table(write_output = FALSE),
    TE = build_te_player_season_combined_table(write_output = FALSE),
    K = build_k_player_season_combined_table(write_output = FALSE),
    stop("Future SOS anchors are not configured for position ", position, call. = FALSE)
  )
  
  required_cols <- c("season", "player_key", "player", "team", "games", "fantasy_points", "fantasy_points_per_game")
  missing_cols <- setdiff(required_cols, names(season_table))
  if (length(missing_cols) > 0L) {
    stop(position, " season table is missing production columns: ", paste(missing_cols, collapse = ", "), call. = FALSE)
  }
  
  current <- season_table |>
    dplyr::filter(.data$season == .env$source_season)
  if (nrow(current) == 0L) {
    stop("No ", position, " rows were found for source season ", source_season, call. = FALSE)
  }
  
  prior <- season_table |>
    dplyr::filter(.data$season == .env$source_season - 1L) |>
    dplyr::transmute(
      player_key,
      prior_ppg = .data$fantasy_points_per_game,
      prior_total_points = .data$fantasy_points
    )
  
  out <- current |>
    dplyr::left_join(prior, by = "player_key", relationship = "many-to-one") |>
    dplyr::mutate(
      weighted_two_year_ppg = dplyr::case_when(
        is.finite(.data$fantasy_points_per_game) & is.finite(.data$prior_ppg) ~
          0.65 * .data$fantasy_points_per_game + 0.35 * .data$prior_ppg,
        is.finite(.data$fantasy_points_per_game) ~ .data$fantasy_points_per_game,
        TRUE ~ .data$prior_ppg
      ),
      weighted_two_year_total_points = dplyr::case_when(
        is.finite(.data$fantasy_points) & is.finite(.data$prior_total_points) ~
          0.65 * .data$fantasy_points + 0.35 * .data$prior_total_points,
        is.finite(.data$fantasy_points) ~ .data$fantasy_points,
        TRUE ~ .data$prior_total_points
      )
    ) |>
    dplyr::transmute(
      predict_season = .env$prediction_season,
      source_season = .env$source_season,
      player_key,
      player,
      current_team = .data$team,
      next_team = .data$team,
      qualified_4_games_current = as.integer(.data$games >= 4),
      qualified_8_games_current = as.integer(.data$games >= 8),
      qualified_4_games_next = NA_integer_,
      qualified_8_games_next = NA_integer_,
      target_next_ppg = NA_real_,
      target_next_total_points = NA_real_,
      future_anchor_ppg = .data$weighted_two_year_ppg,
      future_anchor_total_points = .data$weighted_two_year_total_points
    )
  
  duplicate_keys <- out |>
    dplyr::count(.data$predict_season, .data$player_key, name = "dup_n") |>
    dplyr::filter(.data$dup_n > 1L)
  if (nrow(duplicate_keys) > 0L) {
    stop(position, " future SOS anchors contain duplicate player-season keys.", call. = FALSE)
  }
  
  prefix <- tolower(position)
  out[[paste0(prefix, "_sos_anchor_ppg")]] <- out$future_anchor_ppg
  out[[paste0(prefix, "_sos_anchor_total_points")]] <- out$future_anchor_total_points
  out[[paste0(prefix, "_sos_anchor_model_ppg")]] <- "weighted_two_year_production"
  out[[paste0(prefix, "_sos_anchor_model_total_points")]] <- "weighted_two_year_production"
  out |>
    dplyr::select(-dplyr::all_of(c("future_anchor_ppg", "future_anchor_total_points")))
}

build_position_sos_production_probabilities <- function(
    position,
    production_export,
    prediction_season,
    write_output = TRUE,
    output_dir = sos_production_output_dir()
) {
  load_model_core_packages()
  position <- toupper(position)
  if (!position %in% c("QB", "RB", "WR", "TE")) return(NULL)
  
  historical_path <- file.path(
    model_paths$sos_output_dir,
    paste0(tolower(position), "_sos_final_export_2022_2025.csv")
  )
  if (!file.exists(historical_path)) {
    stop("Missing historical SOS probability input: ", historical_path, call. = FALSE)
  }
  
  historical <- utils::read.csv(
    historical_path,
    stringsAsFactors = FALSE,
    check.names = FALSE
  ) |>
    sos_prob_collapse_player_seasons()
  future <- production_export
  future$actual_next_ppg <- NA_real_
  future$actual_next_total_points <- NA_real_
  frame <- dplyr::bind_rows(historical, future)
  thresholds <- sos_prob_targets(position)
  calibration_profile <- NULL
  if (position == "QB") {
    profile_path <- file.path(sos_probability_output_dir(), "qb_sos_probability_calibration_profile.csv")
    calibration_profile <- if (file.exists(profile_path)) {
      utils::read.csv(profile_path, stringsAsFactors = FALSE, check.names = FALSE)
    } else {
      build_qb_sos_probability_calibration_profile(write_output = write_output)
    }
  }
  
  board_score <- if ("board_score" %in% names(frame)) sos_prob_num(frame$board_score) else rep(NA_real_, nrow(frame))
  scored <- frame |>
    dplyr::mutate(
      season = as.integer(.data$season),
      rank = sos_prob_num(.data$rank),
      final_score = sos_prob_num(.data$final_score),
      preseason_omfg = sos_prob_num(.data$preseason_omfg),
      board_score = board_score,
      actual_next_ppg = sos_prob_num(.data$actual_next_ppg),
      actual_next_total_points = sos_prob_num(.data$actual_next_total_points)
    ) |>
    dplyr::group_by(.data$season) |>
    dplyr::mutate(
      field_size = dplyr::n(),
      actual_ppg_rank = dplyr::if_else(
        is.finite(.data$actual_next_ppg),
        rank(-.data$actual_next_ppg, ties.method = "min", na.last = "keep"),
        NA_real_
      ),
      actual_total_rank = dplyr::if_else(
        is.finite(.data$actual_next_total_points),
        rank(-.data$actual_next_total_points, ties.method = "min", na.last = "keep"),
        NA_real_
      )
    ) |>
    dplyr::ungroup() |>
    dplyr::mutate(
      rank_score_0to100 = sos_prob_rank_score(.data$rank, .data$field_size),
      model_score_z = sos_prob_z(.data$final_score),
      rank_score_z = sos_prob_z(.data$rank_score_0to100),
      omfg_score_z = sos_prob_z(.data$preseason_omfg),
      board_score_z = sos_prob_z(.data$board_score)
    )
  
  for (target_name in names(thresholds)) {
    cutoff <- thresholds[[target_name]]
    ppg_outcome_col <- paste0("actual_ppg_", target_name)
    total_outcome_col <- paste0("actual_total_", target_name)
    ppg_prob_col <- paste0("prob_ppg_", target_name)
    total_prob_col <- paste0("prob_total_", target_name)
    scored[[ppg_outcome_col]] <- ifelse(
      is.finite(scored$actual_ppg_rank),
      as.integer(scored$actual_ppg_rank <= cutoff),
      NA_integer_
    )
    scored[[total_outcome_col]] <- ifelse(
      is.finite(scored$actual_total_rank),
      as.integer(scored$actual_total_rank <= cutoff),
      NA_integer_
    )
    raw_ppg <- sos_prob_fit_predict(scored, ppg_outcome_col)
    raw_total <- sos_prob_fit_predict(scored, total_outcome_col)
    scored[[ppg_prob_col]] <- if (position == "QB") {
      sos_prob_apply_oof_calibration(raw_ppg, paste0("ppg_", target_name), calibration_profile)
    } else {
      raw_ppg
    }
    scored[[total_prob_col]] <- if (position == "QB") {
      sos_prob_apply_oof_calibration(raw_total, paste0("total_", target_name), calibration_profile)
    } else {
      raw_total
    }
  }
  
  ordered_targets <- names(thresholds)[order(as.integer(thresholds))]
  scored <- sos_prob_enforce_nested(
    scored,
    paste0("prob_ppg_", ordered_targets)
  )
  scored <- sos_prob_enforce_nested(
    scored,
    paste0("prob_total_", ordered_targets)
  )
  
  probability_cols <- grep("^prob_(ppg|total)_top[0-9]+$", names(scored), value = TRUE)
  out <- scored |>
    dplyr::filter(.data$season == as.integer(.env$prediction_season)) |>
    dplyr::select(
      "season", "rank", "player", "current_team",
      dplyr::all_of(probability_cols)
    ) |>
    dplyr::arrange(.data$rank)
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, paste0(tolower(position), "_sos_production_probabilities_", prediction_season, ".csv")),
      row.names = FALSE,
      na = ""
    )
  }
  out
}

run_position_sos_production <- function(
    position,
    prediction_season = 2026L,
    write_output = TRUE,
    output_dir = sos_production_output_dir()
) {
  load_model_core_packages()
  position <- toupper(position)
  prediction_season <- as.integer(prediction_season[[1]])
  source_season <- prediction_season - 1L
  
  if (position == "DST") {
    inputs <- build_dst_sos_inputs(build_dst_clean_weekly_master(write_output = FALSE))
    candidate <- get_dst_sos_production_candidate()
    future <- inputs$features |>
      dplyr::filter(.data$source_season == .env$source_season) |>
      dplyr::mutate(
        predict_season = .env$prediction_season,
        target_next_ppg = NA_real_,
        target_next_total_points = NA_real_,
        dst_sos_weight_profile = .env$candidate,
        dst_sos_final_score = dst_sos_apply_weights(
          dplyr::pick(dplyr::everything()),
          dst_sos_weight_candidates()[[candidate]]
        ),
        dst_sos_tier = dst_sos_tier(.data$dst_sos_final_score),
        dst_sos_rank = dplyr::dense_rank(dplyr::desc(.data$dst_sos_final_score)),
        dst_sos_projected_ppg = .data$dst_sos_anchor_ppg,
        dst_sos_projected_total_points = .data$dst_sos_anchor_total_points
      ) |>
      dplyr::arrange(.data$dst_sos_rank)
    if (nrow(future) == 0L) stop("No DST production rows were built for ", prediction_season, call. = FALSE)
    export <- future |>
      dplyr::transmute(
        position = "DST",
        production_mode = "future_season_rank_only",
        source_season,
        prediction_season = predict_season,
        season = predict_season,
        rank = dst_sos_rank,
        tier = as.character(dst_sos_tier),
        player,
        current_team = team,
        next_team = team,
        games,
        weight_profile = dst_sos_weight_profile,
        final_score = dst_sos_final_score,
        anchor_ppg = dst_sos_projected_ppg,
        anchor_total_points = dst_sos_projected_total_points,
        preseason_omfg = NA_real_,
        board_score = dst_sos_anchor_component_0to100,
        production = production_component_0to100,
        playmaking = playmaking_component_0to100,
        prevention = prevention_component_0to100,
        volume_opportunity = volume_opportunity_component_0to100,
        durability_role_confidence = durability_role_confidence_component_0to100,
        matchup_context = matchup_context_component_0to100,
        opponent_environment = opponent_environment_component_0to100
      )
  } else {
    anchor <- list(predictions = sos_build_future_anchor_predictions(position, prediction_season))
    features <- switch(
      position,
      QB = run_qb_sos_feature_overlay_step(anchor, write_output = FALSE, max_source_season = source_season),
      RB = run_rb_sos_feature_overlay_step(anchor, write_output = FALSE, max_source_season = source_season),
      WR = run_wr_sos_feature_overlay_step(anchor, write_output = FALSE, max_source_season = source_season),
      TE = run_te_sos_feature_overlay_step(anchor, write_output = FALSE, max_source_season = source_season),
      K = run_k_sos_feature_overlay_step(anchor, write_output = FALSE, max_predict_season = prediction_season),
      stop("Unsupported SOS production position: ", position, call. = FALSE)
    )
    future_features <- features$feature_table |>
      dplyr::filter(.data$target_next_season == .env$prediction_season) |>
      dplyr::mutate(
        target_next_team = dplyr::coalesce(.data$target_next_team, .data$team),
        target_next_ppg = NA_real_,
        target_next_total_points = NA_real_
      )
    if (nrow(future_features) == 0L) {
      stop("No ", position, " production rows were built for ", prediction_season, call. = FALSE)
    }
    features$feature_table <- future_features
    board <- switch(
      position,
      QB = run_qb_sos_production_board_step(features, write_output = FALSE),
      RB = run_rb_sos_production_board_step(features, write_output = FALSE),
      WR = run_wr_sos_production_board_step(features, write_output = FALSE),
      TE = run_te_sos_production_board_step(features, write_output = FALSE),
      K = run_k_sos_production_board_step(features, write_output = FALSE)
    )
    export <- switch(
      position,
      QB = build_qb_sos_final_export(board, write_output = FALSE),
      RB = build_rb_sos_final_export(board, write_output = FALSE),
      WR = build_wr_sos_final_export(board, write_output = FALSE),
      TE = build_te_sos_final_export(board, write_output = FALSE),
      K = build_k_sos_final_export(board, write_output = FALSE)
    ) |>
      dplyr::mutate(
        position = .env$position,
        production_mode = ifelse(.env$position %in% c("QB", "RB", "WR", "TE"), "future_season_with_probabilities", "future_season_rank_only"),
        source_season = .env$source_season,
        prediction_season = .data$season,
        .before = 1
      )
    
    if (position %in% c("QB", "RB", "WR", "TE")) {
      probabilities <- build_position_sos_production_probabilities(
        position,
        export,
        prediction_season,
        write_output = write_output,
        output_dir = output_dir
      )
      export <- export |>
        dplyr::left_join(
          probabilities,
          by = c("season", "rank", "player", "current_team"),
          relationship = "one-to-one"
        )
    }
  }
  
  duplicate_keys <- export |>
    dplyr::count(.data$prediction_season, .data$player, name = "dup_n") |>
    dplyr::filter(.data$dup_n > 1L)
  if (nrow(duplicate_keys) > 0L) {
    stop(position, " production export contains duplicate player-season keys.", call. = FALSE)
  }
  if (any(!is.finite(sos_prob_num(export$rank)))) {
    stop(position, " production export contains missing ranks.", call. = FALSE)
  }
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      export,
      file.path(output_dir, paste0(tolower(position), "_sos_production_", prediction_season, ".csv")),
      row.names = FALSE,
      na = ""
    )
  }
  export
}

build_core_sos_production_audit <- function(master, prediction_season) {
  load_model_core_packages()
  positions <- unique(as.character(master$position))
  rows <- lapply(positions, function(position) {
    x <- master[master$position == position, , drop = FALSE]
    probability_cols <- grep("^prob_(ppg|total)_top[0-9]+$", names(x), value = TRUE)
    active_probability_cols <- probability_cols[vapply(
      probability_cols,
      function(col) any(is.finite(sos_prob_num(x[[col]]))),
      logical(1)
    )]
    probability_missing <- if (length(active_probability_cols) > 0L) {
      sum(!is.finite(as.matrix(x[active_probability_cols])))
    } else {
      0L
    }
    probability_out_of_bounds <- if (length(active_probability_cols) > 0L) {
      values <- as.matrix(x[active_probability_cols])
      sum(values < 0 | values > 1, na.rm = TRUE)
    } else {
      0L
    }
    nested_violations <- 0L
    for (scope in c("ppg", "total")) {
      scope_cols <- grep(paste0("^prob_", scope, "_top[0-9]+$"), active_probability_cols, value = TRUE)
      if (length(scope_cols) > 1L) {
        cutoffs <- suppressWarnings(as.integer(sub(".*_top", "", scope_cols)))
        scope_cols <- scope_cols[order(cutoffs)]
        nested_violations <- nested_violations + sum(apply(
          as.matrix(x[scope_cols]),
          1L,
          function(values) any(diff(values) < -1e-12)
        ))
      }
    }
    duplicate_keys <- sum(duplicated(x[c("position", "prediction_season", "player")]))
    missing_ranks <- sum(!is.finite(sos_prob_num(x$rank)))
    season_mismatch <- sum(
      suppressWarnings(as.integer(x$prediction_season)) != as.integer(prediction_season) |
        suppressWarnings(as.integer(x$source_season)) != as.integer(prediction_season) - 1L,
      na.rm = TRUE
    )
    status <- if (
      nrow(x) > 0L && duplicate_keys == 0L && missing_ranks == 0L &&
      season_mismatch == 0L && probability_missing == 0L &&
      probability_out_of_bounds == 0L && nested_violations == 0L
    ) "PASS" else "FAIL"
    data.frame(
      position = position,
      prediction_season = as.integer(prediction_season),
      rows = nrow(x),
      probability_columns = length(active_probability_cols),
      duplicate_player_season_keys = duplicate_keys,
      missing_ranks = missing_ranks,
      season_mismatch_rows = season_mismatch,
      missing_probabilities = probability_missing,
      out_of_bounds_probabilities = probability_out_of_bounds,
      nested_probability_violations = nested_violations,
      status = status,
      stringsAsFactors = FALSE
    )
  })
  dplyr::bind_rows(rows) |>
    dplyr::arrange(factor(.data$position, levels = c("QB", "RB", "WR", "TE", "K", "DST")))
}

run_core_sos_production <- function(
    prediction_season = 2026L,
    positions = c("QB", "RB", "WR", "TE", "K", "DST"),
    write_output = TRUE,
    output_dir = sos_production_output_dir(),
    reuse_existing = FALSE
) {
  load_model_core_packages()
  prediction_season <- as.integer(prediction_season[[1]])
  positions <- toupper(positions)
  results <- lapply(positions, function(position) {
    existing_path <- file.path(
      output_dir,
      paste0(tolower(position), "_sos_production_", prediction_season, ".csv")
    )
    if (isTRUE(reuse_existing) && file.exists(existing_path)) {
      return(utils::read.csv(existing_path, stringsAsFactors = FALSE, check.names = FALSE))
    }
    run_position_sos_production(
      position,
      prediction_season = prediction_season,
      write_output = write_output,
      output_dir = output_dir
    )
  })
  names(results) <- positions
  
  probability_cols <- unique(unlist(lapply(results, function(x) {
    grep("^prob_(ppg|total)_top[0-9]+$", names(x), value = TRUE)
  })))
  master <- dplyr::bind_rows(lapply(results, function(x) {
    required <- c(
      "position", "production_mode", "source_season", "prediction_season",
      "rank", "tier", "player", "current_team", "next_team", "games",
      "weight_profile", "final_score", "anchor_ppg", "anchor_total_points",
      "preseason_omfg", "board_score", probability_cols
    )
    missing <- setdiff(required, names(x))
    for (col in missing) x[[col]] <- NA
    x |>
      dplyr::select(dplyr::all_of(required))
  })) |>
    dplyr::arrange(factor(.data$position, levels = positions), .data$rank)
  
  audit <- build_core_sos_production_audit(master, prediction_season)
  if (any(audit$status != "PASS")) {
    failed_positions <- paste(audit$position[audit$status != "PASS"], collapse = ", ")
    stop("SOS production audit failed for: ", failed_positions, call. = FALSE)
  }
  
  manifest <- data.frame(
    position = c(positions, "CORE", "CORE"),
    artifact = c(
      rep("position_production", length(positions)),
      "master_production",
      "production_audit"
    ),
    output_path = c(
      file.path(output_dir, paste0(tolower(positions), "_sos_production_", prediction_season, ".csv")),
      file.path(output_dir, paste0("core_sos_production_", prediction_season, ".csv")),
      file.path(output_dir, paste0("core_sos_production_audit_", prediction_season, ".csv"))
    ),
    stringsAsFactors = FALSE
  )
  
  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      master,
      file.path(output_dir, paste0("core_sos_production_", prediction_season, ".csv")),
      row.names = FALSE,
      na = ""
    )
    utils::write.csv(
      audit,
      file.path(output_dir, paste0("core_sos_production_audit_", prediction_season, ".csv")),
      row.names = FALSE,
      na = ""
    )
    manifest$exists <- file.exists(manifest$output_path)
    utils::write.csv(
      manifest,
      file.path(output_dir, paste0("core_sos_production_manifest_", prediction_season, ".csv")),
      row.names = FALSE,
      na = ""
    )
  } else {
    manifest$exists <- NA
  }
  
  result <- list(
    prediction_season = prediction_season,
    positions = results,
    master = master,
    audit = audit,
    manifest = manifest
  )
  assign("core_sos_production", result, envir = .GlobalEnv)
  result
}

message("SOS probability helper: build_core_sos_tier_probabilities()")
message("SOS probability audit: build_core_sos_probability_lift_audit()")
message("SOS probability walk-forward: run_core_sos_probability_walk_forward()")
message("SOS QB probability calibration: build_qb_sos_probability_calibration_profile()")
message("SOS production runner: run_core_sos_production()")
