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
  player_vec <- trimws(gsub("\\s+", " ", player_vec))
  dplyr::recode(
    player_vec,
    "drew ogletree" = "andrew ogletree",
    "andy borregales" = "andres borregales",
    "joshua palmer" = "josh palmer",
    "kenny gainwell" = "kenneth gainwell",
    "mitch tinsley" = "mitchell tinsley",
    "scotty miller" = "scott miller",
    .default = player_vec
  )
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
    dplyr::group_by(.data$position) |>
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

sos_rank_guardrail_score <- function(scores, target_ranks, offset = 0) {
  ordered_scores <- sort(sos_prob_num(scores), decreasing = TRUE, na.last = NA)
  vapply(
    target_ranks,
    function(target_rank) {
      if (!is.finite(target_rank) || length(ordered_scores) == 0L) return(NA_real_)
      index <- pmin(length(ordered_scores), pmax(1L, as.integer(target_rank)))
      ordered_scores[[index]] + offset
    },
    numeric(1)
  )
}

sos_exact_rank_score <- function(scores, target_ranks) {
  scores <- sos_prob_num(scores)
  target_ranks <- sos_prob_num(target_ranks)
  out <- rep(NA_real_, length(scores))
  for (i in which(is.finite(target_ranks))) {
    other_scores <- sort(scores[-i][is.finite(scores[-i])], decreasing = TRUE)
    target <- pmin(length(other_scores) + 1L, pmax(1L, as.integer(target_ranks[[i]])))
    upper <- if (target <= 1L) Inf else other_scores[[target - 1L]]
    lower <- if (target > length(other_scores)) -Inf else other_scores[[target]]
    out[[i]] <- if (is.infinite(upper)) {
      lower + 1e-6
    } else if (is.infinite(lower)) {
      upper - 1e-6
    } else {
      (upper + lower) / 2
    }
  }
  out
}

sos_enforce_exact_rank_targets <- function(df, rank_col, target_col) {
  if (!all(c("position", "player_key", rank_col, target_col) %in% names(df))) return(df)
  parts <- lapply(split(seq_len(nrow(df)), as.character(df$position)), function(rows) {
    x <- df[rows, , drop = FALSE]
    x <- x[order(sos_prob_num(x[[rank_col]]), x$player_key, na.last = TRUE), , drop = FALSE]
    target_keys <- x$player_key[is.finite(sos_prob_num(x[[target_col]]))]
    if (length(target_keys) > 0L) {
      target_keys <- target_keys[order(
        sos_prob_num(x[[target_col]])[match(target_keys, x$player_key)]
      )]
      for (key in target_keys) {
        current <- match(key, x$player_key)
        target <- pmin(
          nrow(x),
          pmax(1L, as.integer(sos_prob_num(x[[target_col]][[current]])))
        )
        target_row <- x[current, , drop = FALSE]
        x <- x[-current, , drop = FALSE]
        before <- if (target > 1L) x[seq_len(target - 1L), , drop = FALSE] else x[0, , drop = FALSE]
        after <- if (target <= nrow(x)) x[target:nrow(x), , drop = FALSE] else x[0, , drop = FALSE]
        x <- dplyr::bind_rows(before, target_row, after)
      }
    }
    x[[rank_col]] <- seq_len(nrow(x))
    x
  })
  dplyr::bind_rows(parts)
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
    K = c(top6 = 6L, top12 = 12L, top18 = 18L, top24 = 24L),
    DST = c(top6 = 6L, top12 = 12L, top18 = 18L, top24 = 24L),
    c(top12 = 12L)
  )
}

sos_prob_scopes <- function(position) {
  if (toupper(position) %in% c("K", "DST")) "total" else c("ppg", "total")
}

sos_standardize_probability_input <- function(df, position) {
  position <- toupper(position)
  if (!is.data.frame(df)) stop("SOS probability input must be a data frame.", call. = FALSE)

  if (position == "DST") {
    aliases <- list(
      season = c("predict_season", "prediction_season"),
      rank = "dst_sos_rank",
      tier = "dst_sos_tier",
      current_team = "team",
      next_team = "team",
      final_score = "dst_sos_final_score",
      board_score = c("dst_sos_anchor_component_0to100", "dst_sos_final_score"),
      actual_next_ppg = "target_next_ppg",
      actual_next_total_points = "target_next_total_points"
    )
    for (target in names(aliases)) {
      if (target %in% names(df)) next
      source <- aliases[[target]][aliases[[target]] %in% names(df)][1]
      if (length(source) == 1L && !is.na(source)) df[[target]] <- df[[source]]
    }
  }

  if (!"preseason_omfg" %in% names(df)) df$preseason_omfg <- NA_real_
  if (!"board_score" %in% names(df)) df$board_score <- df$final_score
  if (!"actual_next_ppg" %in% names(df)) df$actual_next_ppg <- NA_real_
  if (!"actual_next_total_points" %in% names(df)) df$actual_next_total_points <- NA_real_
  df
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
  predictor_cols <- c("rank_score_z", "omfg_score_z")
  predictor_cols <- predictor_cols[predictor_cols %in% names(train)]
  if (length(predictor_cols) == 0L) {
    predictor_cols <- c("model_score_z", "rank_score_z", "omfg_score_z", "board_score_z")
    predictor_cols <- predictor_cols[predictor_cols %in% names(train)]
  }
  fit <- try(
    suppressWarnings(stats::glm(
      stats::reformulate(predictor_cols, response = "target_outcome"),
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
    sos_standardize_probability_input(position) |>
    sos_prob_collapse_player_seasons()
  thresholds <- sos_prob_targets(position)
  scopes <- sos_prob_scopes(position)
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
    for (scope in scopes) {
      rank_col <- paste0("actual_", scope, "_rank")
      outcome_col <- paste0("actual_", scope, "_", target_name)
      probability_col <- paste0("prob_", scope, "_", target_name)
      out[[outcome_col]] <- ifelse(
        is.finite(out[[rank_col]]),
        as.integer(out[[rank_col]] <= cutoff),
        NA_integer_
      )
      raw_probability <- sos_prob_fit_predict(out, outcome_col)
      if (position == "QB") {
        out[[paste0("raw_", probability_col)]] <- raw_probability
        out[[probability_col]] <- sos_prob_apply_oof_calibration(
          raw_probability,
          paste0(scope, "_", target_name),
          calibration_profile
        )
      } else {
        out[[probability_col]] <- raw_probability
      }
    }
  }

  ordered_targets <- names(thresholds)[order(as.integer(thresholds))]
  for (scope in scopes) {
    out <- sos_prob_enforce_nested(
      out,
      paste0("prob_", scope, "_", ordered_targets)
    )
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
    for (scope in scopes) {
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

build_core_sos_tier_probabilities <- function(positions = c("QB", "RB", "WR", "TE", "K", "DST"), write_output = TRUE) {
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
  positions = c("QB", "RB", "WR", "TE", "K", "DST"),
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
    sos_standardize_probability_input(position_label) |>
    sos_prob_collapse_player_seasons()
  thresholds <- sos_prob_targets(position_label)
  scopes <- sos_prob_scopes(position_label)
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
      omfg_rank = rank(-.data$preseason_omfg, ties.method = "first", na.last = "keep")
    ) |>
    dplyr::mutate(
      probability_rank = dplyr::if_else(
        is.finite(.data$omfg_rank),
        .data$omfg_rank,
        .data$rank
      ),
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
    dplyr::mutate(rank_score_0to100 = sos_prob_rank_score(.data$probability_rank, .data$field_size))

  for (target_name in names(thresholds)) {
    cutoff <- thresholds[[target_name]]
    for (scope in scopes) {
      rank_col <- paste0("actual_", scope, "_rank")
      frame[[paste0("actual_", scope, "_", target_name)]] <- ifelse(
        is.finite(frame[[rank_col]]),
        as.integer(frame[[rank_col]] <= cutoff),
        NA_integer_
      )
    }
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
      for (scope in scopes) {
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
  positions = c("QB", "RB", "WR", "TE", "K", "DST"),
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

sos_2026_depth_chart_dir <- function() {
  file.path(model_paths$nflfastr_root_dir, "2026 data")
}

sos_normalize_team_name_key <- function(team_name_vec) {
  team_name_vec <- as.character(team_name_vec)
  team_name_vec <- iconv(team_name_vec, to = "ASCII//TRANSLIT")
  team_name_vec <- tolower(team_name_vec)
  team_name_vec <- gsub("[^a-z0-9 ]", " ", team_name_vec)
  trimws(gsub("\\s+", " ", team_name_vec))
}

sos_nfl_team_name_lookup <- function() {
  data.frame(
    team_name = c(
      "Arizona Cardinals", "Atlanta Falcons", "Baltimore Ravens", "Buffalo Bills",
      "Carolina Panthers", "Chicago Bears", "Cincinnati Bengals", "Cleveland Browns",
      "Dallas Cowboys", "Denver Broncos", "Detroit Lions", "Green Bay Packers",
      "Houston Texans", "Indianapolis Colts", "Jacksonville Jaguars", "Kansas City Chiefs",
      "Las Vegas Raiders", "Los Angeles Chargers", "Los Angeles Rams", "Miami Dolphins",
      "Minnesota Vikings", "New England Patriots", "New Orleans Saints", "New York Giants",
      "New York Jets", "Philadelphia Eagles", "Pittsburgh Steelers", "San Francisco 49ers",
      "Seattle Seahawks", "Tampa Bay Buccaneers", "Tennessee Titans", "Washington Commanders"
    ),
    team = c(
      "ARI", "ATL", "BAL", "BUF", "CAR", "CHI", "CIN", "CLE",
      "DAL", "DEN", "DET", "GB", "HOU", "IND", "JAX", "KC",
      "LV", "LAC", "LAR", "MIA", "MIN", "NE", "NO", "NYG",
      "NYJ", "PHI", "PIT", "SF", "SEA", "TB", "TEN", "WAS"
    ),
    stringsAsFactors = FALSE
  ) |>
    dplyr::mutate(team_key = sos_normalize_team_name_key(.data$team_name))
}

sos_parse_depth_csv_line <- function(line, width = 8L) {
  parsed <- tryCatch(
    utils::read.csv(
      text = line,
      header = FALSE,
      col.names = paste0("V", seq_len(width)),
      fill = TRUE,
      stringsAsFactors = FALSE,
      check.names = FALSE
    ),
    error = function(e) NULL
  )
  if (is.null(parsed)) return(rep(NA_character_, width))
  values <- as.character(parsed[1, seq_len(width)])
  values[values == ""] <- NA_character_
  values
}

sos_read_2026_depth_chart_week <- function(
    prediction_season = 2026L,
    week = 1L,
    depth_dir = sos_2026_depth_chart_dir(),
    write_output = FALSE,
    output_dir = sos_production_output_dir()
) {
  load_model_core_packages()
  prediction_season <- as.integer(prediction_season[[1]])
  week <- as.integer(week[[1]])
  depth_path <- file.path(
    depth_dir,
    sprintf("Depth Chart %s wk %s.csv", substr(as.character(prediction_season), 3L, 4L), week)
  )
  if (!file.exists(depth_path)) {
    return(data.frame(
      prediction_season = integer(),
      week = integer(),
      team = character(),
      team_name = character(),
      position = character(),
      player = character(),
      player_key = character(),
      depth_team = integer(),
      depth_ecr = numeric(),
      roster_source = character(),
      stringsAsFactors = FALSE
    ))
  }

  lines <- readLines(depth_path, warn = FALSE, encoding = "UTF-8")
  lines <- trimws(gsub("\ufeff", "", lines, fixed = TRUE))
  team_lookup <- sos_nfl_team_name_lookup()
  rows <- list()
  row_idx <- 0L
  i <- 1L
  while (i <= length(lines)) {
    current_line <- lines[[i]]
    current_clean <- trimws(gsub('^"|"$', "", current_line))
    if (!nzchar(current_clean)) {
      i <- i + 1L
      next
    }
    if (!grepl(",", current_line, fixed = TRUE)) {
      team_name <- current_clean
      team_key <- sos_normalize_team_name_key(team_name)
      team <- team_lookup$team[match(team_key, team_lookup$team_key)]
      if (is.na(team)) {
        stop("Unable to map 2026 depth chart team name: ", team_name, call. = FALSE)
      }
      i <- i + 1L
      if (i <= length(lines) && grepl("Quarterbacks", lines[[i]], fixed = TRUE)) {
        i <- i + 1L
      }
      pos_counts <- c(QB = 0L, RB = 0L, WR = 0L, TE = 0L)
      while (i <= length(lines)) {
        row_line <- lines[[i]]
        if (!nzchar(row_line) || !grepl(",", row_line, fixed = TRUE)) break
        row_values <- sos_parse_depth_csv_line(row_line, width = 8L)
        by_pos <- data.frame(
          position = c("QB", "RB", "WR", "TE"),
          depth_ecr = suppressWarnings(as.numeric(c(row_values[[1]], row_values[[3]], row_values[[5]], row_values[[7]]))),
          player = c(row_values[[2]], row_values[[4]], row_values[[6]], row_values[[8]]),
          stringsAsFactors = FALSE
        )
        for (j in seq_len(nrow(by_pos))) {
          player_name <- trimws(as.character(by_pos$player[[j]]))
          if (
            !is.na(player_name) && nzchar(player_name) &&
              !toupper(player_name) %in% c("NA", "N/A", "TBD", "NONE")
          ) {
            position <- by_pos$position[[j]]
            pos_counts[[position]] <- pos_counts[[position]] + 1L
            row_idx <- row_idx + 1L
            rows[[row_idx]] <- data.frame(
              prediction_season = prediction_season,
              week = week,
              team = team,
              team_name = team_name,
              position = position,
              player = player_name,
              player_key = make_player_key(player_name),
              depth_team = pos_counts[[position]],
              depth_ecr = by_pos$depth_ecr[[j]],
              roster_source = "fantasypros_depth_chart",
              stringsAsFactors = FALSE
            )
          }
        }
        i <- i + 1L
      }
      next
    }
    i <- i + 1L
  }

  out <- if (length(rows) == 0L) {
    data.frame(
      prediction_season = integer(),
      week = integer(),
      team = character(),
      team_name = character(),
      position = character(),
      player = character(),
      player_key = character(),
      depth_team = integer(),
      depth_ecr = numeric(),
      roster_source = character(),
      stringsAsFactors = FALSE
    )
  } else {
    dplyr::bind_rows(rows) |>
      dplyr::group_by(.data$prediction_season, .data$week, .data$position, .data$player_key) |>
      dplyr::slice_min(order_by = .data$depth_team, with_ties = FALSE) |>
      dplyr::ungroup() |>
      dplyr::arrange(factor(.data$position, levels = c("QB", "RB", "WR", "TE", "K", "DST")), .data$team, .data$depth_team)
  }

  if (isTRUE(write_output)) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      out,
      file.path(output_dir, paste0("sos_", prediction_season, "_depth_chart_week", week, ".csv")),
      row.names = FALSE,
      na = ""
    )
  }
  out
}

sos_2026_rookie_lookup <- function(prediction_season = 2026L) {
  prediction_season <- as.integer(prediction_season[[1]])
  combine_path <- file.path(model_paths$nflfastr_root_dir, "combine_2015_2026.csv")
  if (!file.exists(combine_path)) {
    return(data.frame(player_key = character(), position = character(), rookie_year = integer(), draft_round = numeric(), draft_ovr = numeric(), stringsAsFactors = FALSE))
  }
  combine <- utils::read.csv(combine_path, stringsAsFactors = FALSE, check.names = FALSE)
  required <- c("draft_year", "display_name", "pos")
  if (!all(required %in% names(combine))) {
    return(data.frame(player_key = character(), position = character(), rookie_year = integer(), draft_round = numeric(), draft_ovr = numeric(), stringsAsFactors = FALSE))
  }
  if (!"draft_round" %in% names(combine)) combine$draft_round <- NA_real_
  if (!"draft_ovr" %in% names(combine)) combine$draft_ovr <- NA_real_
  combine |>
    dplyr::transmute(
      player_key = make_player_key(.data$display_name),
      position = toupper(as.character(.data$pos)),
      rookie_year = suppressWarnings(as.integer(.data$draft_year)),
      draft_round = suppressWarnings(as.numeric(.data$draft_round)),
      draft_ovr = suppressWarnings(as.numeric(.data$draft_ovr))
    ) |>
    dplyr::filter(.data$rookie_year == .env$prediction_season, .data$position %in% c("QB", "RB", "WR", "TE", "K")) |>
    dplyr::distinct(.data$player_key, .data$position, .keep_all = TRUE)
}

sos_rank_tier_from_rank <- function(position, rank) {
  position <- toupper(as.character(position[[1]]))
  rank <- suppressWarnings(as.integer(rank))
  dplyr::case_when(
    position == "QB" & rank <= 6L ~ "Tier 1",
    position == "QB" & rank <= 12L ~ "Tier 2",
    position == "QB" & rank <= 18L ~ "Tier 3",
    position == "RB" & rank <= 12L ~ "Tier 1",
    position == "RB" & rank <= 24L ~ "Tier 2",
    position == "RB" & rank <= 36L ~ "Tier 3",
    position == "WR" & rank <= 12L ~ "Tier 1",
    position == "WR" & rank <= 24L ~ "Tier 2",
    position == "WR" & rank <= 36L ~ "Tier 3",
    position == "TE" & rank <= 6L ~ "Tier 1",
    position == "TE" & rank <= 12L ~ "Tier 2",
    position == "TE" & rank <= 18L ~ "Tier 3",
    position == "K" & rank <= 6L ~ "Tier 1",
    position == "K" & rank <= 12L ~ "Tier 2",
    position == "DST" & rank <= 6L ~ "Tier 1",
    position == "DST" & rank <= 12L ~ "Tier 2",
    TRUE ~ "Tier 4"
  )
}

sos_depth_seed_score <- function(depth, prediction_season = 2026L) {
  if (nrow(depth) == 0L) return(depth)
  rookies <- sos_2026_rookie_lookup(prediction_season)
  depth |>
    dplyr::left_join(rookies, by = c("player_key", "position"), relationship = "many-to-one") |>
    dplyr::group_by(.data$position) |>
    dplyr::mutate(
      depth_ecr_numeric = suppressWarnings(as.numeric(.data$depth_ecr)),
      ecr_rank = dplyr::if_else(is.finite(.data$depth_ecr_numeric), .data$depth_ecr_numeric, as.numeric(.data$depth_team)),
      ecr_score = 100 * (1 - (rank(.data$ecr_rank, ties.method = "first") - 1) / pmax(dplyr::n() - 1, 1)),
      depth_slot_score = dplyr::case_when(
        .data$position == "QB" ~ pmax(8, 96 - 28 * (.data$depth_team - 1)),
        .data$position %in% c("RB", "WR", "TE") ~ pmax(8, 96 - 12 * (.data$depth_team - 1)),
        TRUE ~ pmax(8, 90 - 12 * (.data$depth_team - 1))
      )
    ) |>
    dplyr::ungroup() |>
    dplyr::mutate(
      draft_score = dplyr::if_else(
        is.finite(.data$draft_ovr),
        pmax(5, 100 - 0.35 * .data$draft_ovr),
        NA_real_
      ),
      roster_seed_score = dplyr::if_else(
        is.finite(.data$draft_score),
        12 + 0.36 * .data$ecr_score + 0.16 * .data$depth_slot_score + 0.24 * .data$draft_score,
        18 + 0.45 * .data$ecr_score + 0.18 * .data$depth_slot_score
      ),
      roster_seed_score = pmin(82, pmax(8, .data$roster_seed_score)),
      is_2026_rookie = as.integer(.data$rookie_year == as.integer(.env$prediction_season))
    )
}

sos_estimate_new_pool_anchor <- function(position, future, target_col) {
  position <- toupper(position)
  fallback <- rep(0, nrow(future))
  history <- tryCatch(sos_projection_history(position), error = function(e) NULL)
  if (is.null(history) || nrow(history) == 0L) return(fallback)

  target <- sos_prob_num(history[[target_col]])
  train <- data.frame(
    target = target,
    official_omfg = sos_prob_num(history$official_omfg),
    rank_score_0to100 = sos_prob_num(history$rank_score_0to100)
  )
  test <- data.frame(
    official_omfg = sos_prob_num(future$final_score),
    rank_score_0to100 = sos_prob_rank_score(sos_prob_num(future$rank), nrow(future))
  )

  keep <- is.finite(train$target) &
    is.finite(train$official_omfg) &
    is.finite(train$rank_score_0to100)
  if (sum(keep) < 25L) return(fallback)

  fit <- try(
    suppressWarnings(stats::lm(target ~ official_omfg + rank_score_0to100, data = train[keep, , drop = FALSE])),
    silent = TRUE
  )
  prediction <- if (inherits(fit, "try-error")) {
    fallback
  } else {
    candidate <- try(suppressWarnings(stats::predict(fit, newdata = test)), silent = TRUE)
    if (inherits(candidate, "try-error")) fallback else as.numeric(candidate)
  }
  prediction[!is.finite(prediction)] <- 0
  historical_upper <- stats::quantile(train$target[keep], 0.95, na.rm = TRUE, names = FALSE)
  if (!is.finite(historical_upper) || historical_upper <= 0) historical_upper <- max(train$target[keep], na.rm = TRUE)
  pmin(pmax(0, prediction), historical_upper)
}

sos_apply_future_roster_depth_overlay <- function(
    export,
    position,
    prediction_season,
    output_dir = sos_production_output_dir(),
    write_output = TRUE
) {
  load_model_core_packages()
  position <- toupper(position)
  prediction_season <- as.integer(prediction_season[[1]])
  if (!position %in% c("QB", "RB", "WR", "TE", "K")) return(export)

  depth <- sos_read_2026_depth_chart_week(prediction_season, week = 1L, write_output = write_output, output_dir = output_dir) |>
    dplyr::filter(.data$position == .env$position) |>
    sos_depth_seed_score(prediction_season)
  if (nrow(depth) == 0L) return(export)

  if (!"player_key" %in% names(export)) export$player_key <- make_player_key(export$player)
  if (!"next_team" %in% names(export)) export$next_team <- NA_character_
  if (!"current_team" %in% names(export)) export$current_team <- NA_character_
  if (!"preseason_omfg" %in% names(export)) export$preseason_omfg <- NA_real_
  if (!"final_score" %in% names(export)) export$final_score <- NA_real_
  if (!"board_score" %in% names(export)) export$board_score <- NA_real_
  if (!"games" %in% names(export)) export$games <- NA_real_
  if (!"anchor_ppg" %in% names(export)) export$anchor_ppg <- NA_real_
  if (!"anchor_total_points" %in% names(export)) export$anchor_total_points <- NA_real_
  if (!"weight_profile" %in% names(export)) export$weight_profile <- NA_character_
  if (!"is_new_to_sos_pool" %in% names(export)) export$is_new_to_sos_pool <- 0L
  if (!"prior_team_2025" %in% names(export)) export$prior_team_2025 <- normalize_team_abbr(as.character(export$current_team))

  existing_keys <- unique(as.character(export$player_key))
  added_depth <- depth |>
    dplyr::filter(!.data$player_key %in% existing_keys)

  added <- if (nrow(added_depth) == 0L) {
    export[0, , drop = FALSE]
  } else {
    template <- export[rep(NA_integer_, nrow(added_depth)), , drop = FALSE]
    template[] <- NA
    template$position <- position
    template$production_mode <- "future_season_roster_depth_seed"
    template$source_season <- prediction_season - 1L
    template$prediction_season <- prediction_season
    if ("season" %in% names(template)) template$season <- prediction_season
    template$player <- added_depth$player
    template$player_key <- added_depth$player_key
    template$current_team <- added_depth$team
    template$next_team <- added_depth$team
    template$prior_team_2025 <- NA_character_
    template$games <- 0
    template$weight_profile <- "rookie_roster_depth_seed"
    template$final_score <- added_depth$roster_seed_score
    template$preseason_omfg <- added_depth$roster_seed_score
    template$board_score <- added_depth$roster_seed_score
    template$anchor_ppg <- 0
    template$anchor_total_points <- 0
    template$is_new_to_sos_pool <- 1L
    template
  }

  depth_lookup <- depth |>
    dplyr::select(
      player_key,
      depth_chart_team_2026 = team,
      depth_team_2026 = depth_team,
      depth_ecr_2026 = depth_ecr,
      roster_seed_score,
      is_2026_rookie
    )

  out <- dplyr::bind_rows(export, added) |>
    dplyr::left_join(depth_lookup, by = "player_key", relationship = "many-to-one") |>
    dplyr::mutate(
      prior_team_2025 = dplyr::if_else(
        dplyr::coalesce(.data$is_new_to_sos_pool, 0L) == 1L,
        NA_character_,
        dplyr::coalesce(normalize_team_abbr(as.character(.data$prior_team_2025)), normalize_team_abbr(as.character(.data$current_team)))
      ),
      next_team = dplyr::coalesce(.data$depth_chart_team_2026, normalize_team_abbr(as.character(.data$next_team)), normalize_team_abbr(as.character(.data$current_team))),
      current_team = dplyr::coalesce(.data$depth_chart_team_2026, normalize_team_abbr(as.character(.data$current_team)), .data$next_team),
      roster_context_source = dplyr::if_else(
        !is.na(.data$depth_chart_team_2026),
        "2026_depth_chart_week1",
        "prior_season_team"
      ),
      is_2026_rookie = dplyr::coalesce(.data$is_2026_rookie, 0L),
      is_new_to_sos_pool = dplyr::coalesce(.data$is_new_to_sos_pool, 0L),
      final_score = dplyr::coalesce(sos_prob_num(.data$final_score), .data$roster_seed_score, sos_prob_num(.data$board_score), sos_prob_num(.data$preseason_omfg), 0),
      preseason_omfg = dplyr::coalesce(sos_prob_num(.data$preseason_omfg), .data$final_score),
      board_score = dplyr::coalesce(sos_prob_num(.data$board_score), .data$final_score)
    ) |>
    dplyr::arrange(dplyr::desc(.data$final_score), .data$player) |>
    dplyr::mutate(
      rank = dplyr::row_number(),
      tier = vapply(.data$rank, function(r) sos_rank_tier_from_rank(.env$position, r), character(1))
    )

  new_pool <- dplyr::coalesce(out$is_new_to_sos_pool, 0L) == 1L
  if (any(new_pool, na.rm = TRUE)) {
    estimated_ppg <- sos_estimate_new_pool_anchor(position, out, "actual_next_ppg")
    estimated_total <- sos_estimate_new_pool_anchor(position, out, "actual_next_total_points")
    out$anchor_ppg[new_pool & (!is.finite(sos_prob_num(out$anchor_ppg)) | sos_prob_num(out$anchor_ppg) <= 0)] <-
      estimated_ppg[new_pool & (!is.finite(sos_prob_num(out$anchor_ppg)) | sos_prob_num(out$anchor_ppg) <= 0)]
    out$anchor_total_points[new_pool & (!is.finite(sos_prob_num(out$anchor_total_points)) | sos_prob_num(out$anchor_total_points) <= 0)] <-
      estimated_total[new_pool & (!is.finite(sos_prob_num(out$anchor_total_points)) | sos_prob_num(out$anchor_total_points) <= 0)]
  }

  audit <- data.frame(
    position = position,
    prediction_season = prediction_season,
    depth_chart_rows = nrow(depth),
    production_rows_before = nrow(export),
    production_rows_after = nrow(out),
    added_depth_rows = nrow(added_depth),
    team_updates = sum(!is.na(out$depth_chart_team_2026) & normalize_team_abbr(as.character(out$prior_team_2025)) != out$depth_chart_team_2026, na.rm = TRUE),
    rookie_rows = sum(out$is_2026_rookie == 1L, na.rm = TRUE),
    new_to_sos_pool_rows = sum(out$is_new_to_sos_pool == 1L, na.rm = TRUE),
    stringsAsFactors = FALSE
  )
  if (isTRUE(write_output)) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      audit,
      file.path(output_dir, paste0(tolower(position), "_sos_roster_depth_overlay_audit_", prediction_season, ".csv")),
      row.names = FALSE,
      na = ""
    )
  }
  out
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
  if (!position %in% c("QB", "RB", "WR", "TE", "K", "DST")) return(NULL)

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
    sos_standardize_probability_input(position) |>
    sos_prob_collapse_player_seasons()
  future <- sos_standardize_probability_input(production_export, position)
  future$actual_next_ppg <- NA_real_
  future$actual_next_total_points <- NA_real_
  frame <- dplyr::bind_rows(historical, future)
  thresholds <- sos_prob_targets(position)
  scopes <- sos_prob_scopes(position)
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
      omfg_rank = rank(-.data$preseason_omfg, ties.method = "first", na.last = "keep")
    ) |>
    dplyr::mutate(
      probability_rank = dplyr::if_else(
        is.finite(.data$omfg_rank),
        .data$omfg_rank,
        .data$rank
      ),
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
      rank_score_0to100 = sos_prob_rank_score(.data$probability_rank, .data$field_size),
      model_score_z = sos_prob_z(.data$final_score),
      rank_score_z = sos_prob_z(.data$rank_score_0to100),
      omfg_score_z = sos_prob_z(.data$preseason_omfg),
      board_score_z = sos_prob_z(.data$board_score)
    )

  for (target_name in names(thresholds)) {
    cutoff <- thresholds[[target_name]]
    for (scope in scopes) {
      rank_col <- paste0("actual_", scope, "_rank")
      outcome_col <- paste0("actual_", scope, "_", target_name)
      probability_col <- paste0("prob_", scope, "_", target_name)
      scored[[outcome_col]] <- ifelse(
        is.finite(scored[[rank_col]]),
        as.integer(scored[[rank_col]] <= cutoff),
        NA_integer_
      )
      raw_probability <- sos_prob_fit_predict(scored, outcome_col)
      scored[[probability_col]] <- if (position == "QB") {
        sos_prob_apply_oof_calibration(
          raw_probability,
          paste0(scope, "_", target_name),
          calibration_profile
        )
      } else {
        raw_probability
      }
    }
  }

  ordered_targets <- names(thresholds)[order(as.integer(thresholds))]
  for (scope in scopes) {
    scored <- sos_prob_enforce_nested(
      scored,
      paste0("prob_", scope, "_", ordered_targets)
    )
  }

  probability_cols <- grep("^prob_(ppg|total)_top[0-9]+$", names(scored), value = TRUE)
  out <- scored |>
    dplyr::filter(.data$season == as.integer(.env$prediction_season)) |>
    dplyr::select(
      "season", "rank", "omfg_rank", "player", "current_team",
      dplyr::all_of(probability_cols)
    ) |>
    dplyr::arrange(.data$omfg_rank, .data$rank)

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
        production_mode = "future_season_with_probabilities",
        source_season = .env$source_season,
        prediction_season = .data$season,
        .before = 1
      )

  }

  export <- sos_apply_future_roster_depth_overlay(
    export,
    position = position,
    prediction_season = prediction_season,
    output_dir = output_dir,
    write_output = write_output
  )

  probabilities <- build_position_sos_production_probabilities(
    position,
    export,
    prediction_season,
    write_output = write_output,
    output_dir = output_dir
  )
  export <- export |>
    dplyr::mutate(
      production_mode = dplyr::if_else(
        !is.na(.data$production_mode) & nzchar(as.character(.data$production_mode)),
        as.character(.data$production_mode),
        "future_season_with_probabilities"
      )
    ) |>
    dplyr::left_join(
      probabilities,
      by = c("season", "rank", "player", "current_team"),
      relationship = "one-to-one"
    )

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
  position_values <- toupper(trimws(as.character(master$position)))
  missing_position_rows <- sum(is.na(position_values) | !nzchar(position_values))
  positions <- unique(position_values[!is.na(position_values) & nzchar(position_values)])
  rows <- lapply(positions, function(position) {
    x <- master[!is.na(position_values) & position_values == position, , drop = FALSE]
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
      nrow(x) > 0L && missing_position_rows == 0L &&
        duplicate_keys == 0L && missing_ranks == 0L &&
        season_mismatch == 0L && probability_missing == 0L &&
        probability_out_of_bounds == 0L && nested_violations == 0L
    ) "PASS" else "FAIL"
    data.frame(
      position = position,
      prediction_season = as.integer(prediction_season),
      rows = nrow(x),
      missing_position_rows = missing_position_rows,
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

# -----------------------------------------------------------------------------
# SOS projection ranges, simulation, and governed manual context
# -----------------------------------------------------------------------------

sos_manual_context_dir <- function() {
  file.path(model_paths$model_root_dir, "inputs", "manual_context")
}

sos_manual_context_path <- function(prediction_season = 2026L) {
  file.path(
    sos_manual_context_dir(),
    paste0("sos_", as.integer(prediction_season), "_manual_context.csv")
  )
}

sos_manual_context_columns <- function() {
  c(
    "prediction_season", "position", "player", "team", "note",
    "adjustment_channel", "direction", "magnitude", "confidence",
    "reason", "source_type", "source_reference", "enabled"
  )
}

sos_empty_manual_context <- function(prediction_season = 2026L) {
  context <- as.data.frame(
    setNames(
      replicate(length(sos_manual_context_columns()), character(), simplify = FALSE),
      sos_manual_context_columns()
    ),
    stringsAsFactors = FALSE
  )
  context$prediction_season <- integer()
  context$magnitude <- double()
  context$confidence <- double()
  context$enabled_flag <- logical()
  context$player_key <- character()
  context
}

write_sos_manual_context_template <- function(
    prediction_season = 2026L,
    path = sos_manual_context_path(prediction_season),
    overwrite = FALSE
) {
  if (file.exists(path) && !isTRUE(overwrite)) return(path)
  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
  template <- as.data.frame(
    setNames(replicate(length(sos_manual_context_columns()), character(), simplify = FALSE),
             sos_manual_context_columns()),
    stringsAsFactors = FALSE
  )
  utils::write.csv(template, path, row.names = FALSE, na = "")
  path
}

sos_manual_context_channels <- function() {
  c(
    "note_only",
    "projected_games", "active_games", "games_started_distribution",
    "starter_probability", "role_share", "target_share", "carry_share",
    "opportunity_share", "route_share", "first_read_share", "end_zone_share",
    "passing_volume", "rushing_volume", "passing_touchdowns", "efficiency", "touchdown_environment",
    "quarterback_playcaller_effect", "team_environment", "mobility",
    "role_transfer_path", "injury_risk", "uncertainty_width",
    "p10_modifier", "p25_modifier", "p50_modifier", "p75_modifier", "p90_modifier"
  )
}

sos_normalize_manual_context_channel <- function(x) {
  channel <- tolower(trimws(as.character(x)))
  channel <- dplyr::recode(
    channel,
    "effiency" = "efficiency",
    "touchdown_enrionment" = "touchdown_environment",
    "td_environment" = "touchdown_environment",
    "qb_playcaller_effect" = "quarterback_playcaller_effect",
    .default = channel
  )
  dplyr::coalesce(channel, "")
}

sos_context_enabled <- function(x) {
  tolower(trimws(as.character(x))) %in% c("true", "t", "1", "yes", "y")
}

sos_normalize_context_confidence <- function(x, default = 0.75) {
  confidence <- sos_prob_num(x)
  confidence <- dplyr::if_else(
    is.finite(confidence) & confidence > 1,
    confidence / 3,
    confidence
  )
  confidence <- pmin(1, pmax(0, confidence))
  dplyr::if_else(is.finite(confidence), confidence, default)
}

sos_manual_context_seed_path <- function(position, prediction_season = 2026L) {
  file.path(
    sos_manual_context_dir(),
    paste0(
      "sos_",
      as.integer(prediction_season),
      "_manual_context_seed_",
      tolower(position),
      ".csv"
    )
  )
}

sos_get_first_existing_col <- function(df, choices, default = NA) {
  found <- choices[choices %in% names(df)]
  if (length(found) == 0L) return(rep(default, nrow(df)))
  df[[found[[1]]]]
}

sos_seed_context_columns <- function() {
  c(
    "note", "adjustment_channel", "direction", "magnitude", "confidence",
    "reason", "source_type", "source_reference", "enabled"
  )
}

sos_safe_text <- function(x) {
  x <- as.character(x)
  out <- iconv(x, from = "", to = "UTF-8", sub = "")
  out[is.na(out) & !is.na(x)] <- iconv(x[is.na(out) & !is.na(x)], to = "ASCII//TRANSLIT", sub = "")
  out
}

sos_seed_has_user_entry <- function(df) {
  if (nrow(df) == 0L) return(logical())
  get_chr <- function(col) {
    if (!(col %in% names(df))) return(rep("", nrow(df)))
    out <- trimws(sos_safe_text(df[[col]]))
    out[is.na(out)] <- ""
    out
  }
  get_num <- function(col) {
    if (col %in% names(df)) sos_prob_num(df[[col]]) else rep(NA_real_, nrow(df))
  }
  nzchar(get_chr("note")) |
    nzchar(get_chr("adjustment_channel")) |
    nzchar(get_chr("direction")) |
    nzchar(get_chr("reason")) |
    nzchar(get_chr("source_reference")) |
    sos_context_enabled(get_chr("enabled")) |
    is.finite(get_num("magnitude")) |
    is.finite(get_num("confidence"))
}

sos_preserve_existing_seed_context <- function(seed, path) {
  if (!file.exists(path) || nrow(seed) == 0L) return(seed)
  existing <- utils::read.csv(path, stringsAsFactors = FALSE, check.names = FALSE)
  if (nrow(existing) == 0L) return(seed)
  character_cols <- names(existing)[vapply(existing, is.character, logical(1))]
  for (col in character_cols) existing[[col]] <- sos_safe_text(existing[[col]])
  if (!"player_key" %in% names(existing)) existing$player_key <- make_player_key(existing$player)
  if (!"player_key" %in% names(seed)) seed$player_key <- make_player_key(seed$player)

  context_cols <- sos_seed_context_columns()
  for (col in context_cols) {
    if (!col %in% names(existing)) existing[[col]] <- NA
    if (!col %in% names(seed)) seed[[col]] <- NA
  }
  existing <- existing |>
    dplyr::mutate(
      position = toupper(as.character(.data$position)),
      player_key = as.character(.data$player_key),
      has_user_entry = sos_seed_has_user_entry(dplyr::pick(dplyr::everything()))
    ) |>
    dplyr::filter(.data$has_user_entry)
  if (nrow(existing) == 0L) return(seed)

  seed_names <- seed |>
    dplyr::transmute(
      position = toupper(as.character(.data$position)),
      player_key = as.character(.data$player_key),
      seed_player_name = sos_safe_text(.data$player)
    ) |>
    dplyr::distinct(.data$position, .data$player_key, .keep_all = TRUE)

  existing <- existing |>
    dplyr::left_join(seed_names, by = c("position", "player_key"), relationship = "many-to-one") |>
    dplyr::mutate(
      exact_seed_name_match = make_player_key(.data$player) == make_player_key(.data$seed_player_name),
      source_type_priority = dplyr::if_else(.data$exact_seed_name_match, 0L, 1L)
    ) |>
    dplyr::arrange(.data$position, .data$player_key, .data$source_type_priority) |>
    dplyr::group_by(.data$position, .data$player_key) |>
    dplyr::mutate(seed_context_row = dplyr::row_number()) |>
    dplyr::ungroup()

  first_context <- existing |>
    dplyr::filter(.data$seed_context_row == 1L) |>
    dplyr::select("position", "player_key", dplyr::all_of(context_cols))
  names(first_context)[names(first_context) %in% context_cols] <- paste0(context_cols, "_existing")

  merged <- seed |>
    dplyr::left_join(first_context, by = c("position", "player_key"), relationship = "many-to-one")
  for (col in context_cols) {
    existing_col <- paste0(col, "_existing")
    if (!existing_col %in% names(merged)) next
    if (is.numeric(merged[[col]]) || is.numeric(merged[[existing_col]])) {
      existing_num <- sos_prob_num(merged[[existing_col]])
      current_num <- sos_prob_num(merged[[col]])
      merged[[col]] <- dplyr::if_else(is.finite(existing_num), existing_num, current_num)
    } else {
      existing_chr <- trimws(as.character(merged[[existing_col]]))
      current_chr <- as.character(merged[[col]])
      merged[[col]] <- dplyr::if_else(nzchar(existing_chr), existing_chr, current_chr)
    }
  }
  merged <- merged |>
    dplyr::select(-dplyr::ends_with("_existing"))

  extra_context <- existing |>
    dplyr::filter(.data$seed_context_row > 1L)
  if (nrow(extra_context) == 0L) return(merged)

  seed_lookup <- seed |>
    dplyr::group_by(.data$position, .data$player_key) |>
    dplyr::slice(1L) |>
    dplyr::ungroup()
  extras <- extra_context |>
    dplyr::select("position", "player_key", dplyr::all_of(context_cols)) |>
    dplyr::left_join(
      seed_lookup |>
        dplyr::select(-dplyr::all_of(context_cols)),
      by = c("position", "player_key"),
      relationship = "many-to-one"
    )
  for (col in setdiff(names(merged), names(extras))) extras[[col]] <- NA
  for (col in setdiff(names(extras), names(merged))) merged[[col]] <- NA
  extras <- extras[, names(merged), drop = FALSE]
  dplyr::bind_rows(merged, extras)
}

write_sos_manual_context_seed_files <- function(
    projection_result = get0("core_sos_projection_layer", envir = .GlobalEnv),
    prediction_season = 2026L,
    output_dir = sos_manual_context_dir(),
    overwrite = FALSE,
    preserve_existing_context = TRUE
) {
  load_model_core_packages()
  prediction_season <- as.integer(prediction_season[[1]])
  if (!is.null(projection_result) && !is.null(projection_result$projection_layer)) {
    projection_result <- projection_result$projection_layer
  }
  board <- if (!is.null(projection_result) && !is.null(projection_result$board)) {
    projection_result$board
  } else {
    board_path <- file.path(
      sos_production_output_dir(),
      paste0("core_sos_projection_board_", prediction_season, ".csv")
    )
    if (!file.exists(board_path)) {
      stop(
        "No SOS projection board found. Run run_core_sos_production() first, or pass a projection result.",
        call. = FALSE
      )
    }
    utils::read.csv(board_path, stringsAsFactors = FALSE, check.names = FALSE)
  }

  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
  rows <- lapply(split(board, board$position), function(position_board) {
    position <- unique(as.character(position_board$position))[1]
    path <- file.path(
      output_dir,
      paste0("sos_", prediction_season, "_manual_context_seed_", tolower(position), ".csv")
    )
    if (file.exists(path) && !isTRUE(overwrite)) {
      return(data.frame(position = position, output_path = path, exists = TRUE, stringsAsFactors = FALSE))
    }
    team <- dplyr::coalesce(
      as.character(sos_get_first_existing_col(position_board, c("next_team", "team"), "")),
      as.character(sos_get_first_existing_col(position_board, c("current_team"), ""))
    )
    seed <- data.frame(
      prediction_season = prediction_season,
      position = position,
      rank = sos_get_first_existing_col(position_board, c("manual_adjusted_model_rank", "rank")),
      projection_rank = sos_get_first_existing_col(position_board, c("manual_adjusted_projection_rank", "projection_rank")),
      player_key = as.character(sos_get_first_existing_col(position_board, c("player_key"), "")),
      player = as.character(position_board$player),
      team = team,
      prior_team_2025 = sos_get_first_existing_col(position_board, c("prior_team_2025"), ""),
      depth_chart_team_2026 = sos_get_first_existing_col(position_board, c("depth_chart_team_2026"), ""),
      depth_team_2026 = sos_get_first_existing_col(position_board, c("depth_team_2026"), NA),
      roster_context_source = sos_get_first_existing_col(position_board, c("roster_context_source"), ""),
      is_2026_rookie = sos_get_first_existing_col(position_board, c("is_2026_rookie"), 0),
      is_new_to_sos_pool = sos_get_first_existing_col(position_board, c("is_new_to_sos_pool"), 0),
      official_omfg = sos_get_first_existing_col(position_board, c("official_omfg", "preseason_omfg")),
      projected_games = sos_get_first_existing_col(position_board, c("adjusted_projected_games", "projected_games")),
      projected_ppg = sos_get_first_existing_col(position_board, c("adjusted_projected_ppg", "projected_ppg")),
      P50 = sos_get_first_existing_col(position_board, c("adjusted_p50_points", "P50")),
      note = "",
      adjustment_channel = "",
      direction = "",
      magnitude = NA_real_,
      confidence = NA_real_,
      reason = "",
      source_type = "manual_seed",
      source_reference = "",
      enabled = "",
      stringsAsFactors = FALSE
    ) |>
      dplyr::mutate(
        player_key = dplyr::if_else(
          nzchar(as.character(.data$player_key)),
          as.character(.data$player_key),
          make_player_key(.data$player)
        )
      ) |>
      dplyr::arrange(.data$rank)
    if (isTRUE(preserve_existing_context)) {
      seed <- sos_preserve_existing_seed_context(seed, path)
    }
    utils::write.csv(seed, path, row.names = FALSE, na = "")
    data.frame(position = position, output_path = path, exists = file.exists(path), stringsAsFactors = FALSE)
  })

  manifest <- dplyr::bind_rows(rows) |>
    dplyr::arrange(factor(.data$position, levels = c("QB", "RB", "WR", "TE", "K", "DST")))
  assign("sos_manual_context_seed_files", manifest, envir = .GlobalEnv)
  invisible(manifest)
}

build_sos_manual_context_from_seed_files <- function(
    seed_paths = NULL,
    prediction_season = 2026L,
    output_path = sos_manual_context_path(prediction_season),
    append_existing = TRUE,
    write_output = TRUE
) {
  load_model_core_packages()
  prediction_season <- as.integer(prediction_season[[1]])
  if (is.null(seed_paths)) {
    seed_paths <- sos_manual_context_seed_path(
      c("QB", "RB", "WR", "TE", "K", "DST"),
      prediction_season
    )
  }
  seed_paths <- seed_paths[file.exists(seed_paths)]
  if (length(seed_paths) == 0L) {
    stop("No seeded SOS manual context files were found.", call. = FALSE)
  }

  seed <- dplyr::bind_rows(lapply(seed_paths, function(path) {
    x <- utils::read.csv(path, stringsAsFactors = FALSE, check.names = FALSE)
    x$seed_source_path <- path
    x
  }))
  for (col in sos_manual_context_columns()) {
    if (!col %in% names(seed)) seed[[col]] <- NA
  }

  context <- seed |>
    dplyr::mutate(
      note = dplyr::coalesce(trimws(as.character(.data$note)), ""),
      adjustment_channel = sos_normalize_manual_context_channel(.data$adjustment_channel),
      direction = dplyr::coalesce(tolower(trimws(as.character(.data$direction))), ""),
      reason = dplyr::coalesce(trimws(as.character(.data$reason)), ""),
      source_type = dplyr::coalesce(trimws(as.character(.data$source_type)), "manual_seed"),
      source_reference = dplyr::coalesce(trimws(as.character(.data$source_reference)), ""),
      has_user_entry = nzchar(.data$note) | nzchar(.data$adjustment_channel) | sos_context_enabled(.data$enabled),
      adjustment_channel = dplyr::if_else(
        nzchar(.data$adjustment_channel),
        .data$adjustment_channel,
        "note_only"
      ),
      direction = dplyr::if_else(nzchar(.data$direction), .data$direction, "neutral"),
      magnitude = sos_prob_num(.data$magnitude),
      magnitude = sos_review_magnitude_to_context(.data$adjustment_channel, .data$magnitude),
      magnitude = dplyr::if_else(.data$adjustment_channel == "note_only", 0, .data$magnitude),
      confidence = sos_normalize_context_confidence(.data$confidence),
      enabled = dplyr::if_else(.data$has_user_entry, "TRUE", "FALSE")
    ) |>
    dplyr::filter(.data$prediction_season == .env$prediction_season, .data$has_user_entry) |>
    dplyr::transmute(
      prediction_season = as.integer(.data$prediction_season),
      position = toupper(as.character(.data$position)),
      player = as.character(.data$player),
      team = normalize_team_abbr(as.character(.data$team)),
      note = dplyr::case_when(
        nzchar(.data$note) ~ .data$note,
        nzchar(.data$reason) ~ .data$reason,
        .data$adjustment_channel != "note_only" ~ paste(
          "Manual",
          .data$adjustment_channel,
          .data$direction,
          "adjustment"
        ),
        TRUE ~ .data$note
      ),
      adjustment_channel = .data$adjustment_channel,
      direction = .data$direction,
      magnitude = .data$magnitude,
      confidence = .data$confidence,
      reason = dplyr::if_else(nzchar(.data$reason), .data$reason, .data$note),
      source_type = .data$source_type,
      source_reference = .data$source_reference,
      enabled = .data$enabled
    )

  if (isTRUE(append_existing) && file.exists(output_path)) {
    existing <- utils::read.csv(output_path, stringsAsFactors = FALSE, check.names = FALSE)
    for (col in setdiff(sos_manual_context_columns(), names(existing))) existing[[col]] <- NA
    for (col in setdiff(sos_manual_context_columns(), names(context))) context[[col]] <- NA
    context <- dplyr::bind_rows(
      existing[, sos_manual_context_columns(), drop = FALSE],
      context[, sos_manual_context_columns(), drop = FALSE]
    )
  }

  context <- context |>
    dplyr::distinct(
      .data$prediction_season, .data$position, .data$player, .data$team,
      .data$note, .data$adjustment_channel, .data$direction,
      .data$magnitude, .data$confidence, .data$source_reference,
      .keep_all = TRUE
    )

  if (isTRUE(write_output)) {
    dir.create(dirname(output_path), recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(context, output_path, row.names = FALSE, na = "")
  }

  assign("sos_manual_context_from_seed_files", context, envir = .GlobalEnv)
  invisible(context)
}

read_sos_manual_context <- function(
    prediction_season = 2026L,
    path = sos_manual_context_path(prediction_season),
    create_if_missing = TRUE
) {
  if (!file.exists(path)) {
    if (!isTRUE(create_if_missing)) stop("Missing SOS manual context file: ", path, call. = FALSE)
    write_sos_manual_context_template(prediction_season, path)
  }
  context <- utils::read.csv(path, stringsAsFactors = FALSE, check.names = FALSE)
  missing <- setdiff(sos_manual_context_columns(), names(context))
  if (length(missing) > 0L) {
    stop("SOS manual context file is missing columns: ", paste(missing, collapse = ", "), call. = FALSE)
  }
  if (nrow(context) == 0L) {
    context$enabled_flag <- logical()
    context$player_key <- character()
    return(context)
  }

  context <- context |>
    dplyr::mutate(
      prediction_season = suppressWarnings(as.integer(.data$prediction_season)),
      position = toupper(trimws(as.character(.data$position))),
      player = trimws(as.character(.data$player)),
      player_key = make_player_key(.data$player),
      team = normalize_team_abbr(toupper(trimws(as.character(.data$team)))),
      note = dplyr::coalesce(trimws(as.character(.data$note)), ""),
      adjustment_channel = sos_normalize_manual_context_channel(.data$adjustment_channel),
      direction = tolower(trimws(as.character(.data$direction))),
      magnitude = sos_prob_num(.data$magnitude),
      confidence = sos_normalize_context_confidence(.data$confidence),
      source_type = dplyr::coalesce(trimws(as.character(.data$source_type)), "manual"),
      enabled_flag = sos_context_enabled(.data$enabled)
    ) |>
    dplyr::mutate(
      note = dplyr::if_else(
        !nzchar(.data$note) & .data$adjustment_channel != "note_only",
        paste("Manual", .data$adjustment_channel, .data$direction, "adjustment"),
        .data$note
      )
    ) |>
    dplyr::filter(.data$prediction_season == as.integer(.env$prediction_season))

  active <- context[context$enabled_flag, , drop = FALSE]
  if (nrow(active) == 0L) return(context)

  forbidden <- grepl("rank|omfg|final_score|board_score", active$adjustment_channel)
  if (any(forbidden)) {
    stop(
      "Manual context cannot directly adjust rank, OMFG, final_score, or board_score. Invalid rows: ",
      paste(which(forbidden), collapse = ", "),
      call. = FALSE
    )
  }
  invalid_channel <- !active$adjustment_channel %in% sos_manual_context_channels()
  if (any(invalid_channel)) {
    stop(
      "Unsupported manual adjustment channel(s): ",
      paste(unique(active$adjustment_channel[invalid_channel]), collapse = ", "),
      call. = FALSE
    )
  }
  if (any(!active$position %in% c("QB", "RB", "WR", "TE", "K", "DST"))) {
    stop("Manual context contains an unsupported position.", call. = FALSE)
  }
  if (any(!nzchar(active$player) | !nzchar(active$note) | !nzchar(active$source_type))) {
    stop("Every enabled context row requires player, note, and source_type.", call. = FALSE)
  }
  if (any(!active$direction %in% c("increase", "decrease", "neutral"))) {
    stop("Context direction must be increase, decrease, or neutral.", call. = FALSE)
  }
  if (any(!is.finite(active$confidence) | active$confidence < 0 | active$confidence > 1)) {
    stop("Context confidence must be between 0 and 1.", call. = FALSE)
  }
  non_note <- active$adjustment_channel != "note_only"
  if (any(non_note & !is.finite(active$magnitude))) {
    stop("Every enabled adjustment row requires a finite magnitude.", call. = FALSE)
  }
  games_channel <- active$adjustment_channel %in% c(
    "projected_games", "active_games", "games_started_distribution"
  )
  if (any(games_channel & abs(active$magnitude) > 8)) {
    stop("Manual games adjustments are limited to 8 games in either direction.", call. = FALSE)
  }
  if (any(!games_channel & non_note & abs(active$magnitude) > 1)) {
    stop("Non-games manual magnitudes must be expressed as fractions between 0 and 1.", call. = FALSE)
  }
  context
}

sos_projection_history <- function(position) {
  position <- toupper(position)
  path <- file.path(
    model_paths$sos_output_dir,
    paste0(tolower(position), "_sos_final_export_2022_2025.csv")
  )
  if (!file.exists(path)) stop("Missing SOS projection history: ", path, call. = FALSE)
  x <- utils::read.csv(path, stringsAsFactors = FALSE, check.names = FALSE) |>
    sos_standardize_probability_input(position)

  if (position == "DST") {
    if (!"anchor_ppg" %in% names(x)) x$anchor_ppg <- x$dst_sos_projected_ppg
    if (!"anchor_total_points" %in% names(x)) {
      x$anchor_total_points <- x$dst_sos_projected_total_points
    }
  }
  required <- c("anchor_ppg", "anchor_total_points")
  missing <- setdiff(required, names(x))
  if (length(missing) > 0L) {
    stop(position, " projection history is missing: ", paste(missing, collapse = ", "), call. = FALSE)
  }

  x |>
    sos_prob_collapse_player_seasons() |>
    dplyr::mutate(
      position = position,
      season = suppressWarnings(as.integer(.data$season)),
      rank = sos_prob_num(.data$rank),
      anchor_ppg = sos_prob_num(.data$anchor_ppg),
      anchor_total_points = sos_prob_num(.data$anchor_total_points),
      final_score = sos_prob_num(.data$final_score),
      board_score = sos_prob_num(.data$board_score),
      official_omfg = dplyr::if_else(
        is.finite(sos_prob_num(.data$preseason_omfg)),
        sos_prob_num(.data$preseason_omfg),
        sos_prob_num(.data$final_score)
      ),
      actual_next_ppg = sos_prob_num(.data$actual_next_ppg),
      actual_next_total_points = sos_prob_num(.data$actual_next_total_points)
    ) |>
    dplyr::group_by(.data$season) |>
    dplyr::mutate(
      field_size = dplyr::n(),
      omfg_rank = rank(-.data$official_omfg, ties.method = "first", na.last = "keep")
    ) |>
    dplyr::mutate(
      probability_rank = dplyr::if_else(
        is.finite(.data$omfg_rank),
        .data$omfg_rank,
        .data$rank
      )
    ) |>
    dplyr::mutate(
      rank_score_0to100 = sos_prob_rank_score(.data$probability_rank, .data$field_size)
    ) |>
    dplyr::ungroup()
}

sos_projection_linear_predict <- function(train, test, target_col, anchor_col) {
  target <- sos_prob_num(train[[target_col]])
  predictor_cols <- c(anchor_col, "final_score", "board_score", "official_omfg", "rank_score_0to100")
  train_model <- data.frame(target = target)
  test_model <- data.frame(row_id = seq_len(nrow(test)))

  for (predictor in predictor_cols) {
    train_values <- sos_prob_num(train[[predictor]])
    test_values <- sos_prob_num(test[[predictor]])
    fill <- stats::median(train_values[is.finite(train_values)], na.rm = TRUE)
    if (!is.finite(fill)) fill <- 50
    train_values[!is.finite(train_values)] <- fill
    test_values[!is.finite(test_values)] <- fill
    train_model[[predictor]] <- train_values
    test_model[[predictor]] <- test_values
  }

  keep <- is.finite(train_model$target) & is.finite(train_model[[anchor_col]])
  fallback <- sos_prob_num(test[[anchor_col]])
  if (sum(keep) < 25L) return(pmax(0, fallback))

  fit <- try(
    suppressWarnings(stats::lm(
      stats::reformulate(predictor_cols, response = "target"),
      data = train_model[keep, , drop = FALSE]
    )),
    silent = TRUE
  )
  prediction <- if (inherits(fit, "try-error")) {
    fallback
  } else {
    candidate <- try(suppressWarnings(stats::predict(fit, newdata = test_model)), silent = TRUE)
    if (inherits(candidate, "try-error")) fallback else as.numeric(candidate)
  }
  prediction[!is.finite(prediction)] <- fallback[!is.finite(prediction)]
  historical_upper <- stats::quantile(target[keep], 0.99, na.rm = TRUE, names = FALSE)
  if (!is.finite(historical_upper) || historical_upper <= 0) historical_upper <- max(target[keep], na.rm = TRUE)
  pmin(pmax(0, prediction), historical_upper * 1.25)
}

sos_projection_candidates <- function(train, test, target_col, anchor_col) {
  anchor <- pmax(0, sos_prob_num(test[[anchor_col]]))
  linear <- sos_projection_linear_predict(train, test, target_col, anchor_col)
  list(
    anchor = anchor,
    linear = linear,
    blend_70_linear_30_anchor = 0.70 * linear + 0.30 * anchor
  )
}

build_core_sos_projection_backtest <- function(
    positions = c("QB", "RB", "WR", "TE", "K", "DST")
) {
  load_model_core_packages()
  prediction_rows <- list()
  idx <- 1L
  target_specs <- list(
    ppg = c(target = "actual_next_ppg", anchor = "anchor_ppg"),
    total = c(target = "actual_next_total_points", anchor = "anchor_total_points")
  )

  for (position in toupper(positions)) {
    frame <- sos_projection_history(position)
    seasons <- sort(unique(frame$season[is.finite(frame$season)]))
    for (test_season in seasons[seasons > min(seasons)]) {
      train <- frame[frame$season < test_season, , drop = FALSE]
      test <- frame[frame$season == test_season, , drop = FALSE]
      if (nrow(train) == 0L || nrow(test) == 0L) next
      for (target_name in names(target_specs)) {
        spec <- target_specs[[target_name]]
        candidates <- sos_projection_candidates(train, test, spec[["target"]], spec[["anchor"]])
        for (candidate in names(candidates)) {
          prediction_rows[[idx]] <- data.frame(
            position = position,
            target = target_name,
            test_season = test_season,
            train_seasons = paste(sort(unique(train$season)), collapse = ","),
            candidate = candidate,
            player_key = make_player_key(test$player),
            player = test$player,
            prediction = sos_prob_num(candidates[[candidate]]),
            actual = sos_prob_num(test[[spec[["target"]]]]),
            stringsAsFactors = FALSE
          )
          idx <- idx + 1L
        }
      }
    }
  }

  predictions <- dplyr::bind_rows(prediction_rows) |>
    dplyr::filter(is.finite(.data$prediction), is.finite(.data$actual))
  metric_groups <- split(
    predictions,
    interaction(predictions$position, predictions$target, predictions$candidate, drop = TRUE)
  )
  metrics <- dplyr::bind_rows(lapply(metric_groups, function(x) {
    data.frame(
      position = x$position[1],
      target = x$target[1],
      candidate = x$candidate[1],
      test_seasons = paste(sort(unique(x$test_season)), collapse = ","),
      n = nrow(x),
      mae = mean(abs(x$prediction - x$actual)),
      rmse = sqrt(mean((x$prediction - x$actual)^2)),
      spearman = suppressWarnings(stats::cor(x$prediction, x$actual, method = "spearman")),
      stringsAsFactors = FALSE
    )
  })) |>
    dplyr::arrange(.data$position, .data$target, .data$mae, .data$rmse)
  selection <- metrics |>
    dplyr::group_by(.data$position, .data$target) |>
    dplyr::slice_min(.data$mae, n = 1L, with_ties = FALSE) |>
    dplyr::ungroup() |>
    dplyr::mutate(selected = TRUE)

  list(predictions = predictions, metrics = metrics, selection = selection)
}

sos_projection_residual_profile <- function(backtest) {
  selected_predictions <- backtest$predictions |>
    dplyr::inner_join(
      dplyr::select(backtest$selection, "position", "target", "candidate"),
      by = c("position", "target", "candidate"),
      relationship = "many-to-one"
    ) |>
    dplyr::filter(.data$target == "total", .data$prediction > 0) |>
    dplyr::mutate(ratio = .data$actual / .data$prediction)

  selected_predictions |>
    dplyr::group_by(.data$position) |>
    dplyr::summarise(
      residual_rows = dplyr::n(),
      ratio_p10 = pmin(0.90, pmax(0.10, stats::quantile(.data$ratio, 0.10, na.rm = TRUE, names = FALSE))),
      ratio_p25 = pmin(0.98, pmax(0.25, stats::quantile(.data$ratio, 0.25, na.rm = TRUE, names = FALSE))),
      ratio_p75 = pmax(1.02, pmin(2.00, stats::quantile(.data$ratio, 0.75, na.rm = TRUE, names = FALSE))),
      ratio_p90 = pmax(1.10, pmin(3.00, stats::quantile(.data$ratio, 0.90, na.rm = TRUE, names = FALSE))),
      historical_outcome_ceiling = 1.05 * max(.data$actual, na.rm = TRUE),
      .groups = "drop"
    )
}

sos_build_unadjusted_projection_board <- function(master, backtest, prediction_season) {
  histories <- lapply(unique(as.character(master$position)), sos_projection_history)
  names(histories) <- unique(as.character(master$position))
  residual_profile <- sos_projection_residual_profile(backtest)
  rows <- list()

  for (position in unique(as.character(master$position))) {
    historical <- histories[[position]]
    future <- master[master$position == position, , drop = FALSE] |>
      dplyr::mutate(
        official_omfg = dplyr::if_else(
          is.finite(sos_prob_num(.data$preseason_omfg)),
          sos_prob_num(.data$preseason_omfg),
          sos_prob_num(.data$final_score)
        ),
        field_size = dplyr::n(),
        omfg_rank = rank(-.data$official_omfg, ties.method = "first", na.last = "keep")
      ) |>
      dplyr::mutate(
      probability_rank = dplyr::if_else(
        is.finite(.data$omfg_rank),
        .data$omfg_rank,
        .data$rank
      )
    ) |>
      dplyr::mutate(
        rank_score_0to100 = sos_prob_rank_score(.data$probability_rank, .data$field_size)
      )
    selected_ppg <- backtest$selection |>
      dplyr::filter(.data$position == .env$position, .data$target == "ppg") |>
      dplyr::pull(.data$candidate)
    selected_total <- backtest$selection |>
      dplyr::filter(.data$position == .env$position, .data$target == "total") |>
      dplyr::pull(.data$candidate)
    ppg_candidates <- sos_projection_candidates(
      historical, future, "actual_next_ppg", "anchor_ppg"
    )
    total_candidates <- sos_projection_candidates(
      historical, future, "actual_next_total_points", "anchor_total_points"
    )
    ppg_model <- if (length(selected_ppg) == 1L) selected_ppg[[1]] else "anchor"
    total_model <- if (length(selected_total) == 1L) selected_total[[1]] else "anchor"
    projected_ppg <- ppg_candidates[[ppg_model]]
    projected_total <- total_candidates[[total_model]]
    implied_games <- ifelse(projected_ppg > 0, projected_total / projected_ppg, NA_real_)
    anchor_games <- ifelse(
      sos_prob_num(future$anchor_ppg) > 0,
      sos_prob_num(future$anchor_total_points) / sos_prob_num(future$anchor_ppg),
      NA_real_
    )
    projected_games <- pmin(
      17,
      pmax(1, dplyr::coalesce(implied_games, anchor_games, rep(17, nrow(future))))
    )
    projected_total <- pmax(0, projected_ppg * projected_games)

    rows[[position]] <- future |>
      dplyr::mutate(
        prediction_season = as.integer(.env$prediction_season),
        player_key = make_player_key(.data$player),
        omfg_before_manual = .data$official_omfg,
        omfg_after_manual = .data$official_omfg,
        projection_model_ppg = .env$ppg_model,
        projection_model_total = .env$total_model,
        baseline_projected_games = .env$projected_games,
        baseline_projected_ppg = .env$projected_ppg,
        baseline_p50_points = .env$projected_total
      ) |>
      dplyr::left_join(residual_profile, by = "position", relationship = "many-to-one") |>
      dplyr::mutate(
        baseline_uncertainty_multiplier = pmin(
          1.50,
          pmax(1, 1 + (17 - .data$baseline_projected_games) / 34)
        ),
        baseline_p10_points = pmax(
          0,
          .data$baseline_p50_points * (
            1 - (1 - .data$ratio_p10) * .data$baseline_uncertainty_multiplier
          )
        ),
        baseline_p25_points = pmax(
          .data$baseline_p10_points,
          .data$baseline_p50_points * (
            1 - (1 - .data$ratio_p25) * .data$baseline_uncertainty_multiplier
          )
        ),
        baseline_p75_points = pmin(
          .data$historical_outcome_ceiling,
          pmax(
            .data$baseline_p50_points,
            .data$baseline_p50_points * (
              1 + (.data$ratio_p75 - 1) * .data$baseline_uncertainty_multiplier
            )
          )
        ),
        baseline_p90_points = pmin(
          .data$historical_outcome_ceiling,
          pmax(
            .data$baseline_p75_points,
            .data$baseline_p50_points * (
              1 + (.data$ratio_p90 - 1) * .data$baseline_uncertainty_multiplier
            )
          )
        ),
        baseline_average_range_score = (
          .data$baseline_p25_points + .data$baseline_p50_points + .data$baseline_p75_points
        ) / 3
      )
  }

  dplyr::bind_rows(rows) |>
    dplyr::group_by(.data$position) |>
    dplyr::mutate(
      baseline_projection_rank = rank(
        -.data$baseline_average_range_score,
        ties.method = "first",
        na.last = "keep"
      ),
      baseline_model_rank = rank(
        -.data$official_omfg,
        ties.method = "first",
        na.last = "keep"
      )
    ) |>
    dplyr::ungroup()
}

sos_context_summary <- function(context) {
  active <- context[context$enabled_flag, , drop = FALSE]
  if (nrow(active) == 0L) {
    return(data.frame(
      position = character(), player_key = character(), context_adjustment_count = integer(),
      manual_team_override = character(),
      manual_context_note = character(), manual_games_delta = double(),
      manual_central_pct = double(), manual_injury_risk = double(),
      manual_uncertainty_pct = double(), manual_p10_pct = double(),
      manual_p25_pct = double(), manual_p50_pct = double(),
      manual_p75_pct = double(), manual_p90_pct = double(),
      stringsAsFactors = FALSE
    ))
  }

  games_channels <- c("projected_games", "active_games", "games_started_distribution")
  central_channels <- c(
    "starter_probability", "role_share", "target_share", "carry_share",
    "opportunity_share", "route_share", "first_read_share", "end_zone_share",
    "passing_volume", "rushing_volume", "passing_touchdowns", "efficiency", "touchdown_environment",
    "quarterback_playcaller_effect", "team_environment", "mobility", "role_transfer_path"
  )
  active <- active |>
    dplyr::mutate(
      direction_sign = dplyr::case_when(
        .data$direction == "increase" ~ 1,
        .data$direction == "decrease" ~ -1,
        TRUE ~ 0
      ),
      weighted_magnitude = .data$direction_sign * abs(.data$magnitude) * .data$confidence
    )

  active |>
    dplyr::group_by(.data$position, .data$player_key) |>
    dplyr::summarise(
      context_adjustment_count = dplyr::n(),
      manual_team_override = {
        supplied_teams <- unique(.data$team[nzchar(.data$team)])
        if (length(supplied_teams) > 0L) supplied_teams[[length(supplied_teams)]] else ""
      },
      manual_context_note = paste(unique(.data$note[nzchar(.data$note)]), collapse = " | "),
      manual_games_delta = sum(dplyr::if_else(.data$adjustment_channel %in% games_channels, .data$weighted_magnitude, 0)),
      manual_central_pct = sum(dplyr::if_else(.data$adjustment_channel %in% central_channels, .data$weighted_magnitude, 0)),
      manual_injury_risk = sum(dplyr::if_else(.data$adjustment_channel == "injury_risk", .data$weighted_magnitude, 0)),
      manual_uncertainty_pct = sum(dplyr::if_else(.data$adjustment_channel == "uncertainty_width", .data$weighted_magnitude, 0)),
      manual_p10_pct = sum(dplyr::if_else(.data$adjustment_channel == "p10_modifier", .data$weighted_magnitude, 0)),
      manual_p25_pct = sum(dplyr::if_else(.data$adjustment_channel == "p25_modifier", .data$weighted_magnitude, 0)),
      manual_p50_pct = sum(dplyr::if_else(.data$adjustment_channel == "p50_modifier", .data$weighted_magnitude, 0)),
      manual_p75_pct = sum(dplyr::if_else(.data$adjustment_channel == "p75_modifier", .data$weighted_magnitude, 0)),
      manual_p90_pct = sum(dplyr::if_else(.data$adjustment_channel == "p90_modifier", .data$weighted_magnitude, 0)),
      .groups = "drop"
    )
}

sos_enforce_projection_ranges <- function(df, cols) {
  adjusted <- t(apply(as.matrix(df[cols]), 1L, function(values) {
    values <- sos_prob_num(values)
    if (all(!is.finite(values))) return(values)
    finite <- is.finite(values)
    values[!finite] <- stats::median(values[finite], na.rm = TRUE)
    pmax(0, stats::isoreg(seq_along(values), values)$yf)
  }))
  df[cols] <- adjusted
  df
}

sos_projection_range_sanity_limits <- function(position, projected_games, p50_points) {
  position <- toupper(as.character(position))
  projected_games <- sos_prob_num(projected_games)
  p50_points <- sos_prob_num(p50_points)
  n <- length(position)

  limits <- data.frame(
    range_sanity_min_p10_ratio = rep(0.05, n),
    range_sanity_min_p25_ratio = rep(0.25, n),
    range_sanity_max_p75_ratio = rep(2.00, n),
    range_sanity_max_p90_ratio = rep(3.00, n),
    stringsAsFactors = FALSE
  )

  starter <- is.finite(projected_games) & projected_games >= 14
  rotation <- is.finite(projected_games) & projected_games >= 10 & projected_games < 14
  partial <- is.finite(projected_games) & projected_games >= 6 & projected_games < 10
  reserve <- !is.finite(projected_games) | projected_games < 6

  qb <- position == "QB"
  limits[qb & starter, ] <- list(0.45, 0.70, 1.25, 1.55)
  limits[qb & rotation, ] <- list(0.25, 0.55, 1.40, 1.85)
  limits[qb & partial, ] <- list(0.10, 0.35, 1.65, 2.35)
  limits[qb & reserve, ] <- list(0.03, 0.18, 2.00, 3.00)

  flex <- position %in% c("RB", "WR", "TE")
  limits[flex & starter, ] <- list(0.25, 0.55, 1.50, 2.00)
  limits[flex & rotation, ] <- list(0.12, 0.40, 1.75, 2.50)
  limits[flex & partial, ] <- list(0.05, 0.25, 2.25, 3.25)
  limits[flex & reserve, ] <- list(0.01, 0.10, 3.00, 4.00)

  k <- position == "K"
  limits[k & starter, ] <- list(0.45, 0.70, 1.20, 1.45)
  limits[k & rotation, ] <- list(0.30, 0.55, 1.35, 1.70)
  limits[k & partial, ] <- list(0.12, 0.30, 1.80, 2.40)
  limits[k & reserve, ] <- list(0.05, 0.15, 2.25, 3.00)

  dst <- position == "DST"
  limits[dst, ] <- list(0.60, 0.78, 1.18, 1.35)

  high_median_qb <- qb & is.finite(p50_points) & p50_points >= 175
  limits$range_sanity_min_p10_ratio[high_median_qb] <- pmax(
    limits$range_sanity_min_p10_ratio[high_median_qb],
    0.40
  )
  limits$range_sanity_max_p90_ratio[high_median_qb] <- pmin(
    limits$range_sanity_max_p90_ratio[high_median_qb],
    1.60
  )

  limits
}

sos_apply_projection_range_sanity <- function(board) {
  required <- c(
    "position", "adjusted_projected_games", "adjusted_p10_points",
    "adjusted_p25_points", "adjusted_p50_points", "adjusted_p75_points",
    "adjusted_p90_points"
  )
  missing <- setdiff(required, names(board))
  if (length(missing) > 0L) {
    stop("Projection range sanity is missing required columns: ", paste(missing, collapse = ", "), call. = FALSE)
  }

  limits <- sos_projection_range_sanity_limits(
    board$position,
    board$adjusted_projected_games,
    board$adjusted_p50_points
  )
  qb_role_uncertainty <- toupper(as.character(board$position)) == "QB" &
    "projection_context_role_uncertainty" %in% names(board) &
    dplyr::coalesce(as.logical(board$projection_context_role_uncertainty), FALSE)
  qb_rookie_or_new <- toupper(as.character(board$position)) == "QB" &
    "projection_context_rookie_or_new" %in% names(board) &
    dplyr::coalesce(as.logical(board$projection_context_rookie_or_new), FALSE)
  qb_uncertain <- qb_role_uncertainty | qb_rookie_or_new
  if (any(qb_uncertain, na.rm = TRUE)) {
    limits$range_sanity_min_p10_ratio[qb_uncertain] <- pmax(
      limits$range_sanity_min_p10_ratio[qb_uncertain],
      0.12
    )
    limits$range_sanity_max_p90_ratio[qb_uncertain] <- pmin(
      limits$range_sanity_max_p90_ratio[qb_uncertain],
      2.00
    )
  }

  board <- board |>
    dplyr::select(-dplyr::any_of(names(limits)))
  out <- cbind(board, limits)
  out <- out |>
    dplyr::mutate(
      pre_range_sanity_p10_points = .data$adjusted_p10_points,
      pre_range_sanity_p25_points = .data$adjusted_p25_points,
      pre_range_sanity_p75_points = .data$adjusted_p75_points,
      pre_range_sanity_p90_points = .data$adjusted_p90_points,
      adjusted_p10_points = pmax(
        .data$adjusted_p10_points,
        .data$adjusted_p50_points * .data$range_sanity_min_p10_ratio
      ),
      adjusted_p25_points = pmax(
        .data$adjusted_p25_points,
        .data$adjusted_p50_points * .data$range_sanity_min_p25_ratio
      ),
      adjusted_p75_points = pmin(
        .data$adjusted_p75_points,
        .data$adjusted_p50_points * .data$range_sanity_max_p75_ratio
      ),
      adjusted_p90_points = pmin(
        .data$adjusted_p90_points,
        .data$adjusted_p50_points * .data$range_sanity_max_p90_ratio
      )
    )

  out <- sos_enforce_projection_ranges(
    out,
    c(
      "adjusted_p10_points", "adjusted_p25_points", "adjusted_p50_points",
      "adjusted_p75_points", "adjusted_p90_points"
    )
  )

  out |>
    dplyr::mutate(
      range_sanity_applied =
        abs(.data$adjusted_p10_points - .data$pre_range_sanity_p10_points) > 1e-8 |
        abs(.data$adjusted_p25_points - .data$pre_range_sanity_p25_points) > 1e-8 |
        abs(.data$adjusted_p75_points - .data$pre_range_sanity_p75_points) > 1e-8 |
        abs(.data$adjusted_p90_points - .data$pre_range_sanity_p90_points) > 1e-8,
      adjusted_average_range_score = (
        .data$adjusted_p25_points + .data$adjusted_p50_points + .data$adjusted_p75_points
      ) / 3
    ) |>
    dplyr::group_by(.data$position) |>
    dplyr::mutate(
      manual_adjusted_projection_rank = rank(
        -.data$adjusted_average_range_score,
        ties.method = "first",
        na.last = "keep"
      ),
      manual_adjusted_projection_rank_delta =
        .data$baseline_projection_rank - .data$manual_adjusted_projection_rank
    ) |>
    dplyr::ungroup()
}

build_core_sos_range_sanity_audit <- function(board, prediction_season = 2026L) {
  load_model_core_packages()
  if (!"range_sanity_applied" %in% names(board)) {
    return(data.frame(
      position = sort(unique(as.character(board$position))),
      prediction_season = as.integer(prediction_season[[1]]),
      rows = as.integer(tabulate(match(sort(unique(as.character(board$position))), sort(unique(as.character(board$position)))))),
      range_sanity_rows = 0L,
      max_p10_delta = 0,
      max_p90_delta = 0,
      status = "PASS",
      stringsAsFactors = FALSE
    ))
  }
  board |>
    dplyr::group_by(.data$position) |>
    dplyr::summarise(
      prediction_season = as.integer(.env$prediction_season[[1]]),
      rows = dplyr::n(),
      range_sanity_rows = sum(.data$range_sanity_applied, na.rm = TRUE),
      max_p10_delta = max(abs(.data$adjusted_p10_points - .data$pre_range_sanity_p10_points), na.rm = TRUE),
      max_p90_delta = max(abs(.data$adjusted_p90_points - .data$pre_range_sanity_p90_points), na.rm = TRUE),
      status = "PASS",
      .groups = "drop"
    ) |>
    dplyr::arrange(.data$position)
}

sos_extract_context_start_cap <- function(note) {
  note <- tolower(as.character(note))
  out <- rep(NA_real_, length(note))
  hit <- regexpr("\\b([0-9]{1,2})\\s+(projected\\s+)?starts?\\b", note, perl = TRUE)
  has_hit <- hit > 0
  if (any(has_hit)) {
    matched <- regmatches(note, hit)
    out[has_hit] <- suppressWarnings(as.numeric(sub("^.*?([0-9]{1,2}).*$", "\\1", matched)))
  }
  out
}

sos_apply_projection_context_calibration <- function(board) {
  required <- c(
    "position", "manual_adjusted_projection_rank", "adjusted_projected_games",
    "adjusted_projected_ppg", "adjusted_p10_points", "adjusted_p25_points",
    "adjusted_p50_points", "adjusted_p75_points", "adjusted_p90_points"
  )
  missing <- setdiff(required, names(board))
  if (length(missing) > 0L) {
    stop("Projection context calibration is missing required columns: ", paste(missing, collapse = ", "), call. = FALSE)
  }

  if ("projection_context_applied" %in% names(board)) {
    return(board)
  }

  restore_cols <- c(
    "pre_projection_context_projected_games", "pre_projection_context_projected_ppg",
    "pre_projection_context_p10_points", "pre_projection_context_p25_points",
    "pre_projection_context_p50_points", "pre_projection_context_p75_points",
    "pre_projection_context_p90_points"
  )
  if (all(restore_cols %in% names(board))) {
    board$adjusted_projected_games <- board$pre_projection_context_projected_games
    board$adjusted_projected_ppg <- board$pre_projection_context_projected_ppg
    board$adjusted_p10_points <- board$pre_projection_context_p10_points
    board$adjusted_p25_points <- board$pre_projection_context_p25_points
    board$adjusted_p50_points <- board$pre_projection_context_p50_points
    board$adjusted_p75_points <- board$pre_projection_context_p75_points
    board$adjusted_p90_points <- board$pre_projection_context_p90_points
  }
  board <- board |>
    dplyr::select(
      -dplyr::matches("^pre_projection_context_"),
      -dplyr::matches("^projection_context_")
    )

  if (!"market_position_rank" %in% names(board)) board$market_position_rank <- NA_real_
  if (!"is_2026_rookie" %in% names(board)) board$is_2026_rookie <- 0
  if (!"is_new_to_sos_pool" %in% names(board)) board$is_new_to_sos_pool <- 0
  if (!"depth_team_2026" %in% names(board)) board$depth_team_2026 <- NA_real_
  if (!"manual_context_note" %in% names(board)) board$manual_context_note <- ""
  if (!"context_adjustment_count" %in% names(board)) board$context_adjustment_count <- 0

  note <- tolower(as.character(board$manual_context_note))
  note[is.na(note)] <- ""
  role_uncertainty_note <- grepl(
    paste(
      c(
        "not named", "competition", "competing", "backup", "partial", "committee",
        "rookie inflation", "inflated", "cousins", "year 1 starter",
        "beginning of the season", "bridge", "could start", "may start",
        "may not start", "not clear", "stash"
      ),
      collapse = "|"
    ),
    note
  )
  starter_context_note <- grepl(
    paste(c("locked starter", "named starter", "starting qb", "starter for", "lead back", "clear starter"), collapse = "|"),
    note
  ) & !role_uncertainty_note

  context_start_cap <- sos_extract_context_start_cap(note)
  market_rank <- sos_prob_num(board$market_position_rank)
  projection_rank <- sos_prob_num(board$manual_adjusted_projection_rank)
  market_gap <- projection_rank - market_rank
  has_market <- is.finite(market_rank)
  model_much_higher_than_market <- has_market & is.finite(market_gap) & market_gap <= -10
  market_much_higher_than_model <- has_market & is.finite(market_gap) & market_gap >= 10
  no_market_high_projection <- !has_market & is.finite(projection_rank) & (
    (board$position == "QB" & projection_rank <= 24) |
      (board$position %in% c("RB", "WR") & projection_rank <= 48) |
      (board$position == "TE" & projection_rank <= 24) |
      (board$position == "K" & projection_rank <= 18)
  )

  rookie_or_new <- dplyr::coalesce(sos_prob_num(board$is_2026_rookie), 0) > 0 |
    dplyr::coalesce(sos_prob_num(board$is_new_to_sos_pool), 0) > 0
  depth_num <- sos_prob_num(board$depth_team_2026)
  depth_uncertain <- is.finite(depth_num) & (
    (board$position == "QB" & depth_num > 1) |
      (board$position %in% c("RB", "TE", "K") & depth_num > 1) |
      (board$position == "WR" & depth_num > 2)
  )

  market_ppg_pct <- dplyr::case_when(
    market_much_higher_than_model ~ pmin(0.08, market_gap * 0.0025),
    model_much_higher_than_market ~ pmax(-0.14, market_gap * 0.0030),
    TRUE ~ 0
  )
  market_games_delta <- dplyr::case_when(
    market_much_higher_than_model ~ pmin(0.75, market_gap * 0.025),
    model_much_higher_than_market ~ pmax(-1.50, market_gap * 0.035),
    TRUE ~ 0
  )

  uncertainty_ppg_pct <- dplyr::case_when(
    board$position == "QB" & role_uncertainty_note & rookie_or_new ~ -0.12,
    board$position == "QB" & role_uncertainty_note ~ -0.08,
    role_uncertainty_note & rookie_or_new ~ -0.07,
    role_uncertainty_note ~ -0.04,
    no_market_high_projection & rookie_or_new ~ -0.06,
    no_market_high_projection ~ -0.03,
    starter_context_note & market_much_higher_than_model ~ 0.03,
    TRUE ~ 0
  )
  uncertainty_games_delta <- dplyr::case_when(
    board$position == "QB" & role_uncertainty_note & rookie_or_new ~ -2.50,
    board$position == "QB" & role_uncertainty_note ~ -1.75,
    role_uncertainty_note & rookie_or_new ~ -1.25,
    role_uncertainty_note ~ -0.75,
    no_market_high_projection & rookie_or_new ~ -0.75,
    no_market_high_projection ~ -0.35,
    starter_context_note & market_much_higher_than_model ~ 0.35,
    TRUE ~ 0
  )
  depth_games_delta <- dplyr::case_when(
    depth_uncertain & board$position == "QB" ~ -1.00,
    depth_uncertain & board$position %in% c("RB", "WR", "TE") ~ -0.50,
    depth_uncertain & board$position == "K" ~ -1.00,
    TRUE ~ 0
  )

  ppg_pct <- pmin(0.10, pmax(-0.18, market_ppg_pct + uncertainty_ppg_pct))
  games_delta <- pmin(1.00, pmax(-3.50, market_games_delta + uncertainty_games_delta + depth_games_delta))
  games_cap <- dplyr::case_when(
    is.finite(context_start_cap) & board$position == "QB" ~ pmin(17, pmax(1, context_start_cap + 1)),
    is.finite(context_start_cap) ~ pmin(17, pmax(1, context_start_cap + 2)),
    TRUE ~ NA_real_
  )

  out <- board |>
    dplyr::mutate(
      pre_projection_context_projected_games = .data$adjusted_projected_games,
      pre_projection_context_projected_ppg = .data$adjusted_projected_ppg,
      pre_projection_context_p10_points = .data$adjusted_p10_points,
      pre_projection_context_p25_points = .data$adjusted_p25_points,
      pre_projection_context_p50_points = .data$adjusted_p50_points,
      pre_projection_context_p75_points = .data$adjusted_p75_points,
      pre_projection_context_p90_points = .data$adjusted_p90_points,
      projection_context_market_gap = .env$market_gap,
      projection_context_role_uncertainty = .env$role_uncertainty_note,
      projection_context_rookie_or_new = .env$rookie_or_new,
      projection_context_depth_uncertain = .env$depth_uncertain,
      projection_context_start_cap = .env$games_cap,
      projection_context_ppg_pct = .env$ppg_pct,
      projection_context_games_delta = .env$games_delta,
      adjusted_projected_games = pmin(
        17,
        pmax(1, .data$adjusted_projected_games + .env$games_delta)
      ),
      adjusted_projected_games = dplyr::if_else(
        is.finite(.env$games_cap),
        pmin(.data$adjusted_projected_games, .env$games_cap),
        .data$adjusted_projected_games
      ),
      adjusted_projected_ppg = pmax(0, .data$adjusted_projected_ppg * (1 + .env$ppg_pct)),
      projection_context_applied =
        abs(.data$adjusted_projected_games - .data$pre_projection_context_projected_games) > 1e-8 |
        abs(.data$adjusted_projected_ppg - .data$pre_projection_context_projected_ppg) > 1e-8,
      adjusted_p50_points = dplyr::if_else(
        .data$projection_context_applied,
        pmax(0, .data$adjusted_projected_games * .data$adjusted_projected_ppg),
        .data$pre_projection_context_p50_points
      ),
      projection_context_points_multiplier = dplyr::if_else(
        .data$pre_projection_context_p50_points > 1e-6,
        .data$adjusted_p50_points / .data$pre_projection_context_p50_points,
        1
      ),
      adjusted_p10_points = pmax(0, .data$adjusted_p10_points * .data$projection_context_points_multiplier),
      adjusted_p25_points = pmax(0, .data$adjusted_p25_points * .data$projection_context_points_multiplier),
      adjusted_p75_points = pmax(0, .data$adjusted_p75_points * .data$projection_context_points_multiplier),
      adjusted_p90_points = pmax(0, .data$adjusted_p90_points * .data$projection_context_points_multiplier),
      projection_context_note = dplyr::case_when(
        .data$projection_context_applied & .data$projection_context_role_uncertainty ~ "manual_role_uncertainty_projection_context",
        .data$projection_context_applied & .env$model_much_higher_than_market ~ "market_lower_than_model_projection_context",
        .data$projection_context_applied & .env$market_much_higher_than_model ~ "market_higher_than_model_projection_context",
        .data$projection_context_applied & .env$no_market_high_projection ~ "no_market_high_projection_context",
        .data$projection_context_applied & .data$projection_context_depth_uncertain ~ "depth_uncertainty_projection_context",
        TRUE ~ "no_projection_context_change"
      )
    )

  out <- sos_enforce_projection_ranges(
    out,
    c(
      "adjusted_p10_points", "adjusted_p25_points", "adjusted_p50_points",
      "adjusted_p75_points", "adjusted_p90_points"
    )
  )

  out |>
    dplyr::mutate(
      adjusted_average_range_score = (
        .data$adjusted_p25_points + .data$adjusted_p50_points + .data$adjusted_p75_points
      ) / 3
    ) |>
    dplyr::group_by(.data$position) |>
    dplyr::mutate(
      manual_adjusted_projection_rank = rank(
        -.data$adjusted_average_range_score,
        ties.method = "first",
        na.last = "keep"
      ),
      manual_adjusted_projection_rank_delta =
        .data$baseline_projection_rank - .data$manual_adjusted_projection_rank
    ) |>
    dplyr::ungroup()
}

build_core_sos_projection_context_audit <- function(board, prediction_season = 2026L) {
  load_model_core_packages()
  if (!"projection_context_applied" %in% names(board)) {
    return(data.frame())
  }
  board |>
    dplyr::group_by(.data$position) |>
    dplyr::summarise(
      prediction_season = as.integer(.env$prediction_season[[1]]),
      rows = dplyr::n(),
      projection_context_rows = sum(.data$projection_context_applied, na.rm = TRUE),
      role_uncertainty_rows = sum(.data$projection_context_role_uncertainty, na.rm = TRUE),
      rookie_or_new_rows = sum(.data$projection_context_rookie_or_new, na.rm = TRUE),
      depth_uncertainty_rows = sum(.data$projection_context_depth_uncertain, na.rm = TRUE),
      max_abs_games_delta = max(abs(.data$adjusted_projected_games - .data$pre_projection_context_projected_games), na.rm = TRUE),
      max_abs_ppg_delta = max(abs(.data$adjusted_projected_ppg - .data$pre_projection_context_projected_ppg), na.rm = TRUE),
      status = "PASS",
      .groups = "drop"
    ) |>
    dplyr::arrange(.data$position)
}

sos_apply_manual_context <- function(board, context) {
  active <- context[context$enabled_flag, , drop = FALSE]
  if (nrow(active) > 0L) {
    board_keys <- board |>
      dplyr::distinct(.data$position, .data$player_key, .data$current_team, .data$next_team)
    matched <- active |>
      dplyr::left_join(
        dplyr::mutate(board_keys, matched = TRUE),
        by = c("position", "player_key"),
        relationship = "many-to-one"
      )
    if (any(is.na(matched$matched))) {
      unknown <- paste(unique(paste(matched$position[is.na(matched$matched)], matched$player[is.na(matched$matched)], sep = ": ")), collapse = ", ")
      stop("Enabled manual context rows do not match the 2026 board: ", unknown, call. = FALSE)
    }
    supplied_team <- nzchar(active$team)
    valid_team <- !supplied_team |
      active$team == matched$current_team |
      active$team == matched$next_team
    # A supplied manual team can intentionally update stale roster/team context
    # while keeping the context keyed to the same player.
  }

  summary <- sos_context_summary(context)
  out <- board |>
    dplyr::left_join(summary, by = c("position", "player_key"), relationship = "one-to-one")
  numeric_defaults <- c(
    "context_adjustment_count", "manual_games_delta", "manual_central_pct",
    "manual_injury_risk", "manual_uncertainty_pct", "manual_p10_pct",
    "manual_p25_pct", "manual_p50_pct", "manual_p75_pct", "manual_p90_pct"
  )
  for (col in numeric_defaults) out[[col]] <- dplyr::coalesce(sos_prob_num(out[[col]]), 0)
  out$manual_team_override <- dplyr::coalesce(as.character(out$manual_team_override), "")
  out$manual_context_note <- dplyr::coalesce(as.character(out$manual_context_note), "")

  out <- out |>
    dplyr::mutate(
      current_team = dplyr::if_else(
        nzchar(.data$manual_team_override),
        .data$manual_team_override,
        as.character(.data$current_team)
      ),
      next_team = dplyr::if_else(
        nzchar(.data$manual_team_override),
        .data$manual_team_override,
        as.character(.data$next_team)
      ),
      manual_central_pct = pmin(0.50, pmax(-0.50, .data$manual_central_pct)),
      manual_games_delta = pmin(8, pmax(-8, .data$manual_games_delta)),
      manual_injury_risk = pmin(1, pmax(-1, .data$manual_injury_risk)),
      manual_uncertainty_pct = pmin(1.50, pmax(-0.50, .data$manual_uncertainty_pct)),
      adjusted_projected_games = pmin(
        17,
        pmax(1, .data$baseline_projected_games + .data$manual_games_delta)
      ),
      adjusted_projected_ppg = pmax(
        0,
        .data$baseline_projected_ppg * (
          1 + .data$manual_central_pct - 0.25 * pmax(.data$manual_injury_risk, 0)
        )
      ),
      adjusted_p50_points = pmax(
        0,
        .data$adjusted_projected_ppg * .data$adjusted_projected_games * (
          1 + pmin(0.50, pmax(-0.50, .data$manual_p50_pct))
        )
      ),
      manual_downside_width_multiplier = pmax(
        0.50,
        1 + .data$manual_uncertainty_pct + 0.75 * pmax(.data$manual_injury_risk, 0)
      ),
      manual_upside_width_multiplier = pmax(
        0.50,
        1 + .data$manual_uncertainty_pct - 0.25 * pmax(.data$manual_injury_risk, 0)
      ),
      adjusted_p10_points = pmax(
        0,
        .data$adjusted_p50_points * (
          1 - (1 - .data$baseline_p10_points / pmax(.data$baseline_p50_points, 1e-6)) *
            .data$manual_downside_width_multiplier
        ) * (1 + pmin(0.50, pmax(-0.50, .data$manual_p10_pct)))
      ),
      adjusted_p25_points = pmax(
        0,
        .data$adjusted_p50_points * (
          1 - (1 - .data$baseline_p25_points / pmax(.data$baseline_p50_points, 1e-6)) *
            .data$manual_downside_width_multiplier
        ) * (1 + pmin(0.50, pmax(-0.50, .data$manual_p25_pct)))
      ),
      adjusted_p75_points = pmax(
        0,
        .data$adjusted_p50_points * (
          1 + (.data$baseline_p75_points / pmax(.data$baseline_p50_points, 1e-6) - 1) *
            .data$manual_upside_width_multiplier
        ) * (1 + pmin(0.50, pmax(-0.50, .data$manual_p75_pct)))
      ),
      adjusted_p90_points = pmax(
        0,
        .data$adjusted_p50_points * (
          1 + (.data$baseline_p90_points / pmax(.data$baseline_p50_points, 1e-6) - 1) *
            .data$manual_upside_width_multiplier
        ) * (1 + pmin(0.50, pmax(-0.50, .data$manual_p90_pct)))
      )
    )
  # With no enabled manual rows, preserve the model baseline exactly. Rebuilding
  # P50 as games * PPG can otherwise introduce a synthetic adjustment when the
  # baseline was bounded or calibrated upstream.
  no_manual_context <- out$context_adjustment_count == 0L
  out$adjusted_projected_games[no_manual_context] <- out$baseline_projected_games[no_manual_context]
  out$adjusted_projected_ppg[no_manual_context] <- out$baseline_projected_ppg[no_manual_context]
  out$adjusted_p10_points[no_manual_context] <- out$baseline_p10_points[no_manual_context]
  out$adjusted_p25_points[no_manual_context] <- out$baseline_p25_points[no_manual_context]
  out$adjusted_p50_points[no_manual_context] <- out$baseline_p50_points[no_manual_context]
  out$adjusted_p75_points[no_manual_context] <- out$baseline_p75_points[no_manual_context]
  out$adjusted_p90_points[no_manual_context] <- out$baseline_p90_points[no_manual_context]
  out <- sos_enforce_projection_ranges(
    out,
    c(
      "adjusted_p10_points", "adjusted_p25_points", "adjusted_p50_points",
      "adjusted_p75_points", "adjusted_p90_points"
    )
  )
  out |>
    dplyr::mutate(
      adjusted_average_range_score = (
        .data$adjusted_p25_points + .data$adjusted_p50_points + .data$adjusted_p75_points
      ) / 3
    ) |>
    dplyr::group_by(.data$position) |>
    dplyr::mutate(
      manual_adjusted_projection_rank = rank(
        -.data$adjusted_average_range_score,
        ties.method = "first",
        na.last = "keep"
      ),
      manual_adjusted_model_rank = rank(
        -.data$official_omfg,
        ties.method = "first",
        na.last = "keep"
      ),
      manual_adjusted_rank_delta = .data$baseline_model_rank - .data$manual_adjusted_model_rank,
      manual_adjusted_projection_rank_delta = .data$baseline_projection_rank - .data$manual_adjusted_projection_rank
    ) |>
    dplyr::ungroup()
}

sos_simulate_projection_finishes <- function(
    board,
    prefix,
    p10_col,
    p50_col,
    p90_col,
    simulation_count = 4000L
) {
  simulation_count <- as.integer(simulation_count[[1]])
  if (!is.finite(simulation_count) || simulation_count < 500L) {
    stop("simulation_count must be at least 500.", call. = FALSE)
  }
  rows <- list()
  for (position in unique(as.character(board$position))) {
    x <- board[board$position == position, , drop = FALSE]
    p10 <- sos_prob_num(x[[p10_col]])
    p50 <- sos_prob_num(x[[p50_col]])
    p90 <- sos_prob_num(x[[p90_col]])
    lower_sd <- pmax(0.01, (p50 - p10) / 1.281551566)
    upper_sd <- pmax(0.01, (p90 - p50) / 1.281551566)
    set.seed(202600L + match(position, c("QB", "RB", "WR", "TE", "K", "DST")))
    z <- matrix(stats::rnorm(nrow(x) * simulation_count), nrow = nrow(x))
    simulations <- ifelse(
      z < 0,
      p50 + z * lower_sd,
      p50 + z * upper_sd
    )
    simulations <- matrix(
      pmax(0, simulations),
      nrow = nrow(x),
      ncol = simulation_count
    )
    simulated_ranks <- apply(
      simulations,
      2L,
      function(values) rank(-values, ties.method = "average", na.last = "keep")
    )
    thresholds <- sos_prob_targets(position)
    for (target_name in names(thresholds)) {
      x[[paste0(prefix, "_sim_prob_", target_name)]] <- rowMeans(
        simulated_ranks <= thresholds[[target_name]],
        na.rm = TRUE
      )
    }
    rows[[position]] <- x
  }
  dplyr::bind_rows(rows)
}

sos_build_context_ledger <- function(context, board, prediction_season) {
  active <- context[context$enabled_flag, , drop = FALSE]
  if (nrow(active) == 0L) {
    ledger <- context
    ledger$before_projected_games <- numeric()
    ledger$after_projected_games <- numeric()
    ledger$before_p50_points <- numeric()
    ledger$after_p50_points <- numeric()
    ledger$before_model_rank <- numeric()
    ledger$after_model_rank <- numeric()
    ledger$before_projection_rank <- numeric()
    ledger$after_projection_rank <- numeric()
    ledger$omfg_before <- numeric()
    ledger$omfg_after <- numeric()
    ledger$rerun_timestamp <- character()
    return(ledger)
  }
  active |>
    dplyr::left_join(
      board |>
      dplyr::select(
        "position", "player_key",
        before_projected_games = "baseline_projected_games",
        after_projected_games = "adjusted_projected_games",
        before_p50_points = "baseline_p50_points",
        after_p50_points = "adjusted_p50_points",
        before_model_rank = "baseline_model_rank",
        after_model_rank = "manual_adjusted_model_rank",
        before_projection_rank = "baseline_projection_rank",
        after_projection_rank = "manual_adjusted_projection_rank",
        omfg_before = "omfg_before_manual",
        omfg_after = "omfg_after_manual"
      ),
      by = c("position", "player_key"),
      relationship = "many-to-one"
    ) |>
    dplyr::mutate(
      prediction_season = as.integer(.env$prediction_season),
      rerun_timestamp = format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z")
    )
}

build_core_sos_projection_audit <- function(board, context, prediction_season) {
  dplyr::bind_rows(lapply(split(board, board$position), function(x) {
    probability_cols <- grep(
      "^(baseline|adjusted)_sim_prob_top[0-9]+$",
      names(x),
      value = TRUE
    )
    active_probability_cols <- probability_cols[vapply(
      probability_cols,
      function(col) any(is.finite(sos_prob_num(x[[col]]))),
      logical(1)
    )]
    probability_values <- if (length(active_probability_cols) > 0L) {
      as.matrix(x[active_probability_cols])
    } else {
      matrix(numeric(), nrow = nrow(x), ncol = 0L)
    }
    nested_probability_violations <- 0L
    for (scope in c("baseline", "adjusted")) {
      scope_cols <- grep(
        paste0("^", scope, "_sim_prob_top[0-9]+$"),
        active_probability_cols,
        value = TRUE
      )
      if (length(scope_cols) > 1L) {
        cutoffs <- suppressWarnings(as.integer(sub(".*_top", "", scope_cols)))
        scope_cols <- scope_cols[order(cutoffs)]
        nested_probability_violations <- nested_probability_violations + sum(apply(
          as.matrix(x[scope_cols]),
          1L,
          function(values) any(diff(values) < -1e-12)
        ))
      }
    }
    range_violations <- sum(
      x$baseline_p10_points > x$baseline_p25_points |
        x$baseline_p25_points > x$baseline_p50_points |
        x$baseline_p50_points > x$baseline_p75_points |
        x$baseline_p75_points > x$baseline_p90_points |
        x$adjusted_p10_points > x$adjusted_p25_points |
        x$adjusted_p25_points > x$adjusted_p50_points |
        x$adjusted_p50_points > x$adjusted_p75_points |
        x$adjusted_p75_points > x$adjusted_p90_points,
      na.rm = TRUE
    )
    active_projection_pool <- if ("active_projection_pool" %in% names(x)) {
      x$active_projection_pool %in% c(TRUE, "TRUE", "true", 1L, "1")
    } else {
      rep(TRUE, nrow(x))
    }
    projected_games_out_of_bounds <- sum(
      !is.finite(x$baseline_projected_games) |
        x$baseline_projected_games < 1 |
        x$baseline_projected_games > 17 |
        !is.finite(x$adjusted_projected_games) |
        x$adjusted_projected_games < 0 |
        (active_projection_pool & x$adjusted_projected_games < 1) |
        x$adjusted_projected_games > 17
    )
    missing_model_ranks <- sum(
      !is.finite(x$baseline_model_rank) |
        !is.finite(x$manual_adjusted_model_rank)
    )
    games_calibration_applied <- if ("games_calibration_applied" %in% names(x)) {
      dplyr::coalesce(as.logical(x$games_calibration_applied), FALSE)
    } else {
      rep(FALSE, nrow(x))
    }
    projection_context_applied <- if ("projection_context_applied" %in% names(x)) {
      dplyr::coalesce(as.logical(x$projection_context_applied), FALSE)
    } else {
      rep(FALSE, nrow(x))
    }
    manual_rank_context_applied <- if ("manual_rank_context_applied" %in% names(x)) {
      dplyr::coalesce(as.logical(x$manual_rank_context_applied), FALSE)
    } else {
      rep(FALSE, nrow(x))
    }
    governed_stat_promotion <- if ("final_review_stat_promotion_applied" %in% names(x)) {
      dplyr::coalesce(as.logical(x$final_review_stat_promotion_applied), FALSE)
    } else {
      rep(FALSE, nrow(x))
    }
    uncontextualized_projection_changes <- sum(
      x$context_adjustment_count == 0 & !games_calibration_applied &
        !projection_context_applied & !manual_rank_context_applied &
        !governed_stat_promotion & (
        abs(x$adjusted_projected_games - x$baseline_projected_games) > 1e-9 |
          abs(x$adjusted_p50_points - x$baseline_p50_points) > 1e-9
      ),
      na.rm = TRUE
    )
    checks <- c(
      nrow(x) > 0L,
      sum(duplicated(x[c("position", "prediction_season", "player_key")])) == 0L,
      sum(!is.finite(x$baseline_p50_points)) == 0L,
      sum(!is.finite(x$adjusted_p50_points)) == 0L,
      sum(abs(x$omfg_before_manual - x$omfg_after_manual) > 1e-12, na.rm = TRUE) == 0L,
      range_violations == 0L,
      projected_games_out_of_bounds == 0L,
      missing_model_ranks == 0L,
      uncontextualized_projection_changes == 0L,
      sum(!is.finite(probability_values)) == 0L,
      sum(probability_values < 0 | probability_values > 1, na.rm = TRUE) == 0L,
      nested_probability_violations == 0L
    )
    data.frame(
      position = x$position[1],
      prediction_season = as.integer(prediction_season),
      rows = nrow(x),
      enabled_context_rows = sum(
        context$enabled_flag & context$position == x$position[1],
        na.rm = TRUE
      ),
      probability_columns = length(active_probability_cols),
      duplicate_player_keys = sum(duplicated(x[c("position", "prediction_season", "player_key")])),
      missing_baseline_p50 = sum(!is.finite(x$baseline_p50_points)),
      missing_adjusted_p50 = sum(!is.finite(x$adjusted_p50_points)),
      omfg_changes = sum(abs(x$omfg_before_manual - x$omfg_after_manual) > 1e-12, na.rm = TRUE),
      range_order_violations = range_violations,
      projected_games_out_of_bounds = projected_games_out_of_bounds,
      missing_model_ranks = missing_model_ranks,
      manual_rank_context_rows = sum(manual_rank_context_applied, na.rm = TRUE),
      games_calibration_rows = sum(games_calibration_applied, na.rm = TRUE),
      projection_context_rows = sum(projection_context_applied, na.rm = TRUE),
      governed_stat_promotion_rows = sum(governed_stat_promotion, na.rm = TRUE),
      uncontextualized_projection_changes = uncontextualized_projection_changes,
      missing_probabilities = sum(!is.finite(probability_values)),
      out_of_bounds_probabilities = sum(probability_values < 0 | probability_values > 1, na.rm = TRUE),
      nested_probability_violations = nested_probability_violations,
      status = if (all(checks)) "PASS" else "FAIL",
      stringsAsFactors = FALSE
    )
  })) |>
    dplyr::arrange(factor(.data$position, levels = c("QB", "RB", "WR", "TE", "K", "DST")))
}

sos_stat_specs <- function(position) {
  switch(
    toupper(position),
    QB = c(
      "pass_attempts", "pass_yards", "pass_td", "interceptions",
      "rush_attempts", "rush_yards", "rush_td"
    ),
    RB = c(
      "rush_attempts", "rush_yards", "rush_td", "targets", "receptions",
      "receiving_yards", "receiving_td", "total_td", "scrimmage_yards"
    ),
    WR = c(
      "targets", "receptions", "receiving_yards", "receiving_td",
      "air_yards", "end_zone_targets", "first_read_targets",
      "receiving_first_downs", "rush_attempts", "rush_yards", "rush_td",
      "total_td", "scrimmage_yards"
    ),
    TE = c(
      "targets", "receptions", "receiving_yards", "receiving_td",
      "air_yards", "end_zone_targets", "first_read_targets",
      "receiving_first_downs", "rush_attempts", "rush_yards", "rush_td",
      "total_td", "scrimmage_yards"
    ),
    K = c("fga", "fgm", "xpa", "xpm", "fga_40_49", "fgm_40_49", "fga_50_plus", "fgm_50_plus"),
    DST = c("sacks", "interceptions", "fumbles", "defensive_tds", "dst_fantasy_points"),
    character()
  )
}

sos_stat_season_table <- function(position) {
  load_model_core_packages()
  position <- toupper(position)
  stats <- sos_stat_specs(position)
  if (length(stats) == 0L) return(data.frame())

  season_table <- switch(
    position,
    QB = build_qb_player_season_combined_table(write_output = FALSE),
    RB = build_rb_player_season_combined_table(write_output = FALSE),
    WR = build_wr_player_season_combined_table(write_output = FALSE),
    TE = build_te_player_season_combined_table(write_output = FALSE),
    K = build_k_player_season_combined_table(write_output = FALSE),
    DST = {
      weekly <- build_dst_clean_weekly_master(write_output = FALSE)
      if (!"player_key" %in% names(weekly)) weekly$player_key <- make_player_key(weekly$player)
      for (stat in stats) {
        if (!stat %in% names(weekly)) weekly[[stat]] <- 0
      }
      weekly |>
        dplyr::mutate(
          season = as.integer(.data$season),
          player_key = make_player_key(.data$player)
        ) |>
        dplyr::group_by(.data$season, .data$player_key, .data$player, .data$team) |>
        dplyr::summarise(
          games = dplyr::n(),
          dplyr::across(dplyr::all_of(stats), ~ sum(sos_prob_num(.x), na.rm = TRUE)),
          fantasy_points = sum(sos_prob_num(.data$dst_fantasy_points), na.rm = TRUE),
          fantasy_points_per_game = mean(sos_prob_num(.data$dst_fantasy_points), na.rm = TRUE),
          .groups = "drop"
        )
    },
    stop("Unsupported stat projection position: ", position, call. = FALSE)
  )

  if (!"player_key" %in% names(season_table)) season_table$player_key <- make_player_key(season_table$player)
  if (!"games" %in% names(season_table)) season_table$games <- NA_real_
  if (!"fantasy_points" %in% names(season_table)) season_table$fantasy_points <- NA_real_
  if (!"fantasy_points_per_game" %in% names(season_table)) season_table$fantasy_points_per_game <- NA_real_
  for (stat in stats) {
    if (!stat %in% names(season_table)) season_table[[stat]] <- NA_real_
  }

  season_table |>
    dplyr::mutate(
      position = .env$position,
      season = as.integer(.data$season),
      player_key = make_player_key(.data$player),
      games = sos_prob_num(.data$games),
      fantasy_points = sos_prob_num(.data$fantasy_points),
      fantasy_points_per_game = sos_prob_num(.data$fantasy_points_per_game)
    ) |>
    dplyr::select(
      "position", "season", "player_key", "player", "team", "games",
      "fantasy_points", "fantasy_points_per_game",
      dplyr::all_of(stats)
    )
}

sos_stat_projection_history <- function(position) {
  position <- toupper(position)
  stats <- sos_stat_specs(position)
  if (length(stats) == 0L) return(data.frame())

  features <- sos_projection_history(position) |>
    dplyr::mutate(
      player_key = make_player_key(.data$player),
      source_season = as.integer(.data$season) - 1L
    )
  season_table <- sos_stat_season_table(position)
  available_stats <- stats[stats %in% names(season_table)]
  if (length(available_stats) == 0L) return(data.frame())

  source_stats <- season_table |>
    dplyr::select(
      player_key,
      source_season = "season",
      source_games = "games",
      dplyr::all_of(available_stats)
    )
  names(source_stats)[names(source_stats) %in% available_stats] <- paste0("current_", available_stats)

  target_stats <- season_table |>
    dplyr::select(
      player_key,
      season,
      target_games = "games",
      dplyr::all_of(available_stats)
    )
  names(target_stats)[names(target_stats) %in% available_stats] <- paste0("target_", available_stats)

  features |>
    dplyr::left_join(source_stats, by = c("player_key", "source_season"), relationship = "many-to-one") |>
    dplyr::left_join(target_stats, by = c("player_key", "season"), relationship = "many-to-one")
}

sos_stat_linear_predict <- function(train, test, stat) {
  target_col <- paste0("target_", stat)
  anchor_col <- paste0("current_", stat)
  predictor_cols <- c(
    anchor_col, "source_games", "anchor_ppg", "anchor_total_points",
    "final_score", "board_score", "official_omfg", "rank_score_0to100"
  )
  predictor_cols <- predictor_cols[predictor_cols %in% names(train) & predictor_cols %in% names(test)]

  target <- sos_prob_num(train[[target_col]])
  fallback <- pmax(0, sos_prob_num(test[[anchor_col]]))
  if (!anchor_col %in% predictor_cols) return(fallback)

  train_model <- data.frame(target = target)
  test_model <- data.frame(row_id = seq_len(nrow(test)))
  for (predictor in predictor_cols) {
    train_values <- sos_prob_num(train[[predictor]])
    test_values <- sos_prob_num(test[[predictor]])
    fill <- stats::median(train_values[is.finite(train_values)], na.rm = TRUE)
    if (!is.finite(fill)) fill <- 0
    train_values[!is.finite(train_values)] <- fill
    test_values[!is.finite(test_values)] <- fill
    train_model[[predictor]] <- train_values
    test_model[[predictor]] <- test_values
  }

  keep <- is.finite(train_model$target) & is.finite(train_model[[anchor_col]])
  if (sum(keep) < 25L) return(fallback)

  fit <- try(
    suppressWarnings(stats::lm(
      stats::reformulate(predictor_cols, response = "target"),
      data = train_model[keep, , drop = FALSE]
    )),
    silent = TRUE
  )
  prediction <- if (inherits(fit, "try-error")) {
    fallback
  } else {
    candidate <- try(suppressWarnings(stats::predict(fit, newdata = test_model)), silent = TRUE)
    if (inherits(candidate, "try-error")) fallback else as.numeric(candidate)
  }
  prediction[!is.finite(prediction)] <- fallback[!is.finite(prediction)]
  historical_upper <- stats::quantile(target[keep], 0.99, na.rm = TRUE, names = FALSE)
  if (!is.finite(historical_upper) || historical_upper <= 0) historical_upper <- max(target[keep], na.rm = TRUE)
  pmin(pmax(0, prediction), historical_upper * 1.25)
}

sos_stat_projection_candidates <- function(train, test, stat) {
  anchor <- pmax(0, sos_prob_num(test[[paste0("current_", stat)]]))
  linear <- sos_stat_linear_predict(train, test, stat)
  list(
    anchor = anchor,
    linear = linear,
    blend_70_linear_30_anchor = 0.70 * linear + 0.30 * anchor
  )
}

sos_stat_wide_num <- function(df, col) {
  if (col %in% names(df)) {
    out <- sos_prob_num(df[[col]])
  } else {
    out <- rep(0, nrow(df))
  }
  out[!is.finite(out)] <- 0
  out
}

sos_stat_implied_fantasy_points <- function(df) {
  position <- toupper(as.character(df$position))
  n <- nrow(df)
  out <- rep(NA_real_, n)

  qb <- position == "QB"
  if (any(qb, na.rm = TRUE)) {
    out[qb] <-
      sos_stat_wide_num(df, "projected_pass_yards")[qb] / 25 +
      sos_stat_wide_num(df, "projected_pass_td")[qb] * 4 -
      sos_stat_wide_num(df, "projected_interceptions")[qb] * 2 +
      sos_stat_wide_num(df, "projected_rush_yards")[qb] / 10 +
      sos_stat_wide_num(df, "projected_rush_td")[qb] * 6
  }

  skill <- position %in% c("RB", "WR", "TE")
  if (any(skill, na.rm = TRUE)) {
    component_td <- sos_stat_wide_num(df, "projected_rush_td") +
      sos_stat_wide_num(df, "projected_receiving_td")
    out[skill] <-
      sos_stat_wide_num(df, "projected_rush_yards")[skill] / 10 +
      sos_stat_wide_num(df, "projected_receptions")[skill] * 0.5 +
      sos_stat_wide_num(df, "projected_receiving_yards")[skill] / 10 +
      component_td[skill] * 6
  }

  k <- position == "K"
  if (any(k, na.rm = TRUE)) {
    made_long <- sos_stat_wide_num(df, "projected_fgm_40_49") +
      sos_stat_wide_num(df, "projected_fgm_50_plus")
    made_short <- pmax(0, sos_stat_wide_num(df, "projected_fgm") - made_long)
    out[k] <-
      made_short[k] * 3 +
      sos_stat_wide_num(df, "projected_fgm_40_49")[k] * 4 +
      sos_stat_wide_num(df, "projected_fgm_50_plus")[k] * 5 +
      sos_stat_wide_num(df, "projected_xpm")[k]
  }

  dst <- position == "DST"
  if (any(dst, na.rm = TRUE)) {
    out[dst] <- sos_stat_wide_num(df, "projected_dst_fantasy_points")[dst]
  }

  out[!is.finite(out)] <- NA_real_
  out
}

sos_stat_reconciliation_columns <- function(position) {
  switch(
    toupper(position),
    QB = c(
      "projected_pass_attempts", "projected_pass_yards", "projected_pass_td",
      "projected_rush_attempts", "projected_rush_yards", "projected_rush_td"
    ),
    RB = c(
      "projected_rush_attempts", "projected_rush_yards", "projected_rush_td",
      "projected_targets", "projected_receptions", "projected_receiving_yards",
      "projected_receiving_td", "projected_total_td", "projected_scrimmage_yards"
    ),
    WR = c(
      "projected_targets", "projected_receptions", "projected_receiving_yards",
      "projected_receiving_td", "projected_air_yards", "projected_end_zone_targets",
      "projected_first_read_targets", "projected_receiving_first_downs",
      "projected_rush_attempts", "projected_rush_yards", "projected_rush_td",
      "projected_total_td", "projected_scrimmage_yards"
    ),
    TE = c(
      "projected_targets", "projected_receptions", "projected_receiving_yards",
      "projected_receiving_td", "projected_air_yards", "projected_end_zone_targets",
      "projected_first_read_targets", "projected_receiving_first_downs",
      "projected_rush_attempts", "projected_rush_yards", "projected_rush_td",
      "projected_total_td", "projected_scrimmage_yards"
    ),
    K = c(
      "projected_fga", "projected_fga_40_49", "projected_fga_50_plus",
      "projected_fgm", "projected_fgm_40_49", "projected_fgm_50_plus",
      "projected_xpa", "projected_xpm"
    ),
    DST = c(
      "projected_sacks", "projected_interceptions", "projected_fumbles",
      "projected_defensive_tds", "projected_dst_fantasy_points"
    ),
    character()
  )
}

sos_seed_missing_stat_projection_from_p50 <- function(wide) {
  out <- wide
  n <- nrow(out)
  if (!"stat_target_p50_points" %in% names(out)) return(out)
  if (!"stat_target_projected_games" %in% names(out)) out$stat_target_projected_games <- NA_real_
  out$stat_missing_base_seeded <- FALSE
  out$stat_seed_profile <- ""

  initial_points <- sos_stat_implied_fantasy_points(out)
  needs_seed <- !is.finite(initial_points) | initial_points <= 0
  needs_seed <- needs_seed &
    is.finite(out$stat_target_p50_points) &
    out$stat_target_p50_points > 0

  ensure_col <- function(col) {
    if (!col %in% names(out)) out[[col]] <<- rep(NA_real_, n)
  }
  for (col in unique(unlist(lapply(unique(as.character(out$position)), sos_stat_reconciliation_columns)))) {
    ensure_col(col)
  }

  p50 <- pmax(0, sos_prob_num(out$stat_target_p50_points))
  games <- pmax(1, pmin(17, dplyr::coalesce(sos_prob_num(out$stat_target_projected_games), 12)))
  owned_missing <- rep(FALSE, nrow(out))
  for (position in unique(as.character(out$position))) {
    rows <- which(out$position == position)
    cols <- intersect(sos_stat_reconciliation_columns(position), names(out))
    if (length(rows) == 0L || length(cols) == 0L) next
    owned_missing[rows] <- apply(is.na(out[rows, cols, drop = FALSE]), 1, any)
  }
  needs_seed <- (needs_seed | owned_missing) &
    is.finite(out$stat_target_p50_points) &
    out$stat_target_p50_points > 0
  if (!any(needs_seed, na.rm = TRUE)) return(out)

  fill_stat_seed <- function(rows, col, value) {
    if (!col %in% names(out)) out[[col]] <<- rep(NA_real_, n)
    current <- sos_prob_num(out[[col]])
    seed_all_zero_profile <- !is.finite(initial_points) | initial_points <= 0
    fill_rows <- rows & (!is.finite(current) | is.na(out[[col]]) | seed_all_zero_profile)
    if (any(fill_rows, na.rm = TRUE)) {
      out[[col]][fill_rows] <<- value[fill_rows]
      out$stat_missing_base_seeded[fill_rows] <<- TRUE
    }
  }

  qb <- needs_seed & toupper(as.character(out$position)) == "QB"
  if (any(qb, na.rm = TRUE)) {
    interceptions <- games[qb] * 0.45
    positive_points <- p50[qb] + interceptions * 2
    qb_rows <- which(qb)
    seed_pass_yards <- rep(NA_real_, n); seed_pass_yards[qb] <- positive_points * 0.64 * 25
    seed_pass_td <- rep(NA_real_, n); seed_pass_td[qb] <- positive_points * 0.25 / 4
    seed_rush_yards <- rep(NA_real_, n); seed_rush_yards[qb] <- positive_points * 0.09 * 10
    seed_rush_td <- rep(NA_real_, n); seed_rush_td[qb] <- positive_points * 0.02 / 6
    seed_interceptions <- rep(NA_real_, n); seed_interceptions[qb] <- interceptions
    seed_pass_attempts <- rep(NA_real_, n); seed_pass_attempts[qb] <- seed_pass_yards[qb] / 7.0
    seed_rush_attempts <- rep(NA_real_, n); seed_rush_attempts[qb] <- seed_rush_yards[qb] / 5.0
    fill_stat_seed(qb, "projected_interceptions", seed_interceptions)
    fill_stat_seed(qb, "projected_pass_yards", seed_pass_yards)
    fill_stat_seed(qb, "projected_pass_td", seed_pass_td)
    fill_stat_seed(qb, "projected_rush_yards", seed_rush_yards)
    fill_stat_seed(qb, "projected_rush_td", seed_rush_td)
    fill_stat_seed(qb, "projected_pass_attempts", seed_pass_attempts)
    fill_stat_seed(qb, "projected_rush_attempts", seed_rush_attempts)
    out$stat_seed_profile[qb_rows] <- dplyr::if_else(
      nzchar(out$stat_seed_profile[qb_rows]),
      out$stat_seed_profile[qb_rows],
      "generic_qb_pocket_safe"
    )
  }

  rb <- needs_seed & toupper(as.character(out$position)) == "RB"
  if (any(rb, na.rm = TRUE)) {
    td <- p50[rb] * 0.34 / 6
    seed_rush_yards <- rep(NA_real_, n); seed_rush_yards[rb] <- p50[rb] * 0.36 * 10
    seed_receptions <- rep(NA_real_, n); seed_receptions[rb] <- p50[rb] * 0.16 / 0.5
    seed_receiving_yards <- rep(NA_real_, n); seed_receiving_yards[rb] <- p50[rb] * 0.14 * 10
    seed_rush_td <- rep(NA_real_, n); seed_rush_td[rb] <- td * 0.75
    seed_receiving_td <- rep(NA_real_, n); seed_receiving_td[rb] <- td * 0.25
    seed_total_td <- rep(NA_real_, n); seed_total_td[rb] <- td
    seed_scrimmage <- rep(NA_real_, n); seed_scrimmage[rb] <- seed_rush_yards[rb] + seed_receiving_yards[rb]
    seed_rush_attempts <- rep(NA_real_, n); seed_rush_attempts[rb] <- seed_rush_yards[rb] / 4.3
    seed_targets <- rep(NA_real_, n); seed_targets[rb] <- seed_receptions[rb] / 0.75
    fill_stat_seed(rb, "projected_rush_yards", seed_rush_yards)
    fill_stat_seed(rb, "projected_receptions", seed_receptions)
    fill_stat_seed(rb, "projected_receiving_yards", seed_receiving_yards)
    fill_stat_seed(rb, "projected_rush_td", seed_rush_td)
    fill_stat_seed(rb, "projected_receiving_td", seed_receiving_td)
    fill_stat_seed(rb, "projected_total_td", seed_total_td)
    fill_stat_seed(rb, "projected_scrimmage_yards", seed_scrimmage)
    fill_stat_seed(rb, "projected_rush_attempts", seed_rush_attempts)
    fill_stat_seed(rb, "projected_targets", seed_targets)
    out$stat_seed_profile[rb] <- dplyr::if_else(
      nzchar(out$stat_seed_profile[rb]),
      out$stat_seed_profile[rb],
      "generic_rb_balanced"
    )
  }

  wr <- needs_seed & toupper(as.character(out$position)) == "WR"
  if (any(wr, na.rm = TRUE)) {
    td <- p50[wr] * 0.24 / 6
    seed_receptions <- rep(NA_real_, n); seed_receptions[wr] <- p50[wr] * 0.26 / 0.5
    seed_receiving_yards <- rep(NA_real_, n); seed_receiving_yards[wr] <- p50[wr] * 0.48 * 10
    seed_rush_yards <- rep(NA_real_, n); seed_rush_yards[wr] <- p50[wr] * 0.02 * 10
    seed_receiving_td <- rep(NA_real_, n); seed_receiving_td[wr] <- td
    seed_rush_td <- rep(0, n)
    seed_total_td <- rep(NA_real_, n); seed_total_td[wr] <- td
    seed_scrimmage <- rep(NA_real_, n); seed_scrimmage[wr] <- seed_receiving_yards[wr] + seed_rush_yards[wr]
    seed_targets <- rep(NA_real_, n); seed_targets[wr] <- seed_receptions[wr] / 0.68
    seed_air_yards <- rep(NA_real_, n); seed_air_yards[wr] <- seed_receiving_yards[wr] * 1.45
    seed_end_zone <- rep(NA_real_, n); seed_end_zone[wr] <- td * 2.5
    seed_first_read <- rep(NA_real_, n); seed_first_read[wr] <- seed_targets[wr] * 0.32
    seed_first_downs <- rep(NA_real_, n); seed_first_downs[wr] <- seed_receptions[wr] * 0.55
    seed_rush_attempts <- rep(NA_real_, n); seed_rush_attempts[wr] <- seed_rush_yards[wr] / 6.5
    fill_stat_seed(wr, "projected_receptions", seed_receptions)
    fill_stat_seed(wr, "projected_receiving_yards", seed_receiving_yards)
    fill_stat_seed(wr, "projected_rush_yards", seed_rush_yards)
    fill_stat_seed(wr, "projected_receiving_td", seed_receiving_td)
    fill_stat_seed(wr, "projected_rush_td", seed_rush_td)
    fill_stat_seed(wr, "projected_total_td", seed_total_td)
    fill_stat_seed(wr, "projected_scrimmage_yards", seed_scrimmage)
    fill_stat_seed(wr, "projected_targets", seed_targets)
    fill_stat_seed(wr, "projected_air_yards", seed_air_yards)
    fill_stat_seed(wr, "projected_end_zone_targets", seed_end_zone)
    fill_stat_seed(wr, "projected_first_read_targets", seed_first_read)
    fill_stat_seed(wr, "projected_receiving_first_downs", seed_first_downs)
    fill_stat_seed(wr, "projected_rush_attempts", seed_rush_attempts)
    out$stat_seed_profile[wr] <- dplyr::if_else(
      nzchar(out$stat_seed_profile[wr]),
      out$stat_seed_profile[wr],
      "generic_wr_receiver"
    )
  }

  te <- needs_seed & toupper(as.character(out$position)) == "TE"
  if (any(te, na.rm = TRUE)) {
    td <- p50[te] * 0.24 / 6
    seed_receptions <- rep(NA_real_, n); seed_receptions[te] <- p50[te] * 0.28 / 0.5
    seed_receiving_yards <- rep(NA_real_, n); seed_receiving_yards[te] <- p50[te] * 0.46 * 10
    seed_rush_yards <- rep(NA_real_, n); seed_rush_yards[te] <- p50[te] * 0.01 * 10
    seed_receiving_td <- rep(NA_real_, n); seed_receiving_td[te] <- td
    seed_rush_td <- rep(0, n)
    seed_total_td <- rep(NA_real_, n); seed_total_td[te] <- td
    seed_scrimmage <- rep(NA_real_, n); seed_scrimmage[te] <- seed_receiving_yards[te] + seed_rush_yards[te]
    seed_targets <- rep(NA_real_, n); seed_targets[te] <- seed_receptions[te] / 0.72
    seed_air_yards <- rep(NA_real_, n); seed_air_yards[te] <- seed_receiving_yards[te] * 1.25
    seed_end_zone <- rep(NA_real_, n); seed_end_zone[te] <- td * 2.2
    seed_first_read <- rep(NA_real_, n); seed_first_read[te] <- seed_targets[te] * 0.28
    seed_first_downs <- rep(NA_real_, n); seed_first_downs[te] <- seed_receptions[te] * 0.52
    seed_rush_attempts <- rep(NA_real_, n); seed_rush_attempts[te] <- seed_rush_yards[te] / 5.5
    fill_stat_seed(te, "projected_receptions", seed_receptions)
    fill_stat_seed(te, "projected_receiving_yards", seed_receiving_yards)
    fill_stat_seed(te, "projected_rush_yards", seed_rush_yards)
    fill_stat_seed(te, "projected_receiving_td", seed_receiving_td)
    fill_stat_seed(te, "projected_rush_td", seed_rush_td)
    fill_stat_seed(te, "projected_total_td", seed_total_td)
    fill_stat_seed(te, "projected_scrimmage_yards", seed_scrimmage)
    fill_stat_seed(te, "projected_targets", seed_targets)
    fill_stat_seed(te, "projected_air_yards", seed_air_yards)
    fill_stat_seed(te, "projected_end_zone_targets", seed_end_zone)
    fill_stat_seed(te, "projected_first_read_targets", seed_first_read)
    fill_stat_seed(te, "projected_receiving_first_downs", seed_first_downs)
    fill_stat_seed(te, "projected_rush_attempts", seed_rush_attempts)
    out$stat_seed_profile[te] <- dplyr::if_else(
      nzchar(out$stat_seed_profile[te]),
      out$stat_seed_profile[te],
      "generic_te_receiver"
    )
  }

  k <- needs_seed & toupper(as.character(out$position)) == "K"
  if (any(k, na.rm = TRUE)) {
    fg_point_share <- 0.75
    short_make_share <- 0.51
    mid_make_share <- 0.29
    long_make_share <- 0.20
    weighted_fg_points <-
      short_make_share * 3 + mid_make_share * 4 + long_make_share * 5
    seed_xpm <- rep(NA_real_, n); seed_xpm[k] <- p50[k] * (1 - fg_point_share)
    seed_xpa <- rep(NA_real_, n); seed_xpa[k] <- seed_xpm[k] / 0.973
    seed_fgm <- rep(NA_real_, n); seed_fgm[k] <- p50[k] * fg_point_share / weighted_fg_points
    seed_fgm_40_49 <- rep(NA_real_, n); seed_fgm_40_49[k] <- seed_fgm[k] * mid_make_share
    seed_fgm_50_plus <- rep(NA_real_, n); seed_fgm_50_plus[k] <- seed_fgm[k] * long_make_share
    seed_fga <- rep(NA_real_, n); seed_fga[k] <- seed_fgm[k] / 0.858
    seed_fga_40_49 <- rep(NA_real_, n); seed_fga_40_49[k] <- seed_fgm_40_49[k] / 0.831
    seed_fga_50_plus <- rep(NA_real_, n); seed_fga_50_plus[k] <- seed_fgm_50_plus[k] / 0.713
    fill_stat_seed(k, "projected_fga", seed_fga)
    fill_stat_seed(k, "projected_fgm", seed_fgm)
    fill_stat_seed(k, "projected_fga_40_49", seed_fga_40_49)
    fill_stat_seed(k, "projected_fgm_40_49", seed_fgm_40_49)
    fill_stat_seed(k, "projected_fga_50_plus", seed_fga_50_plus)
    fill_stat_seed(k, "projected_fgm_50_plus", seed_fgm_50_plus)
    fill_stat_seed(k, "projected_xpa", seed_xpa)
    fill_stat_seed(k, "projected_xpm", seed_xpm)
    out$stat_seed_profile[k] <- dplyr::if_else(
      nzchar(out$stat_seed_profile[k]),
      out$stat_seed_profile[k],
      "generic_k_league_median_profile"
    )
  }

  out
}

sos_distribute_total_td_components <- function(wide) {
  out <- wide
  required <- c("projected_total_td", "projected_rush_td", "projected_receiving_td")
  if (!all(required %in% names(out))) return(out)
  total_td <- sos_stat_wide_num(out, "projected_total_td")
  component_td <- sos_stat_wide_num(out, "projected_rush_td") +
    sos_stat_wide_num(out, "projected_receiving_td")
  needs_split <- total_td > 0 & component_td <= 0
  rb <- needs_split & toupper(as.character(out$position)) == "RB"
  if (any(rb, na.rm = TRUE)) {
    out$projected_rush_td[rb] <- total_td[rb] * 0.75
    out$projected_receiving_td[rb] <- total_td[rb] * 0.25
  }
  receiver <- needs_split & toupper(as.character(out$position)) %in% c("WR", "TE")
  if (any(receiver, na.rm = TRUE)) {
    out$projected_rush_td[receiver] <- 0
    out$projected_receiving_td[receiver] <- total_td[receiver]
  }
  out
}

sos_stat_reconciliation_low_usage_floor <- function(position, col) {
  position <- toupper(as.character(position)[[1]])
  switch(
    paste(position, col, sep = "::"),
    "QB::projected_rush_attempts" = 8,
    "QB::projected_rush_yards" = 35,
    "QB::projected_rush_td" = 0.35,
    "WR::projected_rush_attempts" = 4,
    "WR::projected_rush_yards" = 20,
    "WR::projected_rush_td" = 0.25,
    "TE::projected_rush_attempts" = 2,
    "TE::projected_rush_yards" = 10,
    "TE::projected_rush_td" = 0.15,
    0
  )
}

sos_stat_residual_bridge_columns <- function(position, direction, row = NULL) {
  position <- toupper(as.character(position)[[1]])
  direction <- as.character(direction)[[1]]
  note <- ""
  if (!is.null(row) && "manual_context_note" %in% names(row)) {
    note <- tolower(as.character(row$manual_context_note[[1]]))
  }
  channel <- ""
  if (!is.null(row) && "adjustment_channel" %in% names(row)) {
    channel <- tolower(as.character(row$adjustment_channel[[1]]))
  }
  text <- paste(note, channel)
  rushing_qb <- grepl("rush|rushing|run|running|mobile|scrambl", text)

  if (position == "QB") {
    if (isTRUE(rushing_qb)) {
      return(c(
        "projected_rush_attempts", "projected_rush_yards", "projected_rush_td",
        "projected_pass_attempts", "projected_pass_yards", "projected_pass_td"
      ))
    }
    return(c(
      "projected_pass_attempts", "projected_pass_yards", "projected_pass_td",
      "projected_rush_attempts", "projected_rush_yards", "projected_rush_td"
    ))
  }
  if (position == "RB") {
    return(c(
      "projected_rush_attempts", "projected_rush_yards", "projected_rush_td",
      "projected_targets", "projected_receptions", "projected_receiving_yards",
      "projected_receiving_td", "projected_total_td", "projected_scrimmage_yards"
    ))
  }
  if (position %in% c("WR", "TE")) {
    return(c(
      "projected_targets", "projected_receptions", "projected_receiving_yards",
      "projected_receiving_td", "projected_air_yards", "projected_end_zone_targets",
      "projected_first_read_targets", "projected_receiving_first_downs",
      "projected_total_td", "projected_scrimmage_yards",
      "projected_rush_attempts", "projected_rush_yards", "projected_rush_td"
    ))
  }
  if (position == "K") {
    return(c(
      "projected_fga", "projected_fgm", "projected_fga_40_49",
      "projected_fgm_40_49", "projected_fga_50_plus",
      "projected_fgm_50_plus", "projected_xpa", "projected_xpm"
    ))
  }
  if (position == "DST") {
    return(c("projected_dst_fantasy_points", "projected_sacks", "projected_interceptions", "projected_fumbles", "projected_defensive_tds"))
  }
  character()
}

sos_apply_stat_residual_bridge <- function(
    wide,
    min_points_gap = 8,
    min_gap_ratio = 0.08,
    residual_floor = 0.55,
    residual_ceiling = 1.80
) {
  if (is.null(wide) || nrow(wide) == 0L) return(wide)
  out <- wide
  out$stat_residual_bridge_applied <- FALSE
  out$stat_residual_bridge_multiplier <- 1
  out$stat_residual_bridge_cols <- 0L
  out$stat_residual_bridge_direction <- "none"
  out$stat_residual_bridge_gap_before <- NA_real_

  target <- sos_prob_num(out$stat_target_p50_points)
  implied <- sos_stat_implied_fantasy_points(out)
  gap <- target - implied
  abs_gap <- abs(gap)
  gap_ratio <- dplyr::if_else(is.finite(target) & target > 0, abs_gap / target, NA_real_)
  eligible <- is.finite(target) & target > 0 & is.finite(implied) & implied > 0 &
    abs_gap >= min_points_gap & is.finite(gap_ratio) & gap_ratio >= min_gap_ratio

  for (i in which(eligible)) {
    position <- toupper(as.character(out$position[[i]]))
    row <- out[i, , drop = FALSE]
    direction <- if (gap[[i]] > 0) "up" else "down"
    cols <- intersect(sos_stat_residual_bridge_columns(position, direction, row), names(out))
    cols <- cols[vapply(cols, function(col) is.numeric(sos_prob_num(out[[col]])), logical(1))]
    if (length(cols) == 0L) next

    qb_penalty <- if (position == "QB") {
      sos_stat_wide_num(out[i, , drop = FALSE], "projected_interceptions")[[1]] * 2
    } else {
      0
    }
    multiplier <- dplyr::if_else(
      implied[[i]] + qb_penalty > 0,
      (target[[i]] + qb_penalty) / (implied[[i]] + qb_penalty),
      1
    )
    multiplier <- pmin(residual_ceiling, pmax(residual_floor, multiplier))
    if (!is.finite(multiplier) || abs(multiplier - 1) < 1e-8) next

    applied_cols <- 0L
    for (col in cols) {
      before <- sos_prob_num(out[[col]][[i]])
      if (!is.finite(before)) before <- 0
      low_usage_floor <- sos_stat_reconciliation_low_usage_floor(position, col)
      profile_protected <- before > 0 && before <= low_usage_floor && multiplier > 1
      if (isTRUE(profile_protected)) next
      out[[col]][[i]] <- pmax(0, before * multiplier)
      applied_cols <- applied_cols + 1L
    }
    if (applied_cols > 0L) {
      out$stat_residual_bridge_applied[[i]] <- TRUE
      out$stat_residual_bridge_multiplier[[i]] <- multiplier
      out$stat_residual_bridge_cols[[i]] <- applied_cols
      out$stat_residual_bridge_direction[[i]] <- direction
      out$stat_residual_bridge_gap_before[[i]] <- gap[[i]]
    }
  }

  if (all(c("projected_rush_yards", "projected_receiving_yards", "projected_scrimmage_yards") %in% names(out))) {
    skill <- toupper(as.character(out$position)) %in% c("RB", "WR", "TE")
    out$projected_scrimmage_yards[skill] <-
      sos_stat_wide_num(out, "projected_rush_yards")[skill] +
      sos_stat_wide_num(out, "projected_receiving_yards")[skill]
  }
  if (all(c("projected_rush_td", "projected_receiving_td", "projected_total_td") %in% names(out))) {
    skill <- toupper(as.character(out$position)) %in% c("RB", "WR", "TE")
    out$projected_total_td[skill] <-
      sos_stat_wide_num(out, "projected_rush_td")[skill] +
      sos_stat_wide_num(out, "projected_receiving_td")[skill]
  }
  if ("projected_dst_fantasy_points" %in% names(out)) {
    dst <- toupper(as.character(out$position)) == "DST"
    out$projected_dst_fantasy_points[dst] <- out$stat_target_p50_points[dst]
  }
  out
}

sos_apply_qb_final_review_projection_context <- function(
    board,
    prediction_season = 2026L
) {
  if (is.null(board) || nrow(board) == 0L || as.integer(prediction_season[[1]]) != 2026L) {
    return(board)
  }
  context <- data.frame(
    player_key = make_player_key(c(
      "Drake Maye", "Josh Allen", "Jalen Hurts", "Joe Burrow",
      "Lamar Jackson", "Patrick Mahomes", "Jayden Daniels", "Bo Nix",
      "Brock Purdy", "Kyler Murray", "Tyler Shough", "Matthew Stafford",
      "Kirk Cousins", "Fernando Mendoza", "Mac Jones", "Malik Willis"
    )),
    games_floor = c(NA, NA, NA, 15, NA, NA, 15, NA, 15, 15, 15, NA, 13, NA, NA, 15),
    games_cap = c(NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, 7, 2, NA),
    ppg_pct = c(0.03, 0, 0, 0.03, 0.05, 0, 0.05, -0.05, 0, 0, 0, -0.04, 0.05, -0.06, -0.05, 0.06),
    note = c(
      "Healthy passing growth with A.J. Brown plus a modest mobility restoration.",
      "Restore a small portion of the healthy rushing-yardage baseline.",
      "Keep Tush Push value in rushing touchdowns without a blanket passing boost.",
      "Healthy-season restoration with a 15-game projection floor.",
      "Increase healthy-season rushing volume without inflating the passing projection.",
      "Reduce post-ACL rushing expectations while preserving the passing projection.",
      "Increase healthy-season mobility and passing-TD expectations while preserving passing volume.",
      "Apply a modest ceiling reduction before the final QB13 rank guardrail.",
      "Raise the healthy starter projection to at least 15 games.",
      "Raise the healthy starter projection to at least 15 games.",
      "Raise the expected starter projection to at least 15 games.",
      "Apply modest passing-touchdown regression after the prior 40-touchdown season.",
      "Treat Cousins as the opening-day starter with a 13-game projection floor.",
      "Reduce the rookie projection because the timing of a starting transition is uncertain.",
      "Reduce the backup projection after raising Brock Purdy to 15 games.",
      "Treat Willis as Miami's starter with a 15-game projection floor."
    ),
    stringsAsFactors = FALSE
  )
  out <- board
  if (!"context_adjustment_count" %in% names(out)) out$context_adjustment_count <- 0L
  if (!"manual_context_note" %in% names(out)) out$manual_context_note <- ""
  out$qb_final_review_projection_applied <- FALSE
  out$qb_final_review_games_before <- NA_real_
  out$qb_final_review_games_after <- NA_real_
  out$qb_final_review_ppg_before <- NA_real_
  out$qb_final_review_ppg_after <- NA_real_
  out$qb_final_review_total_multiplier <- 1
  out$qb_final_review_note <- ""

  for (i in seq_len(nrow(context))) {
    rows <- which(out$position == "QB" & out$player_key == context$player_key[[i]])
    if (length(rows) == 0L) next
    before_games <- sos_prob_num(out$adjusted_projected_games[rows])
    before_ppg <- sos_prob_num(out$adjusted_projected_ppg[rows])
    after_games <- before_games
    if (is.finite(context$games_floor[[i]])) {
      after_games <- pmax(after_games, context$games_floor[[i]])
    }
    if (is.finite(context$games_cap[[i]])) {
      after_games <- pmin(after_games, context$games_cap[[i]])
    }
    after_games <- pmin(17, pmax(1, after_games))
    after_ppg <- pmax(0, before_ppg * (1 + context$ppg_pct[[i]]))
    total_multiplier <- (after_games * after_ppg) /
      pmax(before_games * before_ppg, 1e-6)
    out$qb_final_review_projection_applied[rows] <- TRUE
    out$qb_final_review_games_before[rows] <- before_games
    out$qb_final_review_games_after[rows] <- after_games
    out$qb_final_review_ppg_before[rows] <- before_ppg
    out$qb_final_review_ppg_after[rows] <- after_ppg
    out$qb_final_review_total_multiplier[rows] <- total_multiplier
    out$qb_final_review_note[rows] <- context$note[[i]]
    out$adjusted_projected_games[rows] <- after_games
    out$adjusted_projected_ppg[rows] <- after_ppg
    for (col in intersect(
      c(
        "adjusted_p10_points", "adjusted_p25_points", "adjusted_p50_points",
        "adjusted_p75_points", "adjusted_p90_points"
      ),
      names(out)
    )) {
      out[[col]][rows] <- pmax(0, sos_prob_num(out[[col]][rows]) * total_multiplier)
    }
    out$context_adjustment_count[rows] <-
      dplyr::coalesce(sos_prob_num(out$context_adjustment_count[rows]), 0) + 1L
    existing_note <- dplyr::coalesce(as.character(out$manual_context_note[rows]), "")
    out$manual_context_note[rows] <- ifelse(
      nzchar(existing_note),
      paste(existing_note, context$note[[i]], sep = " | "),
      context$note[[i]]
    )
  }
  out <- sos_enforce_projection_ranges(
    out,
    c(
      "adjusted_p10_points", "adjusted_p25_points", "adjusted_p50_points",
      "adjusted_p75_points", "adjusted_p90_points"
    )
  ) |>
    dplyr::mutate(
      adjusted_average_range_score = (
        .data$adjusted_p25_points + .data$adjusted_p50_points + .data$adjusted_p75_points
      ) / 3
    ) |>
    dplyr::group_by(.data$position) |>
    dplyr::mutate(
      manual_adjusted_projection_rank = rank(
        -.data$adjusted_average_range_score,
        ties.method = "first",
        na.last = "keep"
      )
    ) |>
    dplyr::ungroup()
  out
}

build_core_sos_qb_final_review_projection_audit <- function(board, prediction_season = 2026L) {
  qb <- board[board$position == "QB", , drop = FALSE]
  data.frame(
    position = "QB",
    prediction_season = as.integer(prediction_season[[1]]),
    rows = nrow(qb),
    adjusted_rows = sum(qb$qb_final_review_projection_applied, na.rm = TRUE),
    max_abs_games_change = max(
      abs(qb$qb_final_review_games_after - qb$qb_final_review_games_before),
      na.rm = TRUE
    ),
    max_abs_ppg_pct = max(
      abs(qb$qb_final_review_ppg_after / pmax(qb$qb_final_review_ppg_before, 1e-6) - 1),
      na.rm = TRUE
    ),
    games_out_of_bounds = sum(
      !is.finite(qb$adjusted_projected_games) |
        qb$adjusted_projected_games < 1 |
        qb$adjusted_projected_games > 17
    ),
    range_order_violations = sum(
      qb$adjusted_p10_points > qb$adjusted_p25_points |
        qb$adjusted_p25_points > qb$adjusted_p50_points |
        qb$adjusted_p50_points > qb$adjusted_p75_points |
        qb$adjusted_p75_points > qb$adjusted_p90_points,
      na.rm = TRUE
    ),
    status = if (
      sum(!is.finite(qb$adjusted_projected_games)) == 0L &&
        all(qb$adjusted_projected_games >= 1 & qb$adjusted_projected_games <= 17) &&
        max(
          abs(qb$qb_final_review_ppg_after / pmax(qb$qb_final_review_ppg_before, 1e-6) - 1),
          na.rm = TRUE
        ) <= 0.06 + 1e-8
    ) "PASS" else "FAIL",
    stringsAsFactors = FALSE
  )
}

sos_apply_rb_final_review_projection_context <- function(
    board,
    prediction_season = 2026L
) {
  if (is.null(board) || nrow(board) == 0L || as.integer(prediction_season[[1]]) != 2026L) {
    return(board)
  }
  context <- data.frame(
    player_key = make_player_key(c(
      "Christian McCaffrey", "De'Von Achane", "Omarion Hampton",
      "Travis Etienne", "Kenneth Walker", "Cam Skattebo",
      "Quinshon Judkins", "Jadarian Price", "Chuba Hubbard",
      "David Montgomery", "Zach Charbonnet", "Bhayshul Tuten",
      "Blake Corum", "Kyren Williams", "Isaac Guerendo",
      "Jaydon Blue", "George Holani", "Kyle Monangai",
      "D'Andre Swift", "Jonah Coleman", "Jonathon Brooks",
      "Jeremiyah Love"
    )),
    games_floor = c(NA, NA, 15, NA, 15, 13, 15, NA, 14, NA, NA, 15, NA, NA, NA, 8, 8, NA, NA, NA, 13, NA),
    games_cap = c(NA, NA, NA, NA, NA, NA, NA, NA, 14.5, NA, 13, NA, NA, NA, 2, NA, NA, 13.25, NA, NA, NA, 14),
    ppg_pct = c(-0.10, -0.14, 0.03, -0.04, 0.08, 0, 0.02, 0, 0.10, 0.16, 0, 0.20, 0.30, -0.05, 0, 0.10, 0.10, 0, 0.01, 0.04, 0.08, 0),
    ppg_floor = c(NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, 11.5, NA, NA, NA, NA, 5.5, NA, NA, NA, NA, NA),
    p10_pct = c(-0.12, -0.10, 0, 0, 0, 0, 0, 0, -0.12, 0, 0, 0, 0, 0, -0.10, 0, 0, -0.12, 0, 0, 0, -0.12),
    p90_pct = c(-0.06, -0.08, 0, -0.05, 0.03, 0, 0, 0, -0.05, 0.03, 0.05, 0.08, 0.05, -0.03, -0.10, 0.03, 0.05, 0, 0.03, 0.10, 0.10, -0.05),
    note = c(
      "Apply a firmer age and post-400-touch workload discount toward the floor.",
      "Apply a firmer total and receiving discount for the Malik Willis environment.",
      "Set a 15-game lead-back floor with a modest play-caller upgrade.",
      "Apply a modest role and upside discount from the prior Jacksonville environment.",
      "Reflect a 15-game bellcow opportunity in Kansas City.",
      "Set a 13-game availability floor while retaining injury uncertainty.",
      "Set a 15-game lead-back availability floor.",
      "Shift the profile from receiving volume toward early-down rushing work.",
      "Remove the stale lead-back floor, cap availability modestly, and reduce workload for the week-to-week hamstring injury and Jonathon Brooks' rising role.",
      "Apply a stronger early-down and goal-line increase while limiting receiving work behind Woody Marks.",
      "Cap availability at 13 games because of the expected early-season PUP absence.",
      "Treat Tuten as the clear 15-game lead back with efficiency-supported upside while preserving committee risk.",
      "Increase the rushing share toward a drive-based split with Kyren Williams.",
      "Reduce the workload ceiling to reflect a larger Blake Corum share.",
      "Reduce the projection to a fringe-roster availability outcome.",
      "Apply a small backup-role opportunity increase behind Javonte Williams.",
      "Reflect an early-season receiving-back role while Zach Charbonnet is unavailable.",
      "Cap season availability after the knee injury and widen the downside without changing the talent evaluation or OMFG.",
      "Apply only a small temporary workload increase while Monangai is unavailable; do not treat the role as a full-season bellcow change.",
      "Apply a modest role increase with additional ceiling for the reported rise in Denver's running-back rotation.",
      "Increase Brooks modestly for healthy first-team work and rising backfield momentum while retaining substantial knee and workload uncertainty.",
      "Reduce season availability and widen the downside for the reported high-ankle injury without changing the talent evaluation or OMFG."
    ),
    stringsAsFactors = FALSE
  )
  out <- board
  if (!"context_adjustment_count" %in% names(out)) out$context_adjustment_count <- 0L
  if (!"manual_context_note" %in% names(out)) out$manual_context_note <- ""
  out$rb_final_review_projection_applied <- FALSE
  out$rb_final_review_games_before <- NA_real_
  out$rb_final_review_games_after <- NA_real_
  out$rb_final_review_ppg_before <- NA_real_
  out$rb_final_review_ppg_after <- NA_real_
  out$rb_final_review_total_multiplier <- 1
  out$rb_final_review_note <- ""

  range_pct <- list(
    adjusted_p10_points = context$p10_pct,
    adjusted_p25_points = rep(0, nrow(context)),
    adjusted_p50_points = rep(0, nrow(context)),
    adjusted_p75_points = rep(0, nrow(context)),
    adjusted_p90_points = context$p90_pct
  )
  for (i in seq_len(nrow(context))) {
    rows <- which(out$position == "RB" & out$player_key == context$player_key[[i]])
    if (length(rows) == 0L) next
    before_games <- sos_prob_num(out$adjusted_projected_games[rows])
    before_ppg <- sos_prob_num(out$adjusted_projected_ppg[rows])
    after_games <- before_games
    if (is.finite(context$games_floor[[i]])) after_games <- pmax(after_games, context$games_floor[[i]])
    if (is.finite(context$games_cap[[i]])) after_games <- pmin(after_games, context$games_cap[[i]])
    after_games <- pmin(17, pmax(0, after_games))
    after_ppg <- pmax(0, before_ppg * (1 + context$ppg_pct[[i]]))
    if (is.finite(context$ppg_floor[[i]])) after_ppg <- pmax(after_ppg, context$ppg_floor[[i]])
    total_multiplier <- (after_games * after_ppg) / pmax(before_games * before_ppg, 1e-6)
    out$rb_final_review_projection_applied[rows] <- TRUE
    out$rb_final_review_games_before[rows] <- before_games
    out$rb_final_review_games_after[rows] <- after_games
    out$rb_final_review_ppg_before[rows] <- before_ppg
    out$rb_final_review_ppg_after[rows] <- after_ppg
    out$rb_final_review_total_multiplier[rows] <- total_multiplier
    out$rb_final_review_note[rows] <- context$note[[i]]
    out$adjusted_projected_games[rows] <- after_games
    out$adjusted_projected_ppg[rows] <- after_ppg
    for (col in intersect(names(range_pct), names(out))) {
      out[[col]][rows] <- pmax(
        0,
        sos_prob_num(out[[col]][rows]) * total_multiplier * (1 + range_pct[[col]][[i]])
      )
    }
    out$context_adjustment_count[rows] <-
      dplyr::coalesce(sos_prob_num(out$context_adjustment_count[rows]), 0) + 1L
    existing_note <- dplyr::coalesce(as.character(out$manual_context_note[rows]), "")
    out$manual_context_note[rows] <- ifelse(
      nzchar(existing_note),
      paste(existing_note, context$note[[i]], sep = " | "),
      context$note[[i]]
    )
  }
  out <- sos_enforce_projection_ranges(
    out,
    c(
      "adjusted_p10_points", "adjusted_p25_points", "adjusted_p50_points",
      "adjusted_p75_points", "adjusted_p90_points"
    )
  ) |>
    dplyr::mutate(
      adjusted_average_range_score = (
        .data$adjusted_p25_points + .data$adjusted_p50_points + .data$adjusted_p75_points
      ) / 3
    ) |>
    dplyr::group_by(.data$position) |>
    dplyr::mutate(
      manual_adjusted_projection_rank = rank(
        -.data$adjusted_average_range_score,
        ties.method = "first",
        na.last = "keep"
      )
    ) |>
    dplyr::ungroup()
  out
}

build_core_sos_rb_final_review_projection_audit <- function(board, prediction_season = 2026L) {
  rb <- board[board$position == "RB", , drop = FALSE]
  data.frame(
    position = "RB",
    prediction_season = as.integer(prediction_season[[1]]),
    rows = nrow(rb),
    adjusted_rows = sum(rb$rb_final_review_projection_applied, na.rm = TRUE),
    max_abs_games_change = max(
      abs(rb$rb_final_review_games_after - rb$rb_final_review_games_before),
      na.rm = TRUE
    ),
    max_abs_ppg_pct = max(
      abs(rb$rb_final_review_ppg_after / pmax(rb$rb_final_review_ppg_before, 1e-6) - 1),
      na.rm = TRUE
    ),
    games_out_of_bounds = sum(
      !is.finite(rb$adjusted_projected_games) |
        rb$adjusted_projected_games < 0 |
        rb$adjusted_projected_games > 17
    ),
    range_order_violations = sum(
      rb$adjusted_p10_points > rb$adjusted_p25_points |
        rb$adjusted_p25_points > rb$adjusted_p50_points |
        rb$adjusted_p50_points > rb$adjusted_p75_points |
        rb$adjusted_p75_points > rb$adjusted_p90_points,
      na.rm = TRUE
    ),
    status = if (
      all(is.finite(rb$adjusted_p50_points)) &&
        all(rb$adjusted_projected_games >= 0 & rb$adjusted_projected_games <= 17) &&
        !any(
          rb$adjusted_p10_points > rb$adjusted_p25_points |
            rb$adjusted_p25_points > rb$adjusted_p50_points |
            rb$adjusted_p50_points > rb$adjusted_p75_points |
            rb$adjusted_p75_points > rb$adjusted_p90_points,
          na.rm = TRUE
        )
    ) "PASS" else "FAIL",
    stringsAsFactors = FALSE
  )
}

sos_apply_wr_final_review_projection_context <- function(
    board,
    prediction_season = 2026L
) {
  if (is.null(board) || nrow(board) == 0L || as.integer(prediction_season[[1]]) != 2026L) {
    return(board)
  }
  context <- data.frame(
    player_key = make_player_key(c(
      "Jaxon Smith-Njigba", "CeeDee Lamb", "Rashee Rice", "Ladd McConkey",
      "Jaylen Waddle", "Courtland Sutton", "Michael Pittman", "DK Metcalf",
      "Rome Odunze", "Christian Watson", "Alec Pierce", "Marvin Harrison",
      "Luther Burden", "Michael Wilson", "Parker Washington", "Brian Thomas",
      "Stefon Diggs", "Travis Hunter", "De'Zhaun Stribling", "Denzel Boston",
      "Adonai Mitchell", "Dontayvion Wicks", "Drake London", "Malik Nabers",
      "Mike Evans", "DJ Moore", "KC Concepcion", "Jordyn Tyson"
    )),
    team_override = c(
      NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,
      "WAS", NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
    ),
    games_floor = c(
      NA, 15, 15, NA, NA, NA, NA, NA, 15, 15, NA, 15, NA, NA, NA, NA,
      NA, NA, 15, 14, NA, 15, 15, 13, 13, NA, NA, NA
    ),
    games_cap = c(
      NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, 13, NA, NA, NA, NA, NA,
      NA, 10, NA, NA, NA, NA, NA, NA, NA, NA, NA, 11
    ),
    ppg_pct = c(
      -0.05, 0.06, 0.05, 0.10, 0.12, -0.08, 0.04, -0.08, 0.08, 0.12,
      -0.10, 0.05, 0.15, -0.12, 0.12, -0.07, 0.08, -0.25, 0.25, 0.12,
      0.15, 0.25, 0, 0.03, 0.05, 0.08, 0.04, 0
    ),
    ppg_floor = c(
      NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,
      NA, NA, 8, NA, NA, 8, NA, NA, NA, NA, NA, NA
    ),
    p10_pct = c(
      -0.03, 0, 0, 0, 0, -0.03, 0, -0.03, 0, 0, -0.05, 0, 0, -0.03,
      0, -0.03, 0, -0.08, 0, 0, 0, 0, 0, 0.01, 0.01, 0.01, 0, -0.10
    ),
    p90_pct = c(
      -0.03, 0.03, 0.03, 0.03, 0.04, -0.03, 0.03, -0.03, 0.03, 0.05,
      -0.05, 0.05, 0.06, -0.04, 0.04, -0.03, 0.03, -0.10, 0.08, 0.04,
      0.05, 0.08, 0.02, 0.04, 0.03, 0.03, 0.08, -0.05
    ),
    note = c(
      "Apply a slight downgrade for the lesser play-caller environment.",
      "Set a 15-game floor and preserve Lamb as Dallas's lead target over George Pickens.",
      "Set a 15-game floor and restore healthy lead-receiver volume.",
      "Apply a clear No. 1 receiver target floor with a Mike McDaniel play-caller upgrade.",
      "Treat Waddle as Denver's No. 1 receiver and increase his target share.",
      "Reduce Sutton's target share after Jaylen Waddle's arrival.",
      "Treat Pittman as the likely Pittsburgh target leader with Aaron Rodgers.",
      "Reduce Metcalf below Pittman in Pittsburgh's target distribution.",
      "Set a 15-game floor and increase Odunze's established role projection.",
      "Set a 15-game healthy floor and increase Watson's share in a simplified rotation.",
      "Cap early-season availability and reduce Pierce for the current health uncertainty.",
      "Set a 15-game floor and increase Harrison as Arizona's likely target leader.",
      "Increase Burden for a second-year breakout and the vacated DJ Moore volume.",
      "Reduce Wilson using his on-field splits alongside Marvin Harrison.",
      "Increase Parker Washington for an expanded Jacksonville role.",
      "Apply a slight Brian Thomas reduction for Parker Washington's larger role.",
      "Move Diggs to Washington and treat him as the No. 2 target behind Terry McLaurin.",
      "Reduce Hunter to a fourth-receiver role ceiling.",
      "Treat Stribling as San Francisco's No. 2 receiver with Ricky Pearsall unavailable.",
      "Increase Boston as Cleveland's starting perimeter receiver.",
      "Increase Mitchell for a larger-than-expected Jets role.",
      "Treat Wicks as a starting Philadelphia receiver and increase his opportunity.",
      "Set a 15-game floor and scale London's receiving production to the added availability.",
      "Increase Nabers for improving Week 1 availability while retaining post-injury uncertainty.",
      "Set a 13-game floor and add a modest profile-based production increase.",
      "Increase Moore as Buffalo's likely No. 1 receiver without assigning a dominant target share.",
      "Apply a modest central and ceiling increase for a reported full-time path and manufactured-touch role while retaining rookie uncertainty.",
      "Cap availability at 11 games and widen the downside after the confirmed roughly two-month hamstring absence; preserve OMFG as the healthy-talent evaluation."
    ),
    stringsAsFactors = FALSE
  )
  out <- board
  if (!"context_adjustment_count" %in% names(out)) out$context_adjustment_count <- 0L
  if (!"manual_context_note" %in% names(out)) out$manual_context_note <- ""
  if (!"manual_team_override" %in% names(out)) out$manual_team_override <- ""
  out$wr_final_review_projection_applied <- FALSE
  out$wr_final_review_games_before <- NA_real_
  out$wr_final_review_games_after <- NA_real_
  out$wr_final_review_ppg_before <- NA_real_
  out$wr_final_review_ppg_after <- NA_real_
  out$wr_final_review_total_multiplier <- 1
  out$wr_final_review_note <- ""

  for (i in seq_len(nrow(context))) {
    rows <- which(out$position == "WR" & out$player_key == context$player_key[[i]])
    if (length(rows) == 0L) next
    before_games <- sos_prob_num(out$adjusted_projected_games[rows])
    before_ppg <- sos_prob_num(out$adjusted_projected_ppg[rows])
    after_games <- before_games
    if (is.finite(context$games_floor[[i]])) after_games <- pmax(after_games, context$games_floor[[i]])
    if (is.finite(context$games_cap[[i]])) after_games <- pmin(after_games, context$games_cap[[i]])
    after_games <- pmin(17, pmax(0, after_games))
    after_ppg <- pmax(0, before_ppg * (1 + context$ppg_pct[[i]]))
    if (is.finite(context$ppg_floor[[i]])) after_ppg <- pmax(after_ppg, context$ppg_floor[[i]])
    total_multiplier <- (after_games * after_ppg) / pmax(before_games * before_ppg, 1e-6)
    if (!is.na(context$team_override[[i]]) && nzchar(context$team_override[[i]])) {
      out$current_team[rows] <- context$team_override[[i]]
      out$next_team[rows] <- context$team_override[[i]]
      out$manual_team_override[rows] <- context$team_override[[i]]
    }
    out$wr_final_review_projection_applied[rows] <- TRUE
    out$wr_final_review_games_before[rows] <- before_games
    out$wr_final_review_games_after[rows] <- after_games
    out$wr_final_review_ppg_before[rows] <- before_ppg
    out$wr_final_review_ppg_after[rows] <- after_ppg
    out$wr_final_review_total_multiplier[rows] <- total_multiplier
    out$wr_final_review_note[rows] <- context$note[[i]]
    out$adjusted_projected_games[rows] <- after_games
    out$adjusted_projected_ppg[rows] <- after_ppg
    range_pct <- c(
      adjusted_p10_points = context$p10_pct[[i]], adjusted_p25_points = 0,
      adjusted_p50_points = 0, adjusted_p75_points = 0,
      adjusted_p90_points = context$p90_pct[[i]]
    )
    for (col in intersect(names(range_pct), names(out))) {
      out[[col]][rows] <- pmax(0, sos_prob_num(out[[col]][rows]) * total_multiplier * (1 + range_pct[[col]]))
    }
    out$context_adjustment_count[rows] <- dplyr::coalesce(
      sos_prob_num(out$context_adjustment_count[rows]), 0
    ) + 1L
    existing_note <- dplyr::coalesce(as.character(out$manual_context_note[rows]), "")
    out$manual_context_note[rows] <- ifelse(
      nzchar(existing_note), paste(existing_note, context$note[[i]], sep = " | "), context$note[[i]]
    )
  }
  out <- sos_enforce_projection_ranges(
    out,
    c("adjusted_p10_points", "adjusted_p25_points", "adjusted_p50_points", "adjusted_p75_points", "adjusted_p90_points")
  ) |>
    dplyr::mutate(
      adjusted_average_range_score = (
        .data$adjusted_p25_points + .data$adjusted_p50_points + .data$adjusted_p75_points
      ) / 3
    ) |>
    dplyr::group_by(.data$position) |>
    dplyr::mutate(
      manual_adjusted_projection_rank = rank(-.data$adjusted_average_range_score, ties.method = "first", na.last = "keep")
    ) |>
    dplyr::ungroup()
  out
}

build_core_sos_wr_final_review_projection_audit <- function(board, prediction_season = 2026L) {
  wr <- board[board$position == "WR", , drop = FALSE]
  data.frame(
    position = "WR",
    prediction_season = as.integer(prediction_season[[1]]),
    rows = nrow(wr),
    adjusted_rows = sum(wr$wr_final_review_projection_applied, na.rm = TRUE),
    max_abs_games_change = max(abs(wr$wr_final_review_games_after - wr$wr_final_review_games_before), na.rm = TRUE),
    max_abs_ppg_pct = max(abs(wr$wr_final_review_ppg_after / pmax(wr$wr_final_review_ppg_before, 1e-6) - 1), na.rm = TRUE),
    games_out_of_bounds = sum(!is.finite(wr$adjusted_projected_games) | wr$adjusted_projected_games < 0 | wr$adjusted_projected_games > 17),
    range_order_violations = sum(
      wr$adjusted_p10_points > wr$adjusted_p25_points |
        wr$adjusted_p25_points > wr$adjusted_p50_points |
        wr$adjusted_p50_points > wr$adjusted_p75_points |
        wr$adjusted_p75_points > wr$adjusted_p90_points,
      na.rm = TRUE
    ),
    team_override_failures = sum(
      wr$player_key == make_player_key("Stefon Diggs") &
        (wr$current_team != "WAS" | wr$next_team != "WAS"),
      na.rm = TRUE
    ),
    status = if (
      all(is.finite(wr$adjusted_p50_points)) &&
        all(wr$adjusted_projected_games >= 0 & wr$adjusted_projected_games <= 17) &&
        sum(
          wr$player_key == make_player_key("Stefon Diggs") &
            (wr$current_team != "WAS" | wr$next_team != "WAS"),
          na.rm = TRUE
        ) == 0L
    ) "PASS" else "FAIL",
    stringsAsFactors = FALSE
  )
}

sos_apply_te_final_review_projection_context <- function(
    board,
    prediction_season = 2026L
) {
  if (is.null(board) || nrow(board) == 0L || as.integer(prediction_season[[1]]) != 2026L) {
    return(board)
  }
  context <- data.frame(
    player_key = make_player_key(c(
      "Trey McBride", "Brock Bowers", "George Kittle",
      "Terrance Ferguson", "Colby Parkinson", "Darren Waller"
    )),
    team_override = c(NA, NA, NA, NA, NA, "CAR"),
    games_floor = c(NA, 15, NA, NA, NA, NA),
    games_cap = c(NA, NA, NA, NA, NA, NA),
    ppg_pct = c(-0.08, 0.08, -0.07, 0.25, -0.08, 0),
    p10_pct = c(-0.02, 0.01, -0.03, 0, -0.02, 0),
    p90_pct = c(-0.03, 0.04, -0.02, 0.10, -0.03, 0),
    note = c(
      "Apply a modest projection downgrade for the weaker coaching environment.",
      "Set a 15-game floor and add a modest coaching and quarterback-play upgrade.",
      "Apply a slight injury-risk discount while preserving Kittle's elite per-game profile.",
      "Increase Ferguson for a credible chance to overtake Colby Parkinson as the Rams' lead tight end.",
      "Reduce Parkinson modestly for the increased risk that Ferguson wins the lead role.",
      "Correct Waller's team from Miami to Carolina without forcing a role projection before first-team usage is established."
    ),
    stringsAsFactors = FALSE
  )
  out <- board
  if (!"context_adjustment_count" %in% names(out)) out$context_adjustment_count <- 0L
  if (!"manual_context_note" %in% names(out)) out$manual_context_note <- ""
  if (!"manual_team_override" %in% names(out)) out$manual_team_override <- ""
  out$te_final_review_projection_applied <- FALSE
  out$te_final_review_games_before <- NA_real_
  out$te_final_review_games_after <- NA_real_
  out$te_final_review_ppg_before <- NA_real_
  out$te_final_review_ppg_after <- NA_real_
  out$te_final_review_total_multiplier <- 1
  out$te_final_review_note <- ""

  for (i in seq_len(nrow(context))) {
    rows <- which(out$position == "TE" & out$player_key == context$player_key[[i]])
    if (length(rows) == 0L) next
    before_games <- sos_prob_num(out$adjusted_projected_games[rows])
    before_ppg <- sos_prob_num(out$adjusted_projected_ppg[rows])
    after_games <- before_games
    if (is.finite(context$games_floor[[i]])) after_games <- pmax(after_games, context$games_floor[[i]])
    if (is.finite(context$games_cap[[i]])) after_games <- pmin(after_games, context$games_cap[[i]])
    after_games <- pmin(17, pmax(0, after_games))
    after_ppg <- pmax(0, before_ppg * (1 + context$ppg_pct[[i]]))
    total_multiplier <- (after_games * after_ppg) / pmax(before_games * before_ppg, 1e-6)
    if (!is.na(context$team_override[[i]]) && nzchar(context$team_override[[i]])) {
      out$current_team[rows] <- context$team_override[[i]]
      out$next_team[rows] <- context$team_override[[i]]
      out$manual_team_override[rows] <- context$team_override[[i]]
    }
    out$te_final_review_projection_applied[rows] <- TRUE
    out$te_final_review_games_before[rows] <- before_games
    out$te_final_review_games_after[rows] <- after_games
    out$te_final_review_ppg_before[rows] <- before_ppg
    out$te_final_review_ppg_after[rows] <- after_ppg
    out$te_final_review_total_multiplier[rows] <- total_multiplier
    out$te_final_review_note[rows] <- context$note[[i]]
    out$adjusted_projected_games[rows] <- after_games
    out$adjusted_projected_ppg[rows] <- after_ppg
    range_pct <- c(
      adjusted_p10_points = context$p10_pct[[i]], adjusted_p25_points = 0,
      adjusted_p50_points = 0, adjusted_p75_points = 0,
      adjusted_p90_points = context$p90_pct[[i]]
    )
    for (col in intersect(names(range_pct), names(out))) {
      out[[col]][rows] <- pmax(
        0,
        sos_prob_num(out[[col]][rows]) * total_multiplier * (1 + range_pct[[col]])
      )
    }
    out$context_adjustment_count[rows] <- dplyr::coalesce(
      sos_prob_num(out$context_adjustment_count[rows]), 0
    ) + 1L
    existing_note <- dplyr::coalesce(as.character(out$manual_context_note[rows]), "")
    out$manual_context_note[rows] <- ifelse(
      nzchar(existing_note),
      paste(existing_note, context$note[[i]], sep = " | "),
      context$note[[i]]
    )
  }
  out <- sos_enforce_projection_ranges(
    out,
    c("adjusted_p10_points", "adjusted_p25_points", "adjusted_p50_points", "adjusted_p75_points", "adjusted_p90_points")
  ) |>
    dplyr::mutate(
      adjusted_average_range_score = (
        .data$adjusted_p25_points + .data$adjusted_p50_points + .data$adjusted_p75_points
      ) / 3
    ) |>
    dplyr::group_by(.data$position) |>
    dplyr::mutate(
      manual_adjusted_projection_rank = rank(
        -.data$adjusted_average_range_score,
        ties.method = "first",
        na.last = "keep"
      )
    ) |>
    dplyr::ungroup()
  out
}

build_core_sos_te_final_review_projection_audit <- function(board, prediction_season = 2026L) {
  te <- board[board$position == "TE", , drop = FALSE]
  data.frame(
    position = "TE",
    prediction_season = as.integer(prediction_season[[1]]),
    rows = nrow(te),
    adjusted_rows = sum(te$te_final_review_projection_applied, na.rm = TRUE),
    max_abs_games_change = max(
      abs(te$te_final_review_games_after - te$te_final_review_games_before),
      na.rm = TRUE
    ),
    max_abs_ppg_pct = max(
      abs(te$te_final_review_ppg_after / pmax(te$te_final_review_ppg_before, 1e-6) - 1),
      na.rm = TRUE
    ),
    games_out_of_bounds = sum(
      !is.finite(te$adjusted_projected_games) |
        te$adjusted_projected_games < 0 |
        te$adjusted_projected_games > 17
    ),
    range_order_violations = sum(
      te$adjusted_p10_points > te$adjusted_p25_points |
        te$adjusted_p25_points > te$adjusted_p50_points |
        te$adjusted_p50_points > te$adjusted_p75_points |
        te$adjusted_p75_points > te$adjusted_p90_points,
      na.rm = TRUE
    ),
    team_override_failures = sum(
      te$player_key == make_player_key("Darren Waller") &
        (te$current_team != "CAR" | te$next_team != "CAR"),
      na.rm = TRUE
    ),
    status = if (
      all(is.finite(te$adjusted_p50_points)) &&
        all(te$adjusted_projected_games >= 0 & te$adjusted_projected_games <= 17) &&
        sum(
          te$player_key == make_player_key("Darren Waller") &
            (te$current_team != "CAR" | te$next_team != "CAR"),
          na.rm = TRUE
        ) == 0L &&
        max(
          abs(te$te_final_review_ppg_after / pmax(te$te_final_review_ppg_before, 1e-6) - 1),
          na.rm = TRUE
        ) <= 0.25 + 1e-8
    ) "PASS" else "FAIL",
    stringsAsFactors = FALSE
  )
}

sos_apply_dst_final_review_projection_context <- function(
    board,
    prediction_season = 2026L
) {
  if (is.null(board) || nrow(board) == 0L || as.integer(prediction_season[[1]]) != 2026L) {
    return(board)
  }
  out <- board
  if (!"context_adjustment_count" %in% names(out)) out$context_adjustment_count <- 0L
  if (!"manual_context_note" %in% names(out)) out$manual_context_note <- ""
  out$dst_final_review_projection_applied <- FALSE
  out$dst_final_review_ppg_before <- NA_real_
  out$dst_final_review_ppg_after <- NA_real_
  out$dst_final_review_total_multiplier <- 1
  out$dst_final_review_note <- ""

  rows <- which(
    out$position == "DST" &
      out$player_key == make_player_key("Los Angeles Rams")
  )
  if (length(rows) > 0L) {
    before_ppg <- sos_prob_num(out$adjusted_projected_ppg[rows])
    after_ppg <- before_ppg * 1.09
    range_multiplier <- c(
      adjusted_p10_points = 1.06,
      adjusted_p25_points = 1.075,
      adjusted_p50_points = 1.09,
      adjusted_p75_points = 1.105,
      adjusted_p90_points = 1.12
    )
    note <- paste(
      "Move the Rams into the tier-one DST range after adding Myles Garrett;",
      "concentrate the projection gain in pass-rush pressure and preserve normal turnover variance."
    )
    out$dst_final_review_projection_applied[rows] <- TRUE
    out$dst_final_review_ppg_before[rows] <- before_ppg
    out$dst_final_review_ppg_after[rows] <- after_ppg
    out$dst_final_review_total_multiplier[rows] <- 1.09
    out$dst_final_review_note[rows] <- note
    out$adjusted_projected_ppg[rows] <- after_ppg
    for (col in intersect(names(range_multiplier), names(out))) {
      out[[col]][rows] <- pmax(
        0,
        sos_prob_num(out[[col]][rows]) * range_multiplier[[col]]
      )
    }
    out$context_adjustment_count[rows] <- dplyr::coalesce(
      sos_prob_num(out$context_adjustment_count[rows]), 0
    ) + 1L
    existing_note <- dplyr::coalesce(as.character(out$manual_context_note[rows]), "")
    out$manual_context_note[rows] <- ifelse(
      nzchar(existing_note),
      paste(existing_note, note, sep = " | "),
      note
    )
  }

  out <- sos_enforce_projection_ranges(
    out,
    c(
      "adjusted_p10_points", "adjusted_p25_points", "adjusted_p50_points",
      "adjusted_p75_points", "adjusted_p90_points"
    )
  ) |>
    dplyr::mutate(
      adjusted_average_range_score = (
        .data$adjusted_p25_points + .data$adjusted_p50_points + .data$adjusted_p75_points
      ) / 3
    ) |>
    dplyr::group_by(.data$position) |>
    dplyr::mutate(
      manual_adjusted_projection_rank = rank(
        -.data$adjusted_average_range_score,
        ties.method = "first",
        na.last = "keep"
      )
    ) |>
    dplyr::ungroup()
  out
}

build_core_sos_dst_final_review_projection_audit <- function(board, prediction_season = 2026L) {
  dst <- board[board$position == "DST", , drop = FALSE]
  rams <- dst$player_key == make_player_key("Los Angeles Rams")
  data.frame(
    position = "DST",
    prediction_season = as.integer(prediction_season[[1]]),
    rows = nrow(dst),
    adjusted_rows = sum(dst$dst_final_review_projection_applied, na.rm = TRUE),
    rams_rows = sum(rams, na.rm = TRUE),
    max_abs_ppg_pct = max(
      abs(dst$dst_final_review_ppg_after / pmax(dst$dst_final_review_ppg_before, 1e-6) - 1),
      na.rm = TRUE
    ),
    range_order_violations = sum(
      dst$adjusted_p10_points > dst$adjusted_p25_points |
        dst$adjusted_p25_points > dst$adjusted_p50_points |
        dst$adjusted_p50_points > dst$adjusted_p75_points |
        dst$adjusted_p75_points > dst$adjusted_p90_points,
      na.rm = TRUE
    ),
    status = if (
      sum(rams, na.rm = TRUE) == 1L &&
        sum(dst$dst_final_review_projection_applied, na.rm = TRUE) == 1L &&
        all(is.finite(dst$adjusted_p50_points)) &&
        max(
          abs(dst$dst_final_review_ppg_after / pmax(dst$dst_final_review_ppg_before, 1e-6) - 1),
          na.rm = TRUE
        ) <= 0.10 + 1e-8
    ) "PASS" else "FAIL",
    stringsAsFactors = FALSE
  )
}

sos_apply_nfl_context_brief <- function(board, prediction_season = 2026L) {
  if (is.null(board) || nrow(board) == 0L || as.integer(prediction_season[[1]]) != 2026L) {
    return(list(board = board, audit = data.frame()))
  }
  context <- data.frame(
    position = c("WR", "RB", "RB", "WR", "TE", "TE"),
    player = c("Jayden Higgins", "Alvin Kamara", "Najee Harris", "Keenan Allen", "Darren Waller", "Zach Ertz"),
    team_override = c("HOU", "NO", "NYG", "IND", "CAR", "FA"),
    games_delta = c(0, -1.5, 0, 0, 0, 0),
    games_cap = c(0, NA, NA, 13, NA, 0),
    ppg_multiplier = c(0, 1, 1, 0.90, 1, 0),
    forced_inactive = c(TRUE, FALSE, FALSE, FALSE, FALSE, TRUE),
    event_type = c(
      "season_ending_injury", "availability_only_injury", "confirmed_signing",
      "confirmed_signing_and_part_time_role", "source_team_correction", "unsigned_inactive"
    ),
    note = c(
      "Confirmed torn ACL; out for the season. Remove the stale WR2 increase and set the 2026 projection inactive without changing OMFG.",
      "Confirmed MCL sprain expected to cost at least one month. Apply availability only because the reduced role is already reflected upstream.",
      "Confirmed signing with the New York Giants. Correct the team while preserving the current low initial role projection.",
      "Confirmed signing with Indianapolis. Restore him to the active pool as a part-time WR3/11-personnel option with a 13-game cap.",
      "Keep the corrected Carolina team source; no additional projection change is applied.",
      "Not signed with a team; remove from the active 2026 projection pool without changing OMFG."
    ),
    stringsAsFactors = FALSE
  ) |>
    dplyr::mutate(player_key = make_player_key(.data$player))

  out <- board
  if (!"context_adjustment_count" %in% names(out)) out$context_adjustment_count <- 0L
  if (!"manual_context_note" %in% names(out)) out$manual_context_note <- ""
  if (!"manual_team_override" %in% names(out)) out$manual_team_override <- ""
  out$nfl_context_brief_applied <- FALSE
  out$nfl_context_brief_event_type <- ""
  out$nfl_context_brief_games_before <- NA_real_
  out$nfl_context_brief_games_after <- NA_real_
  out$nfl_context_brief_p50_before <- NA_real_
  out$nfl_context_brief_p50_after <- NA_real_
  out$nfl_context_brief_note <- ""

  for (i in seq_len(nrow(context))) {
    rows <- which(
      out$position == context$position[[i]] &
        out$player_key == context$player_key[[i]]
    )
    if (length(rows) == 0L) next
    before_games <- sos_prob_num(out$adjusted_projected_games[rows])
    before_ppg <- sos_prob_num(out$adjusted_projected_ppg[rows])
    before_p50 <- sos_prob_num(out$adjusted_p50_points[rows])
    after_games <- pmin(17, pmax(0, before_games + context$games_delta[[i]]))
    if (is.finite(context$games_cap[[i]])) {
      after_games <- pmin(after_games, context$games_cap[[i]])
    }
    after_ppg <- pmax(0, before_ppg * context$ppg_multiplier[[i]])
    if (isTRUE(context$forced_inactive[[i]])) {
      after_games <- 0
      after_ppg <- 0
    }
    after_p50 <- after_games * after_ppg
    total_multiplier <- ifelse(before_p50 > 1e-8, after_p50 / before_p50, 1)
    out$current_team[rows] <- context$team_override[[i]]
    out$next_team[rows] <- context$team_override[[i]]
    out$manual_team_override[rows] <- context$team_override[[i]]
    out$adjusted_projected_games[rows] <- after_games
    out$adjusted_projected_ppg[rows] <- after_ppg
    for (column in intersect(
      c("adjusted_p10_points", "adjusted_p25_points", "adjusted_p50_points", "adjusted_p75_points", "adjusted_p90_points"),
      names(out)
    )) {
      out[[column]][rows] <- pmax(0, sos_prob_num(out[[column]][rows]) * total_multiplier)
    }
    out$nfl_context_brief_applied[rows] <- TRUE
    out$nfl_context_brief_event_type[rows] <- context$event_type[[i]]
    out$nfl_context_brief_games_before[rows] <- before_games
    out$nfl_context_brief_games_after[rows] <- after_games
    out$nfl_context_brief_p50_before[rows] <- before_p50
    out$nfl_context_brief_p50_after[rows] <- after_p50
    out$nfl_context_brief_note[rows] <- context$note[[i]]
    out$context_adjustment_count[rows] <- dplyr::coalesce(
      sos_prob_num(out$context_adjustment_count[rows]), 0
    ) + 1L
    existing_note <- dplyr::coalesce(as.character(out$manual_context_note[rows]), "")
    out$manual_context_note[rows] <- ifelse(
      nzchar(existing_note), paste(existing_note, context$note[[i]], sep = " | "), context$note[[i]]
    )
  }
  out <- sos_enforce_projection_ranges(
    out,
    c("adjusted_p10_points", "adjusted_p25_points", "adjusted_p50_points", "adjusted_p75_points", "adjusted_p90_points")
  ) |>
    dplyr::mutate(
      adjusted_average_range_score = (
        .data$adjusted_p25_points + .data$adjusted_p50_points + .data$adjusted_p75_points
      ) / 3
    ) |>
    dplyr::group_by(.data$position) |>
    dplyr::mutate(
      manual_adjusted_projection_rank = rank(-.data$adjusted_average_range_score, ties.method = "first", na.last = "keep")
    ) |>
    dplyr::ungroup()

  audit <- out |>
    dplyr::filter(.data$player_key %in% context$player_key) |>
    dplyr::transmute(
      position = .data$position,
      prediction_season = as.integer(prediction_season),
      player = .data$player,
      current_team = .data$current_team,
      event_type = .data$nfl_context_brief_event_type,
      games_before = .data$nfl_context_brief_games_before,
      games_after = .data$nfl_context_brief_games_after,
      p50_before = .data$nfl_context_brief_p50_before,
      p50_after = .data$nfl_context_brief_p50_after,
      status = dplyr::if_else(
        .data$nfl_context_brief_applied &
          is.finite(.data$games_after) & .data$games_after >= 0 & .data$games_after <= 17 &
          is.finite(.data$p50_after) & .data$p50_after >= 0,
        "PASS", "FAIL"
      )
    ) |>
    dplyr::arrange(.data$position, .data$player)
  missing <- dplyr::anti_join(
    context,
    dplyr::distinct(out, .data$position, .data$player_key),
    by = c("position", "player_key")
  )
  if (nrow(missing) > 0L || nrow(audit) != nrow(context) || any(audit$status != "PASS")) {
    stop("NFL Context Brief SOS audit failed.", call. = FALSE)
  }
  list(board = out, audit = audit)
}

sos_apply_qb_pass_attempt_sanity <- function(wide) {
  if (is.null(wide) || nrow(wide) == 0L) return(wide)
  out <- wide
  n <- nrow(out)
  out$stat_qb_pass_attempt_sanity_applied <- FALSE
  out$stat_qb_pass_attempts_before <- NA_real_
  out$stat_qb_pass_attempts_floor <- NA_real_
  out$stat_qb_pass_attempts_delta <- 0
  out$stat_qb_pass_volume_multiplier <- 1
  out$stat_qb_pass_yards_before_volume <- NA_real_
  out$stat_qb_pass_yards_delta <- 0
  if (!all(c("position", "projected_pass_attempts", "projected_pass_yards") %in% names(out))) {
    return(out)
  }
  get_num <- function(col, default = NA_real_) {
    if (col %in% names(out)) return(sos_prob_num(out[[col]]))
    rep(default, n)
  }
  get_flag <- function(col, default = FALSE) {
    if (col %in% names(out)) return(out[[col]] %in% c(TRUE, "TRUE", "true", 1L, "1"))
    rep(default, n)
  }
  get_chr <- function(col, default = "") {
    if (col %in% names(out)) return(tolower(as.character(out[[col]])))
    rep(default, n)
  }
  position <- toupper(as.character(out$position))
  games <- dplyr::coalesce(
    get_num("stat_target_projected_games"),
    get_num("adjusted_projected_games"),
    rep(NA_real_, n)
  )
  rank_reference <- dplyr::coalesce(
    get_num("article_rank"),
    get_num("manual_adjusted_projection_rank"),
    get_num("baseline_projection_rank"),
    rep(NA_real_, n)
  )
  note <- get_chr("manual_context_note")
  active_pool <- get_flag("active_projection_pool", TRUE)
  article_eligible <- get_flag("article_eligible", FALSE)
  attempts_before <- get_num("projected_pass_attempts")
  pass_yards <- get_num("projected_pass_yards")
  rush_yards <- get_num("projected_rush_yards", 0)
  rush_attempts <- get_num("projected_rush_attempts", 0)
  rushing_qb <- grepl("rush|rushing|run|running|mobile|scrambl", note) |
    (is.finite(rush_yards) & rush_yards >= 250) |
    (is.finite(rush_attempts) & rush_attempts >= 55)
  base_attempts_pg <- dplyr::case_when(
    position == "QB" & rank_reference <= 12 ~ 33.5,
    position == "QB" & rank_reference <= 24 ~ 32.5,
    position == "QB" & rank_reference <= 32 ~ 30.5,
    position == "QB" & article_eligible ~ 27.5,
    TRUE ~ 0
  )
  base_attempts_pg <- dplyr::if_else(
    rushing_qb,
    pmax(20, base_attempts_pg - 1.5),
    base_attempts_pg
  )
  role_floor <- games * base_attempts_pg
  yardage_floor <- pass_yards / 8.4
  attempts_floor <- pmax(role_floor, yardage_floor, na.rm = TRUE)
  attempts_floor[!is.finite(attempts_floor)] <- NA_real_
  apply_floor <- position == "QB" &
    active_pool &
    is.finite(attempts_floor) &
    attempts_floor > 0 &
    (!is.finite(attempts_before) | attempts_before < attempts_floor)
  out$stat_qb_pass_attempts_before <- attempts_before
  out$stat_qb_pass_attempts_floor <- attempts_floor
  out$stat_qb_pass_attempt_sanity_applied <- apply_floor
  out$stat_qb_pass_attempts_delta <- dplyr::if_else(
    apply_floor,
    attempts_floor - dplyr::coalesce(attempts_before, 0),
    0
  )
  pass_volume_multiplier <- dplyr::if_else(
    apply_floor & is.finite(attempts_before) & attempts_before > 0,
    pmin(1.12, pmax(1, attempts_floor / attempts_before)),
    1
  )
  pass_yards_before <- get_num("projected_pass_yards")
  out$stat_qb_pass_volume_multiplier <- pass_volume_multiplier
  out$stat_qb_pass_yards_before_volume <- pass_yards_before
  out$projected_pass_attempts[apply_floor] <- attempts_floor[apply_floor]
  out$projected_pass_yards[apply_floor] <- pmax(
    0,
    pass_yards_before[apply_floor] * pass_volume_multiplier[apply_floor]
  )
  out$stat_qb_pass_yards_delta <-
    sos_prob_num(out$projected_pass_yards) - pass_yards_before
  out
}

sos_apply_qb_final_review_stat_context <- function(wide, prediction_season = 2026L) {
  if (is.null(wide) || nrow(wide) == 0L) {
    return(wide)
  }
  out <- wide
  out$qb_final_review_stat_applied <- FALSE
  out$qb_final_review_stat_adjustment_count <- 0L
  out$qb_final_review_stat_note <- ""
  if (as.integer(prediction_season[[1]]) != 2026L) return(out)
  apply_bound <- function(player, column, value, mode, note) {
    rows <- which(out$position == "QB" & out$player_key == make_player_key(player))
    if (length(rows) == 0L || !column %in% names(out)) return(invisible(NULL))
    before <- sos_prob_num(out[[column]][rows])
    after <- if (mode == "floor") pmax(before, value) else pmin(before, value)
    changed <- is.finite(after) & (!is.finite(before) | abs(after - before) > 1e-8)
    if (!any(changed)) return(invisible(NULL))
    changed_rows <- rows[changed]
    out[[column]][changed_rows] <<- after[changed]
    out$qb_final_review_stat_applied[changed_rows] <<- TRUE
    out$qb_final_review_stat_adjustment_count[changed_rows] <<-
      out$qb_final_review_stat_adjustment_count[changed_rows] + 1L
    existing <- out$qb_final_review_stat_note[changed_rows]
    out$qb_final_review_stat_note[changed_rows] <<- ifelse(
      nzchar(existing),
      paste(existing, note, sep = " | "),
      note
    )
    invisible(NULL)
  }

  apply_bound("Drake Maye", "projected_pass_td", 30, "floor", "Passing TD floor reflects the upgraded receiving environment.")
  apply_bound("Drake Maye", "projected_rush_attempts", 90, "floor", "Restore a modest healthy rushing-volume floor.")
  apply_bound("Drake Maye", "projected_rush_yards", 450, "floor", "Restore a modest healthy rushing-yardage floor.")
  apply_bound("Josh Allen", "projected_rush_yards", 525, "floor", "Restore a small portion of the healthy rushing-yardage baseline.")
  apply_bound("Jalen Hurts", "projected_pass_attempts", 490, "cap", "Remove the prior blanket passing-volume boost.")
  apply_bound("Jalen Hurts", "projected_pass_yards", 3850, "cap", "Keep the passing projection below the prior boosted level.")
  apply_bound("Jalen Hurts", "projected_pass_td", 26, "cap", "Keep passing touchdowns separate from Tush Push value.")
  apply_bound("Jalen Hurts", "projected_rush_td", 8.5, "floor", "Restore Tush Push goal-line touchdown usage.")
  apply_bound("Joe Burrow", "projected_pass_attempts", 540, "floor", "Healthy 15-game passing-volume floor.")
  apply_bound("Joe Burrow", "projected_pass_yards", 4300, "floor", "Healthy 15-game passing-yardage floor.")
  apply_bound("Joe Burrow", "projected_pass_td", 33, "floor", "Healthy 15-game passing-touchdown floor.")
  apply_bound("Lamar Jackson", "projected_rush_attempts", 95, "floor", "Increase the healthy-season rushing-volume restoration.")
  apply_bound("Lamar Jackson", "projected_rush_yards", 600, "floor", "Increase the healthy-season rushing-yardage restoration.")
  apply_bound("Patrick Mahomes", "projected_rush_attempts", 50, "cap", "Reduce designed and scramble volume after the ACL injury.")
  apply_bound("Patrick Mahomes", "projected_rush_yards", 300, "cap", "Cap post-ACL rushing yardage without changing passing volume.")
  apply_bound("Patrick Mahomes", "projected_rush_td", 3, "cap", "Apply a modest post-ACL rushing-touchdown cap.")
  apply_bound("Jayden Daniels", "projected_pass_td", 22, "floor", "Apply a modest healthy passing-touchdown floor.")
  apply_bound("Jayden Daniels", "projected_rush_attempts", 90, "floor", "Increase healthy-season rushing volume modestly.")
  apply_bound("Jayden Daniels", "projected_rush_yards", 575, "floor", "Increase healthy-season rushing yardage modestly.")
  apply_bound("Bo Nix", "projected_pass_attempts", 500, "cap", "Cap passing volume below the elite-ceiling tier.")
  apply_bound("Bo Nix", "projected_pass_yards", 3600, "cap", "Cap passing yardage below the elite-ceiling tier.")
  apply_bound("Bo Nix", "projected_pass_td", 23, "cap", "Apply a modest passing-touchdown ceiling.")
  apply_bound("Bo Nix", "projected_rush_attempts", 60, "cap", "Apply a modest rushing-volume ceiling.")
  apply_bound("Bo Nix", "projected_rush_yards", 275, "cap", "Apply a modest rushing-yardage ceiling.")
  apply_bound("Bo Nix", "projected_rush_td", 3, "cap", "Apply a modest rushing-touchdown ceiling.")
  apply_bound("Kirk Cousins", "projected_pass_attempts", 380, "floor", "Opening-day starter passing-volume floor.")
  apply_bound("Kirk Cousins", "projected_pass_yards", 3200, "floor", "Opening-day starter passing-yardage floor.")
  apply_bound("Kirk Cousins", "projected_pass_td", 20, "floor", "Opening-day starter passing-touchdown floor.")
  apply_bound("Matthew Stafford", "projected_pass_td", 29, "cap", "Apply additional passing-TD regression after a 40-TD season.")
  apply_bound("Malik Willis", "projected_rush_attempts", 75, "floor", "Starting mobile-QB rushing-volume floor.")
  apply_bound("Malik Willis", "projected_rush_yards", 425, "floor", "Starting mobile-QB rushing-yardage floor.")
  out
}

sos_apply_rb_final_review_stat_context <- function(wide, prediction_season = 2026L) {
  if (is.null(wide) || nrow(wide) == 0L) return(wide)
  out <- wide
  out$rb_final_review_stat_applied <- FALSE
  out$rb_final_review_stat_adjustment_count <- 0L
  out$rb_final_review_stat_note <- ""
  if (as.integer(prediction_season[[1]]) != 2026L) return(out)

  apply_bound <- function(player, column, value, mode, note) {
    rows <- which(out$position == "RB" & out$player_key == make_player_key(player))
    if (length(rows) == 0L || !column %in% names(out)) return(invisible(NULL))
    before <- sos_prob_num(out[[column]][rows])
    after <- if (mode == "floor") pmax(before, value) else pmin(before, value)
    changed <- is.finite(after) & (!is.finite(before) | abs(after - before) > 1e-8)
    if (!any(changed)) return(invisible(NULL))
    changed_rows <- rows[changed]
    out[[column]][changed_rows] <<- after[changed]
    out$rb_final_review_stat_applied[changed_rows] <<- TRUE
    out$rb_final_review_stat_adjustment_count[changed_rows] <<-
      out$rb_final_review_stat_adjustment_count[changed_rows] + 1L
    existing <- out$rb_final_review_stat_note[changed_rows]
    out$rb_final_review_stat_note[changed_rows] <<- ifelse(
      nzchar(existing),
      paste(existing, note, sep = " | "),
      note
    )
    invisible(NULL)
  }

  apply_bound("Christian McCaffrey", "projected_rush_attempts", 210, "cap", "Cap workload more firmly after a 400-touch season.")
  apply_bound("Christian McCaffrey", "projected_rush_yards", 850, "cap", "Apply a firmer age and workload rushing cap.")
  apply_bound("Christian McCaffrey", "projected_rush_td", 7, "cap", "Apply a firmer rushing-touchdown cap.")
  apply_bound("Christian McCaffrey", "projected_targets", 65, "cap", "Apply a firmer receiving-volume cap.")
  apply_bound("Christian McCaffrey", "projected_receptions", 50, "cap", "Apply a firmer reception cap.")
  apply_bound("Christian McCaffrey", "projected_receiving_yards", 400, "cap", "Apply a firmer receiving-yardage cap.")
  apply_bound("Christian McCaffrey", "projected_receiving_td", 2, "cap", "Apply a firmer receiving-touchdown cap.")

  apply_bound("De'Von Achane", "projected_rush_attempts", 200, "cap", "Apply a modest rushing-volume cap in a weaker offense.")
  apply_bound("De'Von Achane", "projected_rush_yards", 1000, "cap", "Apply a modest rushing-yardage cap in a weaker offense.")
  apply_bound("De'Von Achane", "projected_rush_td", 7, "cap", "Apply a modest rushing-touchdown cap in a weaker offense.")
  apply_bound("De'Von Achane", "projected_targets", 52, "cap", "Reduce RB target share more firmly in the Malik Willis environment.")
  apply_bound("De'Von Achane", "projected_receptions", 41, "cap", "Reduce receptions with a less RB-friendly passer.")
  apply_bound("De'Von Achane", "projected_receiving_yards", 285, "cap", "Reduce the receiving-yardage ceiling more firmly.")
  apply_bound("De'Von Achane", "projected_receiving_td", 1.2, "cap", "Reduce the receiving-touchdown ceiling.")

  apply_bound("Omarion Hampton", "projected_rush_attempts", 230, "floor", "Fifteen-game lead-back rushing floor.")
  apply_bound("Omarion Hampton", "projected_rush_yards", 1000, "floor", "Fifteen-game lead-back rushing-yardage floor.")
  apply_bound("Omarion Hampton", "projected_rush_td", 7, "floor", "Lead-back touchdown floor.")
  apply_bound("Omarion Hampton", "projected_targets", 55, "floor", "Mike McDaniel receiving-opportunity floor.")
  apply_bound("Omarion Hampton", "projected_receptions", 42, "floor", "Mike McDaniel reception floor.")
  apply_bound("Omarion Hampton", "projected_receiving_yards", 320, "floor", "Mike McDaniel receiving-yardage floor.")

  apply_bound("Travis Etienne", "projected_rush_attempts", 210, "cap", "Apply a modest role ceiling in the new environment.")
  apply_bound("Travis Etienne", "projected_rush_yards", 900, "cap", "Apply a modest rushing-yardage ceiling.")
  apply_bound("Travis Etienne", "projected_rush_td", 5.8, "cap", "Apply a modest rushing-touchdown ceiling.")
  apply_bound("Travis Etienne", "projected_receiving_td", 1.2, "cap", "Apply a modest receiving-touchdown ceiling.")

  apply_bound("Kenneth Walker", "projected_rush_attempts", 250, "floor", "Kansas City bellcow rushing-volume floor.")
  apply_bound("Kenneth Walker", "projected_rush_yards", 1100, "floor", "Kansas City bellcow rushing-yardage floor.")
  apply_bound("Kenneth Walker", "projected_rush_td", 8, "floor", "Kansas City goal-line touchdown floor.")
  apply_bound("Kenneth Walker", "projected_targets", 45, "floor", "Bellcow target floor.")
  apply_bound("Kenneth Walker", "projected_receptions", 36, "floor", "Bellcow reception floor.")
  apply_bound("Kenneth Walker", "projected_receiving_yards", 280, "floor", "Bellcow receiving-yardage floor.")

  apply_bound("Cam Skattebo", "projected_rush_attempts", 190, "floor", "Thirteen-game workload floor.")
  apply_bound("Cam Skattebo", "projected_rush_yards", 800, "floor", "Thirteen-game rushing-yardage floor.")
  apply_bound("Cam Skattebo", "projected_rush_td", 6, "floor", "Thirteen-game rushing-touchdown floor.")
  apply_bound("Cam Skattebo", "projected_targets", 50, "floor", "Thirteen-game target floor.")
  apply_bound("Cam Skattebo", "projected_receptions", 40, "floor", "Thirteen-game reception floor.")
  apply_bound("Cam Skattebo", "projected_receiving_yards", 300, "floor", "Thirteen-game receiving-yardage floor.")

  apply_bound("Quinshon Judkins", "projected_rush_attempts", 230, "floor", "Fifteen-game rushing-volume floor.")
  apply_bound("Quinshon Judkins", "projected_rush_yards", 900, "floor", "Fifteen-game rushing-yardage floor.")
  apply_bound("Quinshon Judkins", "projected_rush_td", 7, "floor", "Fifteen-game rushing-touchdown floor.")
  apply_bound("Quinshon Judkins", "projected_targets", 40, "floor", "Fifteen-game target floor.")
  apply_bound("Quinshon Judkins", "projected_receptions", 30, "floor", "Fifteen-game reception floor.")
  apply_bound("Quinshon Judkins", "projected_receiving_yards", 220, "floor", "Fifteen-game receiving-yardage floor.")

  apply_bound("Jadarian Price", "projected_rush_attempts", 180, "floor", "Shift the profile toward early-down rushing work.")
  apply_bound("Jadarian Price", "projected_rush_yards", 800, "floor", "Shift the profile toward rushing yardage.")
  apply_bound("Jadarian Price", "projected_targets", 35, "cap", "Cap receiving work behind George Holani early.")
  apply_bound("Jadarian Price", "projected_receptions", 28, "cap", "Cap receptions behind George Holani early.")
  apply_bound("Jadarian Price", "projected_receiving_yards", 200, "cap", "Cap receiving yardage behind George Holani early.")

  apply_bound("Chuba Hubbard", "projected_rush_attempts", 200, "floor", "Keep a bounded starter rushing floor despite the hamstring injury.")
  apply_bound("Chuba Hubbard", "projected_rush_attempts", 230, "cap", "Cap rushing work for the hamstring injury and Brooks' rising role.")
  apply_bound("Chuba Hubbard", "projected_rush_yards", 825, "floor", "Keep a bounded starter rushing-yardage floor.")
  apply_bound("Chuba Hubbard", "projected_rush_yards", 950, "cap", "Cap rushing yardage for the hamstring injury and committee risk.")
  apply_bound("Chuba Hubbard", "projected_rush_td", 5.5, "floor", "Keep a bounded starter touchdown floor.")
  apply_bound("Chuba Hubbard", "projected_rush_td", 7, "cap", "Cap touchdown volume for the reduced workload outlook.")
  apply_bound("Chuba Hubbard", "projected_targets", 45, "floor", "Keep a modest receiving floor while Brooks' role grows.")
  apply_bound("Chuba Hubbard", "projected_targets", 50, "cap", "Cap receiving opportunity as Brooks earns more work.")
  apply_bound("Chuba Hubbard", "projected_receptions", 35, "floor", "Keep a modest reception floor while Brooks' role grows.")
  apply_bound("Chuba Hubbard", "projected_receptions", 40, "cap", "Cap receptions as Brooks earns more work.")
  apply_bound("Chuba Hubbard", "projected_receiving_yards", 275, "floor", "Keep a modest receiving-yardage floor while Brooks' role grows.")
  apply_bound("Chuba Hubbard", "projected_receiving_yards", 300, "cap", "Cap receiving yardage as Brooks earns more work.")

  apply_bound("Jonathon Brooks", "projected_rush_attempts", 110, "floor", "Raise rushing volume for healthy first-team work and backfield momentum.")
  apply_bound("Jonathon Brooks", "projected_rush_yards", 475, "floor", "Raise rushing yardage for healthy first-team work and backfield momentum.")
  apply_bound("Jonathon Brooks", "projected_rush_td", 4.5, "floor", "Add a modest touchdown floor for the growing role.")
  apply_bound("Jonathon Brooks", "projected_targets", 48, "floor", "Preserve Brooks' receiving-role upside in the committee.")
  apply_bound("Jonathon Brooks", "projected_receptions", 36, "floor", "Preserve Brooks' receiving-role upside in the committee.")
  apply_bound("Jonathon Brooks", "projected_receiving_yards", 225, "floor", "Raise receiving yardage modestly for the growing role.")

  apply_bound("David Montgomery", "projected_rush_attempts", 250, "floor", "Houston lead-rusher volume floor.")
  apply_bound("David Montgomery", "projected_rush_yards", 1050, "floor", "Houston lead-rusher yardage floor.")
  apply_bound("David Montgomery", "projected_rush_td", 10, "floor", "Houston goal-line touchdown floor.")
  apply_bound("David Montgomery", "projected_targets", 30, "cap", "Limit passing work behind Woody Marks.")
  apply_bound("David Montgomery", "projected_receptions", 24, "cap", "Limit receptions behind Woody Marks.")
  apply_bound("David Montgomery", "projected_receiving_yards", 170, "cap", "Limit receiving yardage behind Woody Marks.")

  apply_bound("Bhayshul Tuten", "projected_rush_attempts", 245, "floor", "Jacksonville lead-back rushing floor.")
  apply_bound("Bhayshul Tuten", "projected_rush_yards", 1100, "floor", "Efficiency-supported rushing-yardage floor.")
  apply_bound("Bhayshul Tuten", "projected_rush_td", 8, "floor", "Lead-back touchdown floor with committee risk.")
  apply_bound("Bhayshul Tuten", "projected_targets", 45, "floor", "Lead-back target floor.")
  apply_bound("Bhayshul Tuten", "projected_receptions", 34, "floor", "Lead-back reception floor.")
  apply_bound("Bhayshul Tuten", "projected_receiving_yards", 285, "floor", "Lead-back receiving-yardage floor.")

  apply_bound("Blake Corum", "projected_rush_attempts", 200, "floor", "Drive-split rushing-volume floor.")
  apply_bound("Blake Corum", "projected_rush_yards", 900, "floor", "Drive-split rushing-yardage floor.")
  apply_bound("Blake Corum", "projected_rush_td", 6, "floor", "Preserve Kyren's inside-five edge while raising Corum.")
  apply_bound("Blake Corum", "projected_targets", 20, "floor", "Modest receiving-opportunity floor.")
  apply_bound("Blake Corum", "projected_receptions", 15, "floor", "Modest reception floor.")
  apply_bound("Blake Corum", "projected_receiving_yards", 120, "floor", "Modest receiving-yardage floor.")

  apply_bound("Kyren Williams", "projected_rush_attempts", 230, "cap", "Reduce volume for a larger Blake Corum drive share.")
  apply_bound("Kyren Williams", "projected_rush_yards", 1050, "cap", "Reduce yardage for a larger Blake Corum drive share.")
  apply_bound("Kyren Williams", "projected_rush_td", 8, "cap", "Retain inside-five priority with a bounded ceiling.")
  apply_bound("Kyren Williams", "projected_targets", 45, "cap", "Reduce targets for a larger Blake Corum share.")
  apply_bound("Kyren Williams", "projected_receptions", 35, "cap", "Reduce receptions for a larger Blake Corum share.")
  apply_bound("Kyren Williams", "projected_receiving_yards", 270, "cap", "Reduce receiving yardage for a larger Blake Corum share.")

  apply_bound("Isaac Guerendo", "projected_rush_attempts", 10, "cap", "Fringe-roster rushing cap.")
  apply_bound("Isaac Guerendo", "projected_rush_yards", 45, "cap", "Fringe-roster rushing-yardage cap.")
  apply_bound("Isaac Guerendo", "projected_rush_td", 0.5, "cap", "Fringe-roster touchdown cap.")
  apply_bound("Isaac Guerendo", "projected_targets", 4, "cap", "Fringe-roster target cap.")
  apply_bound("Isaac Guerendo", "projected_receptions", 3, "cap", "Fringe-roster reception cap.")
  apply_bound("Isaac Guerendo", "projected_receiving_yards", 20, "cap", "Fringe-roster receiving-yardage cap.")
  apply_bound("Isaac Guerendo", "projected_receiving_td", 0.2, "cap", "Fringe-roster receiving-touchdown cap.")

  apply_bound("Jaydon Blue", "projected_rush_attempts", 80, "floor", "Backup rushing-opportunity floor.")
  apply_bound("Jaydon Blue", "projected_rush_yards", 350, "floor", "Backup rushing-yardage floor.")
  apply_bound("Jaydon Blue", "projected_rush_td", 2.5, "floor", "Backup touchdown-opportunity floor.")
  apply_bound("Jaydon Blue", "projected_targets", 15, "floor", "Backup target floor.")
  apply_bound("Jaydon Blue", "projected_receptions", 10, "floor", "Backup reception floor.")
  apply_bound("Jaydon Blue", "projected_receiving_yards", 80, "floor", "Backup receiving-yardage floor.")

  apply_bound("George Holani", "projected_rush_attempts", 40, "floor", "Early-season complementary rushing floor.")
  apply_bound("George Holani", "projected_rush_yards", 180, "floor", "Early-season complementary rushing-yardage floor.")
  apply_bound("George Holani", "projected_targets", 35, "floor", "Six-week primary receiving-back target floor.")
  apply_bound("George Holani", "projected_receptions", 28, "floor", "Six-week primary receiving-back reception floor.")
  apply_bound("George Holani", "projected_receiving_yards", 220, "floor", "Six-week primary receiving-back yardage floor.")
  apply_bound("George Holani", "projected_receiving_td", 1, "floor", "Six-week primary receiving-back touchdown floor.")

  if (all(c("projected_rush_yards", "projected_receiving_yards", "projected_scrimmage_yards") %in% names(out))) {
    rb <- out$position == "RB"
    out$projected_scrimmage_yards[rb] <-
      sos_prob_num(out$projected_rush_yards[rb]) +
      sos_prob_num(out$projected_receiving_yards[rb])
  }
  if (all(c("projected_rush_td", "projected_receiving_td", "projected_total_td") %in% names(out))) {
    rb <- out$position == "RB"
    out$projected_total_td[rb] <-
      sos_prob_num(out$projected_rush_td[rb]) +
      sos_prob_num(out$projected_receiving_td[rb])
  }
  out
}

sos_apply_wr_final_review_stat_context <- function(wide, prediction_season = 2026L) {
  if (is.null(wide) || nrow(wide) == 0L) return(wide)
  out <- wide
  out$wr_final_review_stat_applied <- FALSE
  out$wr_final_review_stat_adjustment_count <- 0L
  out$wr_final_review_stat_note <- ""
  if (as.integer(prediction_season[[1]]) != 2026L) return(out)

  apply_bound <- function(player, column, value, mode, note) {
    rows <- which(out$position == "WR" & out$player_key == make_player_key(player))
    if (length(rows) == 0L || !column %in% names(out)) return(invisible(NULL))
    before <- sos_prob_num(out[[column]][rows])
    after <- if (mode == "floor") pmax(before, value) else pmin(before, value)
    changed <- is.finite(after) & (!is.finite(before) | abs(after - before) > 1e-8)
    if (!any(changed)) return(invisible(NULL))
    changed_rows <- rows[changed]
    out[[column]][changed_rows] <<- after[changed]
    out$wr_final_review_stat_applied[changed_rows] <<- TRUE
    out$wr_final_review_stat_adjustment_count[changed_rows] <<-
      out$wr_final_review_stat_adjustment_count[changed_rows] + 1L
    existing <- out$wr_final_review_stat_note[changed_rows]
    out$wr_final_review_stat_note[changed_rows] <<- ifelse(
      nzchar(existing), paste(existing, note, sep = " | "), note
    )
    invisible(NULL)
  }

  apply_bound("Jaxon Smith-Njigba", "projected_targets", 135, "cap", "Slight lesser-play-caller target cap.")
  apply_bound("Jaxon Smith-Njigba", "projected_receptions", 95, "cap", "Slight lesser-play-caller reception cap.")
  apply_bound("Jaxon Smith-Njigba", "projected_receiving_yards", 1300, "cap", "Slight lesser-play-caller yardage cap.")
  apply_bound("Jaxon Smith-Njigba", "projected_receiving_td", 7, "cap", "Slight lesser-play-caller touchdown cap.")

  apply_bound("CeeDee Lamb", "projected_targets", 135, "floor", "Dallas lead-target floor.")
  apply_bound("CeeDee Lamb", "projected_receptions", 90, "floor", "Dallas lead-receiver reception floor.")
  apply_bound("CeeDee Lamb", "projected_receiving_yards", 1250, "floor", "Dallas lead-receiver yardage floor.")
  apply_bound("CeeDee Lamb", "projected_receiving_td", 8, "floor", "Dallas lead-receiver touchdown floor.")
  apply_bound("CeeDee Lamb", "projected_air_yards", 1650, "floor", "Dallas lead-target air-yard floor.")
  apply_bound("CeeDee Lamb", "projected_first_read_targets", 110, "floor", "Dallas lead-target first-read floor.")

  apply_bound("Rashee Rice", "projected_targets", 120, "floor", "Fifteen-game lead-receiver target floor.")
  apply_bound("Rashee Rice", "projected_receptions", 85, "floor", "Fifteen-game reception floor.")
  apply_bound("Rashee Rice", "projected_receiving_yards", 1000, "floor", "Fifteen-game receiving-yardage floor.")
  apply_bound("Rashee Rice", "projected_receiving_yards", 1200, "cap", "Cap the healthy projection at a defensible receiving-yardage ceiling.")
  apply_bound("Rashee Rice", "projected_receiving_td", 7, "floor", "Fifteen-game touchdown floor.")
  apply_bound("Rashee Rice", "projected_receiving_td", 8, "cap", "Cap the healthy projection at a defensible touchdown ceiling.")
  apply_bound("Rashee Rice", "projected_air_yards", 1300, "floor", "Keep air yards coherent with the receiving-yardage projection.")
  apply_bound("Rashee Rice", "projected_first_read_targets", 95, "floor", "Healthy lead-receiver first-read floor.")

  apply_bound("Ladd McConkey", "projected_targets", 110, "floor", "Clear No. 1 receiver target floor.")
  apply_bound("Ladd McConkey", "projected_receptions", 75, "floor", "Clear No. 1 receiver reception floor.")
  apply_bound("Ladd McConkey", "projected_receiving_yards", 1000, "floor", "Mike McDaniel receiving-yardage floor.")
  apply_bound("Ladd McConkey", "projected_receiving_td", 6, "floor", "Mike McDaniel touchdown floor.")
  apply_bound("Ladd McConkey", "projected_air_yards", 1300, "floor", "Clear No. 1 receiver air-yard floor.")

  apply_bound("Jaylen Waddle", "projected_targets", 120, "floor", "Denver No. 1 receiver target floor.")
  apply_bound("Jaylen Waddle", "projected_receptions", 80, "floor", "Denver No. 1 receiver reception floor.")
  apply_bound("Jaylen Waddle", "projected_receiving_yards", 1100, "floor", "Denver No. 1 receiver yardage floor.")
  apply_bound("Jaylen Waddle", "projected_receiving_td", 7, "floor", "Denver No. 1 receiver touchdown floor.")
  apply_bound("Jaylen Waddle", "projected_air_yards", 1450, "floor", "Denver No. 1 receiver air-yard floor.")

  apply_bound("Courtland Sutton", "projected_targets", 90, "cap", "Reduce targets after Waddle's arrival.")
  apply_bound("Courtland Sutton", "projected_receptions", 55, "cap", "Reduce receptions after Waddle's arrival.")
  apply_bound("Courtland Sutton", "projected_receiving_yards", 750, "cap", "Reduce yardage after Waddle's arrival.")
  apply_bound("Courtland Sutton", "projected_receiving_td", 5, "cap", "Reduce touchdown ceiling after Waddle's arrival.")

  apply_bound("Michael Pittman", "projected_targets", 108, "floor", "Modest Pittsburgh target-leader floor.")
  apply_bound("Michael Pittman", "projected_receptions", 74, "floor", "Modest Pittsburgh target-leader reception floor.")
  apply_bound("Michael Pittman", "projected_receiving_yards", 850, "floor", "Modest Pittsburgh target-leader yardage floor.")
  apply_bound("Michael Pittman", "projected_receiving_td", 5, "floor", "Modest Pittsburgh target-leader touchdown floor.")

  apply_bound("DK Metcalf", "projected_targets", 85, "cap", "Cap targets below Pittman in Pittsburgh.")
  apply_bound("DK Metcalf", "projected_receptions", 50, "cap", "Cap receptions below Pittman in Pittsburgh.")
  apply_bound("DK Metcalf", "projected_receiving_yards", 700, "cap", "Cap yardage below Pittman in Pittsburgh.")
  apply_bound("DK Metcalf", "projected_receiving_td", 5, "cap", "Cap touchdowns below Pittman in Pittsburgh.")

  apply_bound("Rome Odunze", "projected_targets", 105, "floor", "Fifteen-game established-role target floor.")
  apply_bound("Rome Odunze", "projected_receptions", 65, "floor", "Fifteen-game reception floor.")
  apply_bound("Rome Odunze", "projected_receiving_yards", 950, "floor", "Fifteen-game yardage floor.")
  apply_bound("Rome Odunze", "projected_receiving_td", 7, "floor", "Fifteen-game touchdown floor.")

  apply_bound("Christian Watson", "projected_targets", 105, "floor", "Healthy simplified-rotation target floor.")
  apply_bound("Christian Watson", "projected_receptions", 65, "floor", "Healthy simplified-rotation reception floor.")
  apply_bound("Christian Watson", "projected_receiving_yards", 1000, "floor", "Healthy simplified-rotation yardage floor.")
  apply_bound("Christian Watson", "projected_receiving_td", 7, "floor", "Healthy simplified-rotation touchdown floor.")
  apply_bound("Christian Watson", "projected_air_yards", 1500, "floor", "Healthy simplified-rotation air-yard floor.")

  apply_bound("Alec Pierce", "projected_targets", 65, "cap", "Health-risk target cap.")
  apply_bound("Alec Pierce", "projected_receptions", 38, "cap", "Health-risk reception cap.")
  apply_bound("Alec Pierce", "projected_receiving_yards", 650, "cap", "Health-risk yardage cap.")
  apply_bound("Alec Pierce", "projected_receiving_td", 4, "cap", "Health-risk touchdown cap.")

  apply_bound("Marvin Harrison", "projected_targets", 120, "floor", "Moderated Arizona target-leader floor.")
  apply_bound("Marvin Harrison", "projected_receptions", 72, "floor", "Moderated Arizona target-leader reception floor.")
  apply_bound("Marvin Harrison", "projected_receiving_yards", 1050, "floor", "Moderated Arizona target-leader yardage floor.")
  apply_bound("Marvin Harrison", "projected_receiving_td", 7, "floor", "Arizona target-leader touchdown floor.")
  apply_bound("Marvin Harrison", "projected_air_yards", 1500, "floor", "Moderated Arizona target-leader air-yard floor.")

  apply_bound("Malik Nabers", "projected_targets", 105, "floor", "Improving Week 1 availability target floor.")
  apply_bound("Malik Nabers", "projected_receptions", 68, "floor", "Improving Week 1 availability reception floor.")
  apply_bound("Malik Nabers", "projected_receiving_yards", 1050, "floor", "Improving Week 1 availability yardage floor.")
  apply_bound("Malik Nabers", "projected_receiving_td", 7, "floor", "Improving Week 1 availability touchdown floor.")
  apply_bound("Malik Nabers", "projected_air_yards", 1300, "floor", "Improving Week 1 availability air-yard floor.")

  apply_bound("Mike Evans", "projected_targets", 80, "floor", "Thirteen-game veteran target floor.")
  apply_bound("Mike Evans", "projected_receptions", 50, "floor", "Thirteen-game veteran reception floor.")
  apply_bound("Mike Evans", "projected_receiving_yards", 800, "floor", "Thirteen-game veteran yardage floor.")
  apply_bound("Mike Evans", "projected_receiving_td", 7, "floor", "Thirteen-game veteran touchdown floor.")

  apply_bound("DJ Moore", "projected_targets", 90, "floor", "Buffalo No. 1 receiver target floor.")
  apply_bound("DJ Moore", "projected_receptions", 58, "floor", "Buffalo No. 1 receiver reception floor.")
  apply_bound("DJ Moore", "projected_receiving_yards", 800, "floor", "Buffalo No. 1 receiver yardage floor.")
  apply_bound("DJ Moore", "projected_receiving_td", 5, "floor", "Buffalo No. 1 receiver touchdown floor.")

  apply_bound("Luther Burden", "projected_targets", 110, "floor", "Breakout target floor after DJ Moore's departure.")
  apply_bound("Luther Burden", "projected_receptions", 75, "floor", "Breakout reception floor.")
  apply_bound("Luther Burden", "projected_receiving_yards", 1000, "floor", "Breakout yardage floor.")
  apply_bound("Luther Burden", "projected_receiving_td", 7, "floor", "Breakout touchdown floor.")
  apply_bound("Luther Burden", "projected_air_yards", 1250, "floor", "Keep breakout air yards coherent with the receiving-yardage projection.")
  apply_bound("Luther Burden", "projected_first_read_targets", 85, "floor", "Breakout first-read target floor.")

  apply_bound("Michael Wilson", "projected_targets", 80, "cap", "Cap targets using Harrison-on-field splits.")
  apply_bound("Michael Wilson", "projected_receptions", 50, "cap", "Cap receptions using Harrison-on-field splits.")
  apply_bound("Michael Wilson", "projected_receiving_yards", 650, "cap", "Cap yardage using Harrison-on-field splits.")
  apply_bound("Michael Wilson", "projected_receiving_td", 4, "cap", "Cap touchdowns using Harrison-on-field splits.")

  apply_bound("Parker Washington", "projected_targets", 95, "floor", "Expanded Jacksonville role target floor.")
  apply_bound("Parker Washington", "projected_receptions", 60, "floor", "Expanded Jacksonville role reception floor.")
  apply_bound("Parker Washington", "projected_receiving_yards", 800, "floor", "Expanded Jacksonville role yardage floor.")
  apply_bound("Parker Washington", "projected_receiving_td", 5, "floor", "Expanded Jacksonville role touchdown floor.")

  apply_bound("Brian Thomas", "projected_targets", 80, "cap", "Slight target cap for Washington's larger role.")
  apply_bound("Brian Thomas", "projected_receptions", 47, "cap", "Slight reception cap for Washington's larger role.")
  apply_bound("Brian Thomas", "projected_receiving_yards", 700, "cap", "Slight yardage cap for Washington's larger role.")
  apply_bound("Brian Thomas", "projected_receiving_td", 4, "cap", "Slight touchdown cap for Washington's larger role.")

  apply_bound("Stefon Diggs", "projected_targets", 95, "floor", "Washington No. 2 target floor.")
  apply_bound("Stefon Diggs", "projected_receptions", 70, "floor", "Washington No. 2 reception floor.")
  apply_bound("Stefon Diggs", "projected_receiving_yards", 800, "floor", "Washington No. 2 yardage floor.")
  apply_bound("Stefon Diggs", "projected_receiving_td", 5, "floor", "Washington No. 2 touchdown floor.")

  apply_bound("Travis Hunter", "projected_targets", 35, "cap", "Fourth-receiver target cap.")
  apply_bound("Travis Hunter", "projected_receptions", 22, "cap", "Fourth-receiver reception cap.")
  apply_bound("Travis Hunter", "projected_receiving_yards", 300, "cap", "Fourth-receiver yardage cap.")
  apply_bound("Travis Hunter", "projected_receiving_td", 2, "cap", "Fourth-receiver touchdown cap.")

  apply_bound("De'Zhaun Stribling", "projected_targets", 90, "floor", "San Francisco No. 2 target floor.")
  apply_bound("De'Zhaun Stribling", "projected_receptions", 55, "floor", "San Francisco No. 2 reception floor.")
  apply_bound("De'Zhaun Stribling", "projected_receiving_yards", 800, "floor", "San Francisco No. 2 yardage floor.")
  apply_bound("De'Zhaun Stribling", "projected_receiving_td", 5, "floor", "San Francisco No. 2 touchdown floor.")

  apply_bound("Denzel Boston", "projected_targets", 75, "floor", "Starting perimeter target floor.")
  apply_bound("Denzel Boston", "projected_receptions", 48, "floor", "Starting perimeter reception floor.")
  apply_bound("Denzel Boston", "projected_receiving_yards", 650, "floor", "Starting perimeter yardage floor.")
  apply_bound("Denzel Boston", "projected_receiving_td", 4, "floor", "Starting perimeter touchdown floor.")

  apply_bound("KC Concepcion", "projected_targets", 72, "floor", "Manufactured-touch role target floor.")
  apply_bound("KC Concepcion", "projected_receptions", 48, "floor", "Manufactured-touch role reception floor.")
  apply_bound("KC Concepcion", "projected_receiving_yards", 525, "floor", "Manufactured-touch role receiving-yardage floor.")
  apply_bound("KC Concepcion", "projected_receiving_td", 3, "floor", "Manufactured-touch role receiving-touchdown floor.")
  apply_bound("KC Concepcion", "projected_rush_attempts", 10, "floor", "Manufactured-touch rushing-attempt floor.")
  apply_bound("KC Concepcion", "projected_rush_yards", 50, "floor", "Manufactured-touch rushing-yardage floor.")

  apply_bound("Jordyn Tyson", "projected_targets", 65.5, "floor", "Pre-compensate the WR historical curve so the final target profile reflects an 11-game season.")
  apply_bound("Jordyn Tyson", "projected_receptions", 44, "floor", "Pre-compensate the WR historical curve so the final reception profile reflects an 11-game season.")
  apply_bound("Jordyn Tyson", "projected_receiving_yards", 457, "floor", "Pre-compensate the WR historical curve so the final yardage profile reflects an 11-game season.")
  apply_bound("Jordyn Tyson", "projected_receiving_td", 2.3, "floor", "Scale the healthy touchdown profile to an 11-game season.")

  apply_bound("Adonai Mitchell", "projected_targets", 80, "floor", "Expanded Jets role target floor.")
  apply_bound("Adonai Mitchell", "projected_receptions", 45, "floor", "Expanded Jets role reception floor.")
  apply_bound("Adonai Mitchell", "projected_receiving_yards", 650, "floor", "Expanded Jets role yardage floor.")
  apply_bound("Adonai Mitchell", "projected_receiving_td", 4, "floor", "Expanded Jets role touchdown floor.")
  apply_bound("Adonai Mitchell", "projected_air_yards", 1200, "floor", "Expanded Jets role air-yard floor.")

  apply_bound("Dontayvion Wicks", "projected_targets", 90, "floor", "Philadelphia starter target floor.")
  apply_bound("Dontayvion Wicks", "projected_receptions", 55, "floor", "Philadelphia starter reception floor.")
  apply_bound("Dontayvion Wicks", "projected_receiving_yards", 800, "floor", "Philadelphia starter yardage floor.")
  apply_bound("Dontayvion Wicks", "projected_receiving_td", 5, "floor", "Philadelphia starter touchdown floor.")

  if (all(c("projected_rush_yards", "projected_receiving_yards", "projected_scrimmage_yards") %in% names(out))) {
    wr <- out$position == "WR"
    out$projected_scrimmage_yards[wr] <- sos_prob_num(out$projected_rush_yards[wr]) + sos_prob_num(out$projected_receiving_yards[wr])
  }
  if (all(c("projected_rush_td", "projected_receiving_td", "projected_total_td") %in% names(out))) {
    wr <- out$position == "WR"
    out$projected_total_td[wr] <- sos_prob_num(out$projected_rush_td[wr]) + sos_prob_num(out$projected_receiving_td[wr])
  }
  out
}

sos_apply_wr_historical_stat_curve <- function(wide, prediction_season = 2026L) {
  if (is.null(wide) || nrow(wide) == 0L) return(wide)
  out <- wide
  out$wr_historical_curve_applied <- FALSE
  out$wr_historical_curve_bucket <- NA_character_
  out$wr_historical_curve_volume_multiplier <- 1
  out$wr_historical_curve_td_multiplier <- 1
  if (as.integer(prediction_season[[1]]) != 2026L) return(out)

  rank_reference <- if ("article_rank_reference" %in% names(out)) {
    sos_prob_num(out$article_rank_reference)
  } else if ("article_rank" %in% names(out)) {
    sos_prob_num(out$article_rank)
  } else {
    rep(NA_real_, nrow(out))
  }
  wr <- out$position == "WR" & is.finite(rank_reference)
  bucket <- dplyr::case_when(
    wr & rank_reference <= 12 ~ "1-12",
    wr & rank_reference <= 24 ~ "13-24",
    wr & rank_reference <= 36 ~ "25-36",
    wr & rank_reference <= 48 ~ "37-48",
    wr & rank_reference <= 60 ~ "49-60",
    wr & rank_reference <= 120 ~ "61-120",
    TRUE ~ NA_character_
  )
  volume_multiplier <- dplyr::case_when(
    bucket == "1-12" ~ 1.035,
    bucket == "13-24" ~ 1.020,
    bucket == "25-36" ~ 1.015,
    bucket == "37-48" ~ 0.980,
    bucket == "49-60" ~ 0.940,
    bucket == "61-120" ~ 0.860,
    TRUE ~ 1
  )
  td_multiplier <- dplyr::case_when(
    bucket == "1-12" ~ 1.060,
    bucket == "13-24" ~ 1.000,
    bucket == "25-36" ~ 1.040,
    bucket == "37-48" ~ 0.980,
    bucket == "49-60" ~ 1.000,
    bucket == "61-120" ~ 0.820,
    TRUE ~ 1
  )
  apply_rows <- wr & !is.na(bucket) &
    (abs(volume_multiplier - 1) > 1e-8 | abs(td_multiplier - 1) > 1e-8)
  volume_cols <- intersect(
    c(
      "projected_targets", "projected_receptions", "projected_receiving_yards",
      "projected_air_yards", "projected_first_read_targets",
      "projected_receiving_first_downs", "projected_end_zone_targets"
    ),
    names(out)
  )
  for (col in volume_cols) {
    before <- sos_prob_num(out[[col]][apply_rows])
    out[[col]][apply_rows] <- pmax(0, before * volume_multiplier[apply_rows])
  }
  if ("projected_receiving_td" %in% names(out)) {
    before_td <- sos_prob_num(out$projected_receiving_td[apply_rows])
    out$projected_receiving_td[apply_rows] <- pmax(
      0,
      before_td * td_multiplier[apply_rows]
    )
  }
  if (all(c("projected_rush_yards", "projected_receiving_yards", "projected_scrimmage_yards") %in% names(out))) {
    out$projected_scrimmage_yards[apply_rows] <-
      sos_prob_num(out$projected_rush_yards[apply_rows]) +
      sos_prob_num(out$projected_receiving_yards[apply_rows])
  }
  if (all(c("projected_rush_td", "projected_receiving_td", "projected_total_td") %in% names(out))) {
    out$projected_total_td[apply_rows] <-
      sos_prob_num(out$projected_rush_td[apply_rows]) +
      sos_prob_num(out$projected_receiving_td[apply_rows])
  }
  out$wr_historical_curve_applied[apply_rows] <- TRUE
  out$wr_historical_curve_bucket[apply_rows] <- bucket[apply_rows]
  out$wr_historical_curve_volume_multiplier[apply_rows] <- volume_multiplier[apply_rows]
  out$wr_historical_curve_td_multiplier[apply_rows] <- td_multiplier[apply_rows]
  if (!"wr_final_review_stat_applied" %in% names(out)) {
    out$wr_final_review_stat_applied <- FALSE
  }
  if (!"wr_final_review_stat_adjustment_count" %in% names(out)) {
    out$wr_final_review_stat_adjustment_count <- 0L
  }
  if (!"wr_final_review_stat_note" %in% names(out)) {
    out$wr_final_review_stat_note <- ""
  }
  out$wr_final_review_stat_applied[apply_rows] <- TRUE
  out$wr_final_review_stat_adjustment_count[apply_rows] <-
    out$wr_final_review_stat_adjustment_count[apply_rows] + 1L
  curve_note <- paste0(
    "Historical WR curve calibration: ", bucket[apply_rows],
    " volume x", sprintf("%.3f", volume_multiplier[apply_rows]),
    ", receiving TD x", sprintf("%.3f", td_multiplier[apply_rows]), "."
  )
  existing_note <- dplyr::coalesce(out$wr_final_review_stat_note[apply_rows], "")
  out$wr_final_review_stat_note[apply_rows] <- ifelse(
    nzchar(existing_note),
    paste(existing_note, curve_note, sep = " | "),
    curve_note
  )
  out
}

sos_apply_te_historical_stat_curve <- function(wide, prediction_season = 2026L) {
  if (is.null(wide) || nrow(wide) == 0L) return(wide)
  out <- wide
  out$te_historical_curve_applied <- FALSE
  out$te_historical_curve_bucket <- NA_character_
  out$te_historical_curve_volume_multiplier <- 1
  out$te_historical_curve_td_multiplier <- 1
  if (as.integer(prediction_season[[1]]) != 2026L) return(out)

  rank_reference <- if ("article_rank_reference" %in% names(out)) {
    sos_prob_num(out$article_rank_reference)
  } else if ("article_rank" %in% names(out)) {
    sos_prob_num(out$article_rank)
  } else {
    rep(NA_real_, nrow(out))
  }
  te <- out$position == "TE" & is.finite(rank_reference)
  bucket <- dplyr::case_when(
    te & rank_reference <= 6 ~ "1-6",
    te & rank_reference <= 12 ~ "7-12",
    te & rank_reference <= 18 ~ "13-18",
    te & rank_reference <= 24 ~ "19-24",
    te & rank_reference <= 36 ~ "25-36",
    te & rank_reference <= 70 ~ "37-70",
    te & rank_reference > 70 ~ "71+",
    TRUE ~ NA_character_
  )
  volume_multiplier <- dplyr::case_when(
    bucket == "1-6" ~ 1.040,
    bucket == "7-12" ~ 1.000,
    bucket == "13-18" ~ 0.960,
    bucket == "19-24" ~ 0.940,
    bucket == "25-36" ~ 0.900,
    bucket == "37-70" ~ 0.700,
    bucket == "71+" ~ 0.850,
    TRUE ~ 1
  )
  td_multiplier <- dplyr::case_when(
    bucket == "1-6" ~ 1.020,
    bucket == "7-12" ~ 1.000,
    bucket == "13-18" ~ 0.970,
    bucket == "19-24" ~ 0.950,
    bucket == "25-36" ~ 0.800,
    bucket == "37-70" ~ 0.700,
    bucket == "71+" ~ 0.800,
    TRUE ~ 1
  )
  apply_rows <- te & !is.na(bucket) &
    (abs(volume_multiplier - 1) > 1e-8 | abs(td_multiplier - 1) > 1e-8)
  volume_cols <- intersect(
    c(
      "projected_targets", "projected_receptions", "projected_receiving_yards",
      "projected_air_yards", "projected_first_read_targets",
      "projected_receiving_first_downs", "projected_end_zone_targets"
    ),
    names(out)
  )
  for (col in volume_cols) {
    before <- sos_prob_num(out[[col]][apply_rows])
    out[[col]][apply_rows] <- pmax(0, before * volume_multiplier[apply_rows])
  }
  if ("projected_receiving_td" %in% names(out)) {
    before_td <- sos_prob_num(out$projected_receiving_td[apply_rows])
    out$projected_receiving_td[apply_rows] <- pmax(
      0,
      before_td * td_multiplier[apply_rows]
    )
  }
  if (all(c("projected_rush_yards", "projected_receiving_yards", "projected_scrimmage_yards") %in% names(out))) {
    out$projected_scrimmage_yards[apply_rows] <-
      sos_prob_num(out$projected_rush_yards[apply_rows]) +
      sos_prob_num(out$projected_receiving_yards[apply_rows])
  }
  if (all(c("projected_rush_td", "projected_receiving_td", "projected_total_td") %in% names(out))) {
    out$projected_total_td[apply_rows] <-
      sos_prob_num(out$projected_rush_td[apply_rows]) +
      sos_prob_num(out$projected_receiving_td[apply_rows])
  }
  out$te_historical_curve_applied[apply_rows] <- TRUE
  out$te_historical_curve_bucket[apply_rows] <- bucket[apply_rows]
  out$te_historical_curve_volume_multiplier[apply_rows] <- volume_multiplier[apply_rows]
  out$te_historical_curve_td_multiplier[apply_rows] <- td_multiplier[apply_rows]
  out
}

sos_apply_te_final_review_stat_context <- function(wide, prediction_season = 2026L) {
  if (is.null(wide) || nrow(wide) == 0L) return(wide)
  out <- wide
  out$te_final_review_stat_applied <- FALSE
  out$te_final_review_stat_adjustment_count <- 0L
  out$te_final_review_stat_note <- ""
  if (as.integer(prediction_season[[1]]) != 2026L) return(out)

  apply_bound <- function(player, column, value, mode, note) {
    rows <- which(out$position == "TE" & out$player_key == make_player_key(player))
    if (length(rows) == 0L || !column %in% names(out)) return(invisible(NULL))
    before <- sos_prob_num(out[[column]][rows])
    after <- if (mode == "floor") pmax(before, value) else pmin(before, value)
    changed <- is.finite(before) & abs(after - before) > 1e-8
    if (!any(changed)) return(invisible(NULL))
    changed_rows <- rows[changed]
    out[[column]][changed_rows] <<- after[changed]
    out$te_final_review_stat_applied[changed_rows] <<- TRUE
    out$te_final_review_stat_adjustment_count[changed_rows] <<-
      out$te_final_review_stat_adjustment_count[changed_rows] + 1L
    existing <- out$te_final_review_stat_note[changed_rows]
    out$te_final_review_stat_note[changed_rows] <<- ifelse(
      nzchar(existing), paste(existing, note, sep = " | "), note
    )
    invisible(NULL)
  }

  apply_bound("Trey McBride", "projected_targets", 130, "cap", "Coaching-downgrade target cap.")
  apply_bound("Trey McBride", "projected_receptions", 96, "cap", "Coaching-downgrade reception cap.")
  apply_bound("Trey McBride", "projected_receiving_yards", 950, "cap", "Coaching-downgrade yardage cap.")
  apply_bound("Trey McBride", "projected_receiving_td", 7, "cap", "Coaching-downgrade touchdown cap.")

  apply_bound("Brock Bowers", "projected_targets", 125, "floor", "Fifteen-game upgraded-environment target floor.")
  apply_bound("Brock Bowers", "projected_receptions", 92, "floor", "Fifteen-game reception floor.")
  apply_bound("Brock Bowers", "projected_receiving_yards", 1050, "floor", "Improved quarterback and coaching yardage floor.")
  apply_bound("Brock Bowers", "projected_receiving_td", 8, "floor", "Improved offensive environment touchdown floor.")
  apply_bound("Brock Bowers", "projected_first_read_targets", 95, "floor", "Lead-target first-read floor.")

  apply_bound("George Kittle", "projected_targets", 74, "cap", "Modest injury-risk target cap.")
  apply_bound("George Kittle", "projected_receptions", 61, "cap", "Modest injury-risk reception cap.")
  apply_bound("George Kittle", "projected_receiving_yards", 680, "cap", "Modest injury-risk yardage cap.")
  apply_bound("George Kittle", "projected_receiving_td", 5.8, "cap", "Modest injury-risk touchdown cap.")

  apply_bound("Terrance Ferguson", "projected_targets", 58, "floor", "Rams lead-role upside target floor.")
  apply_bound("Terrance Ferguson", "projected_receptions", 37, "floor", "Rams lead-role upside reception floor.")
  apply_bound("Terrance Ferguson", "projected_receiving_yards", 410, "floor", "Rams lead-role upside yardage floor.")
  apply_bound("Terrance Ferguson", "projected_receiving_td", 3.8, "floor", "Rams lead-role upside touchdown floor.")
  apply_bound("Terrance Ferguson", "projected_first_read_targets", 41, "floor", "Rams lead-role first-read floor.")
  apply_bound("Terrance Ferguson", "projected_end_zone_targets", 5.2, "floor", "Rams lead-role end-zone floor.")

  apply_bound("Colby Parkinson", "projected_targets", 43, "cap", "Ferguson competition target cap.")
  apply_bound("Colby Parkinson", "projected_receptions", 33, "cap", "Ferguson competition reception cap.")
  apply_bound("Colby Parkinson", "projected_receiving_yards", 330, "cap", "Ferguson competition yardage cap.")
  apply_bound("Colby Parkinson", "projected_receiving_td", 3.3, "cap", "Ferguson competition touchdown cap.")

  if (all(c("projected_rush_yards", "projected_receiving_yards", "projected_scrimmage_yards") %in% names(out))) {
    te <- out$position == "TE"
    out$projected_scrimmage_yards[te] <-
      sos_prob_num(out$projected_rush_yards[te]) + sos_prob_num(out$projected_receiving_yards[te])
  }
  if (all(c("projected_rush_td", "projected_receiving_td", "projected_total_td") %in% names(out))) {
    te <- out$position == "TE"
    out$projected_total_td[te] <-
      sos_prob_num(out$projected_rush_td[te]) + sos_prob_num(out$projected_receiving_td[te])
  }
  out
}

sos_apply_k_historical_stat_curve <- function(wide, prediction_season = 2026L) {
  if (is.null(wide) || nrow(wide) == 0L) return(wide)
  out <- wide
  out$k_historical_curve_applied <- FALSE
  out$k_historical_curve_bucket <- NA_character_
  out$k_historical_curve_multiplier <- 1
  out$k_historical_curve_coherence_multiplier <- 1
  if (as.integer(prediction_season[[1]]) != 2026L) return(out)

  rank_reference <- if ("article_rank_reference" %in% names(out)) {
    sos_prob_num(out$article_rank_reference)
  } else if ("article_rank" %in% names(out)) {
    sos_prob_num(out$article_rank)
  } else {
    rep(NA_real_, nrow(out))
  }
  kicker <- out$position == "K" & is.finite(rank_reference)
  bucket <- dplyr::case_when(
    kicker & rank_reference <= 6 ~ "1-6",
    kicker & rank_reference <= 12 ~ "7-12",
    kicker & rank_reference <= 18 ~ "13-18",
    kicker & rank_reference <= 24 ~ "19-24",
    kicker & rank_reference <= 32 ~ "25-32",
    kicker & rank_reference > 32 ~ "33+",
    TRUE ~ NA_character_
  )
  multiplier <- dplyr::case_when(
    bucket == "1-6" ~ 0.96,
    bucket == "7-12" ~ 0.86,
    bucket == "13-18" ~ 0.89,
    bucket == "19-24" ~ 0.95,
    bucket == "25-32" ~ 0.84,
    bucket == "33+" ~ 0.90,
    TRUE ~ 1
  )
  base_implied_points <- sos_stat_implied_fantasy_points(out)
  apply_rows <- kicker & !is.na(bucket) &
    is.finite(base_implied_points) & base_implied_points > 1
  stat_cols <- intersect(
    c(
      "projected_fga", "projected_fgm",
      "projected_fga_40_49", "projected_fgm_40_49",
      "projected_fga_50_plus", "projected_fgm_50_plus",
      "projected_xpa", "projected_xpm"
    ),
    names(out)
  )
  for (col in stat_cols) {
    out[[col]][apply_rows] <- pmax(
      0,
      sos_prob_num(out[[col]][apply_rows]) * multiplier[apply_rows]
    )
  }
  implied_after_curve <- sos_stat_implied_fantasy_points(out)
  target_before_curve <- if ("stat_target_p50_points" %in% names(out)) {
    sos_prob_num(out$stat_target_p50_points)
  } else {
    base_implied_points
  }
  corrected_target <- target_before_curve * multiplier
  coherence_multiplier <- rep(1, nrow(out))
  coherent_rows <- apply_rows & is.finite(corrected_target) & corrected_target > 0 &
    is.finite(implied_after_curve) & implied_after_curve > 0
  coherence_multiplier[coherent_rows] <-
    corrected_target[coherent_rows] / implied_after_curve[coherent_rows]
  for (col in stat_cols) {
    out[[col]][coherent_rows] <- pmax(
      0,
      sos_prob_num(out[[col]][coherent_rows]) * coherence_multiplier[coherent_rows]
    )
  }
  out$k_historical_curve_applied[apply_rows] <- TRUE
  out$k_historical_curve_bucket[apply_rows] <- bucket[apply_rows]
  out$k_historical_curve_multiplier[apply_rows] <- multiplier[apply_rows]
  out$k_historical_curve_coherence_multiplier[apply_rows] <-
    coherence_multiplier[apply_rows]
  out
}

sos_apply_dst_historical_component_rebalance <- function(wide, prediction_season = 2026L) {
  if (is.null(wide) || nrow(wide) == 0L) return(wide)
  out <- wide
  out$dst_historical_rebalance_applied <- FALSE
  out$dst_historical_rebalance_bucket <- NA_character_
  out$dst_historical_fumble_multiplier <- 1
  out$dst_historical_def_td_multiplier <- 1
  out$dst_historical_interception_multiplier <- 1
  if (as.integer(prediction_season[[1]]) != 2026L) return(out)

  rank_reference <- if ("article_rank_reference" %in% names(out)) {
    sos_prob_num(out$article_rank_reference)
  } else if ("article_rank" %in% names(out)) {
    sos_prob_num(out$article_rank)
  } else {
    rep(NA_real_, nrow(out))
  }
  dst <- out$position == "DST" & is.finite(rank_reference)
  bucket <- dplyr::case_when(
    dst & rank_reference <= 6 ~ "1-6",
    dst & rank_reference <= 12 ~ "7-12",
    dst & rank_reference <= 18 ~ "13-18",
    dst & rank_reference <= 24 ~ "19-24",
    dst & rank_reference <= 32 ~ "25-32",
    TRUE ~ NA_character_
  )
  fumble_multiplier <- dplyr::case_when(
    bucket == "1-6" ~ 0.75,
    bucket == "7-12" ~ 0.77,
    bucket == "13-18" ~ 0.76,
    bucket == "19-24" ~ 0.84,
    bucket == "25-32" ~ 0.80,
    TRUE ~ 1
  )
  def_td_multiplier <- dplyr::case_when(
    bucket == "1-6" ~ 1.07,
    bucket == "7-12" ~ 0.80,
    bucket == "13-18" ~ 0.82,
    bucket == "19-24" ~ 0.86,
    bucket == "25-32" ~ 0.66,
    TRUE ~ 1
  )
  interception_multiplier <- dplyr::case_when(
    bucket == "1-6" ~ 1.00,
    bucket == "7-12" ~ 1.00,
    bucket == "13-18" ~ 1.15,
    bucket == "19-24" ~ 1.17,
    bucket == "25-32" ~ 1.25,
    TRUE ~ 1
  )
  apply_rows <- dst & !is.na(bucket)
  if ("projected_fumbles" %in% names(out)) {
    out$projected_fumbles[apply_rows] <- pmax(
      0,
      sos_prob_num(out$projected_fumbles[apply_rows]) * fumble_multiplier[apply_rows]
    )
  }
  if ("projected_defensive_tds" %in% names(out)) {
    out$projected_defensive_tds[apply_rows] <- pmax(
      0,
      sos_prob_num(out$projected_defensive_tds[apply_rows]) * def_td_multiplier[apply_rows]
    )
  }
  if ("projected_interceptions" %in% names(out)) {
    out$projected_interceptions[apply_rows] <- pmax(
      0,
      sos_prob_num(out$projected_interceptions[apply_rows]) * interception_multiplier[apply_rows]
    )
  }
  out$dst_historical_rebalance_applied[apply_rows] <- TRUE
  out$dst_historical_rebalance_bucket[apply_rows] <- bucket[apply_rows]
  out$dst_historical_fumble_multiplier[apply_rows] <- fumble_multiplier[apply_rows]
  out$dst_historical_def_td_multiplier[apply_rows] <- def_td_multiplier[apply_rows]
  out$dst_historical_interception_multiplier[apply_rows] <- interception_multiplier[apply_rows]
  out
}

sos_apply_dst_final_review_stat_context <- function(wide, prediction_season = 2026L) {
  if (is.null(wide) || nrow(wide) == 0L) return(wide)
  out <- wide
  out$dst_final_review_stat_applied <- FALSE
  out$dst_final_review_stat_adjustment_count <- 0L
  out$dst_final_review_stat_note <- ""
  if (as.integer(prediction_season[[1]]) != 2026L) return(out)

  apply_floor <- function(column, value, note) {
    rows <- which(
      out$position == "DST" &
        out$player_key == make_player_key("Los Angeles Rams")
    )
    if (length(rows) == 0L || !column %in% names(out)) return(invisible(NULL))
    before <- sos_prob_num(out[[column]][rows])
    after <- pmax(before, value)
    changed <- is.finite(before) & abs(after - before) > 1e-8
    if (!any(changed)) return(invisible(NULL))
    changed_rows <- rows[changed]
    out[[column]][changed_rows] <<- after[changed]
    out$dst_final_review_stat_applied[changed_rows] <<- TRUE
    out$dst_final_review_stat_adjustment_count[changed_rows] <<-
      out$dst_final_review_stat_adjustment_count[changed_rows] + 1L
    existing <- out$dst_final_review_stat_note[changed_rows]
    out$dst_final_review_stat_note[changed_rows] <<- ifelse(
      nzchar(existing), paste(existing, note, sep = " | "), note
    )
    invisible(NULL)
  }

  apply_floor(
    "projected_sacks", 52,
    "Myles Garrett pass-rush upgrade establishes a tier-one team sack floor."
  )
  apply_floor(
    "projected_interceptions", 13,
    "Improved pressure establishes a modest interception floor without forcing an extreme turnover spike."
  )
  apply_floor(
    "projected_fumbles", 8.5,
    "Improved pressure establishes a modest fumble-recovery floor."
  )
  apply_floor(
    "projected_defensive_tds", 1.7,
    "Tier-one defensive environment establishes a restrained touchdown floor."
  )
  out
}

sos_promote_final_review_stats_to_projection_board <- function(
    board,
    wide,
    prediction_season = 2026L
) {
  if (is.null(wide) || nrow(wide) == 0L) {
    return(list(board = board, wide = wide, audit = data.frame()))
  }
  if (!"stat_qb_pass_attempt_sanity_applied" %in% names(wide)) {
    wide$stat_qb_pass_attempt_sanity_applied <- FALSE
  }
  if (!"qb_final_review_stat_applied" %in% names(wide)) {
    wide$qb_final_review_stat_applied <- FALSE
  }
  if (!"qb_final_review_projection_applied" %in% names(wide)) {
    wide$qb_final_review_projection_applied <- FALSE
  }
  if (!"rb_final_review_stat_applied" %in% names(wide)) {
    wide$rb_final_review_stat_applied <- FALSE
  }
  if (!"rb_final_review_projection_applied" %in% names(wide)) {
    wide$rb_final_review_projection_applied <- FALSE
  }
  if (!"wr_final_review_stat_applied" %in% names(wide)) {
    wide$wr_final_review_stat_applied <- FALSE
  }
  if (!"wr_final_review_projection_applied" %in% names(wide)) {
    wide$wr_final_review_projection_applied <- FALSE
  }
  if (!"wr_historical_curve_applied" %in% names(wide)) {
    wide$wr_historical_curve_applied <- FALSE
  }
  if (!"te_historical_curve_applied" %in% names(wide)) {
    wide$te_historical_curve_applied <- FALSE
  }
  if (!"te_final_review_stat_applied" %in% names(wide)) {
    wide$te_final_review_stat_applied <- FALSE
  }
  if (!"te_final_review_projection_applied" %in% names(wide)) {
    wide$te_final_review_projection_applied <- FALSE
  }
  if (!"k_historical_curve_applied" %in% names(wide)) {
    wide$k_historical_curve_applied <- FALSE
  }
  stat_update <- wide |>
    dplyr::transmute(
      position = .data$position,
      prediction_season = .data$prediction_season,
      player_key = .data$player_key,
      final_stat_implied_points = sos_prob_num(.data$stat_implied_fantasy_points_after),
      stat_qb_pass_attempt_sanity_applied = dplyr::coalesce(
        as.logical(.data$stat_qb_pass_attempt_sanity_applied),
        FALSE
      ),
      qb_final_review_stat_applied = dplyr::coalesce(
        as.logical(.data$qb_final_review_stat_applied),
        FALSE
      ),
      qb_final_review_projection_applied = dplyr::coalesce(
        as.logical(.data$qb_final_review_projection_applied),
        FALSE
      ),
      rb_final_review_stat_applied = dplyr::coalesce(
        as.logical(.data$rb_final_review_stat_applied),
        FALSE
      ),
      rb_final_review_projection_applied = dplyr::coalesce(
        as.logical(.data$rb_final_review_projection_applied),
        FALSE
      ),
      wr_final_review_stat_applied = dplyr::coalesce(
        as.logical(.data$wr_final_review_stat_applied),
        FALSE
      ),
      wr_final_review_projection_applied = dplyr::coalesce(
        as.logical(.data$wr_final_review_projection_applied),
        FALSE
      ),
      wr_historical_curve_applied = dplyr::coalesce(
        as.logical(.data$wr_historical_curve_applied),
        FALSE
      ),
      te_historical_curve_applied = dplyr::coalesce(
        as.logical(.data$te_historical_curve_applied),
        FALSE
      ),
      te_final_review_stat_applied = dplyr::coalesce(
        as.logical(.data$te_final_review_stat_applied),
        FALSE
      ),
      te_final_review_projection_applied = dplyr::coalesce(
        as.logical(.data$te_final_review_projection_applied),
        FALSE
      ),
      k_historical_curve_applied = dplyr::coalesce(
        as.logical(.data$k_historical_curve_applied),
        FALSE
      )
    )
  out <- board |>
    dplyr::select(-dplyr::any_of(c(
      "final_stat_implied_points", "stat_qb_pass_attempt_sanity_applied",
      "qb_final_review_stat_applied", "qb_final_review_projection_applied",
      "rb_final_review_stat_applied", "rb_final_review_projection_applied",
      "wr_final_review_stat_applied", "wr_final_review_projection_applied",
      "wr_historical_curve_applied", "te_historical_curve_applied",
      "te_final_review_stat_applied", "te_final_review_projection_applied",
      "k_historical_curve_applied",
      "final_review_stat_promotion_applied",
      "pre_final_review_stat_p50_points", "final_review_stat_p50_multiplier"
    ))) |>
    dplyr::left_join(
      stat_update,
      by = c("position", "prediction_season", "player_key"),
      relationship = "one-to-one"
    ) |>
    dplyr::mutate(
      stat_qb_pass_attempt_sanity_applied = dplyr::coalesce(
        .data$stat_qb_pass_attempt_sanity_applied,
        FALSE
      ),
      qb_final_review_stat_applied = dplyr::coalesce(
        .data$qb_final_review_stat_applied,
        FALSE
      ),
      qb_final_review_projection_applied = dplyr::coalesce(
        .data$qb_final_review_projection_applied,
        FALSE
      ),
      rb_final_review_stat_applied = dplyr::coalesce(
        .data$rb_final_review_stat_applied,
        FALSE
      ),
      rb_final_review_projection_applied = dplyr::coalesce(
        .data$rb_final_review_projection_applied,
        FALSE
      ),
      wr_final_review_stat_applied = dplyr::coalesce(
        .data$wr_final_review_stat_applied,
        FALSE
      ),
      wr_final_review_projection_applied = dplyr::coalesce(
        .data$wr_final_review_projection_applied,
        FALSE
      ),
      wr_historical_curve_applied = dplyr::coalesce(
        .data$wr_historical_curve_applied,
        FALSE
      ),
      te_historical_curve_applied = dplyr::coalesce(
        .data$te_historical_curve_applied,
        FALSE
      ),
      te_final_review_stat_applied = dplyr::coalesce(
        .data$te_final_review_stat_applied,
        FALSE
      ),
      te_final_review_projection_applied = dplyr::coalesce(
        .data$te_final_review_projection_applied,
        FALSE
      ),
      k_historical_curve_applied = dplyr::coalesce(
        .data$k_historical_curve_applied,
        FALSE
      ),
      final_review_stat_promotion_applied = dplyr::coalesce(
        as.logical(.data$active_projection_pool),
        TRUE
      ) &
        .data$position %in% c("QB", "RB", "WR", "TE", "K") &
        is.finite(.data$final_stat_implied_points) &
        (
          .data$stat_qb_pass_attempt_sanity_applied |
            .data$qb_final_review_stat_applied |
            .data$qb_final_review_projection_applied |
            .data$rb_final_review_stat_applied |
            .data$rb_final_review_projection_applied |
            .data$wr_final_review_stat_applied |
            .data$wr_final_review_projection_applied |
            .data$wr_historical_curve_applied |
            .data$te_historical_curve_applied |
            .data$te_final_review_stat_applied |
            .data$te_final_review_projection_applied |
            .data$k_historical_curve_applied
        ),
      pre_final_review_stat_p50_points = .data$adjusted_p50_points,
      final_review_stat_p50_multiplier = dplyr::if_else(
        .data$final_review_stat_promotion_applied,
        .data$final_stat_implied_points / pmax(.data$adjusted_p50_points, 1e-6),
        1
      )
    )
  promote <- out$final_review_stat_promotion_applied
  for (col in intersect(
    c(
      "adjusted_p10_points", "adjusted_p25_points", "adjusted_p50_points",
      "adjusted_p75_points", "adjusted_p90_points"
    ),
    names(out)
  )) {
    out[[col]][promote] <- pmax(
      0,
      sos_prob_num(out[[col]][promote]) * out$final_review_stat_p50_multiplier[promote]
    )
  }
  out$adjusted_projected_ppg[promote] <-
    out$adjusted_p50_points[promote] / pmax(out$adjusted_projected_games[promote], 1e-6)
  out <- sos_enforce_projection_ranges(
    out,
    c(
      "adjusted_p10_points", "adjusted_p25_points", "adjusted_p50_points",
      "adjusted_p75_points", "adjusted_p90_points"
    )
  ) |>
    dplyr::mutate(
      adjusted_average_range_score = (
        .data$adjusted_p25_points + .data$adjusted_p50_points + .data$adjusted_p75_points
      ) / 3
    ) |>
    dplyr::group_by(.data$position) |>
    dplyr::mutate(
      manual_adjusted_projection_rank = rank(
        -.data$adjusted_average_range_score,
        ties.method = "first",
        na.last = "keep"
      )
    ) |>
    dplyr::ungroup()

  wide$pre_final_review_stat_target_p50_points <- wide$stat_target_p50_points
  promoted_target <- out |>
    dplyr::select(
      "position", "prediction_season", "player_key",
      final_review_projection_p50_points = "adjusted_p50_points",
      "final_review_stat_promotion_applied",
      "final_review_stat_p50_multiplier"
    )
  wide <- wide |>
    dplyr::select(-dplyr::any_of(c(
      "final_review_projection_p50_points", "final_review_stat_promotion_applied",
      "final_review_stat_p50_multiplier"
    ))) |>
    dplyr::left_join(
      promoted_target,
      by = c("position", "prediction_season", "player_key"),
      relationship = "one-to-one"
    ) |>
    dplyr::mutate(
      stat_target_p50_points = dplyr::if_else(
        .data$final_review_stat_promotion_applied,
        .data$final_review_projection_p50_points,
        .data$stat_target_p50_points
      )
    )

  audit_positions <- intersect(
    c("QB", "RB", "WR", "TE", "K"),
    unique(as.character(out$position))
  )
  audit <- dplyr::bind_rows(lapply(audit_positions, function(pos) {
    position_rows <- out[out$position == pos, , drop = FALSE]
    explicit_context <- switch(
      pos,
      QB = position_rows$qb_final_review_projection_applied,
      RB = position_rows$rb_final_review_projection_applied,
      WR = position_rows$wr_final_review_projection_applied,
      TE = position_rows$te_final_review_projection_applied |
        position_rows$te_final_review_stat_applied,
      K = rep(FALSE, nrow(position_rows))
    )
    historical_curve_applied <- switch(
      pos,
      WR = position_rows$wr_historical_curve_applied,
      TE = position_rows$te_historical_curve_applied,
      K = position_rows$k_historical_curve_applied,
      rep(FALSE, nrow(position_rows))
    )
    historical_curve <- position_rows$final_review_stat_promotion_applied &
      historical_curve_applied & !explicit_context
    generic <- position_rows$final_review_stat_promotion_applied &
      !explicit_context & !historical_curve
    explicit <- position_rows$final_review_stat_promotion_applied & explicit_context
    generic_max <- if (any(generic)) {
      max(abs(position_rows$final_review_stat_p50_multiplier[generic] - 1), na.rm = TRUE)
    } else 0
    explicit_max <- if (any(explicit)) {
      max(abs(position_rows$final_review_stat_p50_multiplier[explicit] - 1), na.rm = TRUE)
    } else 0
    historical_curve_max <- if (any(historical_curve)) {
      max(abs(position_rows$final_review_stat_p50_multiplier[historical_curve] - 1), na.rm = TRUE)
    } else 0
    historical_curve_limit <- dplyr::case_when(
      pos == "TE" ~ 0.35,
      pos == "K" ~ 0.20,
      TRUE ~ 0.25
    )
    data.frame(
      position = pos,
      prediction_season = as.integer(prediction_season[[1]]),
      rows = nrow(position_rows),
      promoted_rows = sum(position_rows$final_review_stat_promotion_applied, na.rm = TRUE),
      avg_abs_p50_pct = mean(abs(position_rows$final_review_stat_p50_multiplier - 1), na.rm = TRUE),
      max_abs_p50_pct = max(abs(position_rows$final_review_stat_p50_multiplier - 1), na.rm = TRUE),
      max_generic_abs_p50_pct = generic_max,
      max_explicit_context_abs_p50_pct = explicit_max,
      historical_curve_rows = sum(historical_curve, na.rm = TRUE),
      max_historical_curve_abs_p50_pct = historical_curve_max,
      historical_curve_abs_p50_pct_limit = historical_curve_limit,
      status = if (
        all(is.finite(position_rows$adjusted_p50_points)) &&
          generic_max <= 0.12 + 1e-8 &&
          explicit_max <= 0.80 + 1e-8 &&
          historical_curve_max <= historical_curve_limit + 1e-8
      ) "PASS" else "FAIL",
      stringsAsFactors = FALSE
    )
  }))
  list(board = out, wide = wide, audit = audit)
}

sos_stat_reconciliation_allowed <- function(
    reconciliation_impact,
    position,
    stat,
    min_relative_gain = -0.01
) {
  if (is.null(reconciliation_impact) || nrow(reconciliation_impact) == 0L) return(TRUE)
  if (!all(c("position", "stat", "sample") %in% names(reconciliation_impact))) return(TRUE)
  impact <- reconciliation_impact |>
    dplyr::filter(
      toupper(as.character(.data$position)) == toupper(.env$position),
      as.character(.data$stat) == as.character(.env$stat)
    )
  if (nrow(impact) == 0L) return(TRUE)
  preferred <- impact |>
    dplyr::filter(.data$sample == "qualified_8_games")
  if (nrow(preferred) == 0L) {
    preferred <- impact |>
      dplyr::filter(.data$sample == "overall")
  }
  if (nrow(preferred) == 0L) return(TRUE)
  row <- preferred[1, , drop = FALSE]
  relative_gain <- if ("relative_rmse_gain" %in% names(row)) {
    sos_prob_num(row$relative_rmse_gain)[[1]]
  } else {
    NA_real_
  }
  status <- if ("reconciliation_status" %in% names(row)) {
    as.character(row$reconciliation_status[[1]])
  } else {
    ""
  }
  if (identical(status, "worse")) return(FALSE)
  if (is.finite(relative_gain) && relative_gain < min_relative_gain) return(FALSE)
  TRUE
}

sos_reconcile_stat_projection_to_fantasy <- function(
    board,
    wide,
    prediction_season = 2026L,
    reconciliation_impact = NULL,
    selective_reconciliation = TRUE,
    min_relative_gain = -0.01,
    multiplier_floor = 0.85,
    multiplier_ceiling = 1.15,
    context_multiplier_floor = 0.75,
    context_multiplier_ceiling = 1.35,
    severe_multiplier_floor = 0.65,
    severe_multiplier_ceiling = 1.55,
    severe_gap_points = 40,
    severe_gap_ratio = 0.30
) {
  if (is.null(wide) || nrow(wide) == 0L) {
    return(list(wide = wide, audit = data.frame()))
  }
  target <- board |>
    dplyr::select(
      "position", "prediction_season", "player_key",
      stat_target_p50_points = "adjusted_p50_points",
      stat_target_projected_games = "adjusted_projected_games",
      dplyr::any_of(c(
        "context_adjustment_count", "manual_central_pct", "manual_games_delta",
        "market_context_pct", "projection_context_applied",
        "manual_rank_context_applied", "manual_rank_projection_pct",
        "active_projection_pool", "article_eligible", "eligibility_reason",
        "article_rank", "article_rank_reference",
        "manual_context_note", "adjustment_channel",
        "qb_final_review_projection_applied", "qb_final_review_note",
        "rb_final_review_projection_applied", "rb_final_review_note",
        "wr_final_review_projection_applied", "wr_final_review_note",
        "te_final_review_projection_applied", "te_final_review_note"
      ))
    )
  out <- wide |>
    dplyr::left_join(
      target,
      by = c("position", "prediction_season", "player_key"),
      relationship = "one-to-one"
    )
  out <- sos_seed_missing_stat_projection_from_p50(out)
  out <- sos_distribute_total_td_components(out)
  out$stat_implied_fantasy_points_before <- sos_stat_implied_fantasy_points(out)
  out$stat_profile_protected_cols <- 0L
  out$stat_reconciliation_allowed_cols <- 0L
  out$stat_reconciliation_blocked_cols <- 0L
  stat_optional_numeric_default <- function(col, default = 0) {
    if (!col %in% names(out)) return(rep(default, nrow(out)))
    value <- sos_prob_num(out[[col]])
    dplyr::coalesce(value, default)
  }
  stat_optional_flag_default <- function(col, default = FALSE) {
    if (!col %in% names(out)) return(rep(default, nrow(out)))
    out[[col]] %in% c(TRUE, "TRUE", "true", 1L)
  }
  out$context_adjustment_count <- stat_optional_numeric_default("context_adjustment_count", 0)
  out$manual_central_pct <- stat_optional_numeric_default("manual_central_pct", 0)
  out$manual_games_delta <- stat_optional_numeric_default("manual_games_delta", 0)
  out$market_context_pct <- stat_optional_numeric_default("market_context_pct", 0)
  out$projection_context_applied <- stat_optional_flag_default("projection_context_applied", FALSE)
  out$manual_rank_projection_pct <- stat_optional_numeric_default("manual_rank_projection_pct", 0)
  out$manual_rank_context_applied <- stat_optional_flag_default("manual_rank_context_applied", FALSE)
  qb_interception_penalty <- dplyr::if_else(
    toupper(as.character(out$position)) == "QB",
    sos_stat_wide_num(out, "projected_interceptions") * 2,
    0
  )
  stat_positive_points_before <- out$stat_implied_fantasy_points_before + qb_interception_penalty
  out$stat_reconciliation_multiplier <- dplyr::if_else(
    is.finite(out$stat_target_p50_points) &
      out$stat_target_p50_points > 0 &
      is.finite(stat_positive_points_before) &
      stat_positive_points_before > 0,
    (out$stat_target_p50_points + qb_interception_penalty) / stat_positive_points_before,
    1
  )
  out$stat_reconciliation_raw_multiplier <- out$stat_reconciliation_multiplier
  out$stat_reconciliation_abs_delta_before <- abs(
    out$stat_implied_fantasy_points_before - out$stat_target_p50_points
  )
  out$stat_reconciliation_gap_ratio_before <- dplyr::if_else(
    is.finite(out$stat_target_p50_points) & out$stat_target_p50_points > 0,
    out$stat_reconciliation_abs_delta_before / out$stat_target_p50_points,
    NA_real_
  )
  out$stat_reconciliation_context_sensitive <- out$context_adjustment_count > 0 |
    abs(out$manual_central_pct) > 0.05 |
    abs(out$manual_games_delta) > 0.50 |
    abs(out$market_context_pct) > 0.05 |
    out$projection_context_applied |
    out$manual_rank_context_applied |
    abs(out$manual_rank_projection_pct) > 0.02
  out$stat_reconciliation_severe_gap <- is.finite(out$stat_reconciliation_abs_delta_before) &
    is.finite(out$stat_reconciliation_gap_ratio_before) &
    out$stat_reconciliation_abs_delta_before >= severe_gap_points &
    out$stat_reconciliation_gap_ratio_before >= severe_gap_ratio
  out$stat_reconciliation_multiplier_floor <- dplyr::case_when(
    out$stat_reconciliation_severe_gap ~ severe_multiplier_floor,
    out$stat_reconciliation_context_sensitive ~ context_multiplier_floor,
    TRUE ~ multiplier_floor
  )
  out$stat_reconciliation_multiplier_ceiling <- dplyr::case_when(
    out$stat_reconciliation_severe_gap ~ severe_multiplier_ceiling,
    out$stat_reconciliation_context_sensitive ~ context_multiplier_ceiling,
    TRUE ~ multiplier_ceiling
  )
  out$stat_reconciliation_multiplier <- pmin(
    out$stat_reconciliation_multiplier_ceiling,
    pmax(out$stat_reconciliation_multiplier_floor, out$stat_reconciliation_multiplier)
  )
  out$stat_reconciliation_multiplier[!is.finite(out$stat_reconciliation_multiplier)] <- 1

  for (position in unique(as.character(out$position))) {
    rows <- which(out$position == position)
    cols <- intersect(sos_stat_reconciliation_columns(position), names(out))
    if (length(rows) == 0L || length(cols) == 0L) next
    for (col in cols) {
      stat <- sub("^projected_", "", col)
      allowed <- !isTRUE(selective_reconciliation) ||
        sos_stat_reconciliation_allowed(
          reconciliation_impact,
          position,
          stat,
          min_relative_gain = min_relative_gain
        )
      if (!isTRUE(allowed)) {
        out$stat_reconciliation_blocked_cols[rows] <- out$stat_reconciliation_blocked_cols[rows] + 1L
        next
      }
      out$stat_reconciliation_allowed_cols[rows] <- out$stat_reconciliation_allowed_cols[rows] + 1L
      before_values <- sos_prob_num(out[[col]][rows])
      effective_multiplier <- out$stat_reconciliation_multiplier[rows]
      low_usage_floor <- sos_stat_reconciliation_low_usage_floor(position, col)
      profile_protected <- is.finite(before_values) &
        before_values > 0 &
        before_values <= low_usage_floor &
        effective_multiplier > 1
      if (any(profile_protected, na.rm = TRUE)) {
        effective_multiplier[profile_protected] <- 1
        out$stat_profile_protected_cols[rows[profile_protected]] <-
          out$stat_profile_protected_cols[rows[profile_protected]] + 1L
      }
      out[[col]][rows] <- pmax(
        0,
        before_values * effective_multiplier
      )
    }
  }
  zero_target <- is.finite(out$stat_target_p50_points) & out$stat_target_p50_points <= 0
  if (any(zero_target, na.rm = TRUE)) {
    for (position in unique(as.character(out$position[zero_target]))) {
      rows <- which(zero_target & out$position == position)
      cols <- intersect(sos_stat_reconciliation_columns(position), names(out))
      if (length(rows) == 0L || length(cols) == 0L) next
      for (col in cols) out[[col]][rows] <- 0
    }
  }
  if (all(c("projected_rush_yards", "projected_receiving_yards", "projected_scrimmage_yards") %in% names(out))) {
    skill <- out$position %in% c("RB", "WR", "TE")
    out$projected_scrimmage_yards[skill] <-
      sos_stat_wide_num(out, "projected_rush_yards")[skill] +
      sos_stat_wide_num(out, "projected_receiving_yards")[skill]
  }
  if (all(c("projected_rush_td", "projected_receiving_td", "projected_total_td") %in% names(out))) {
    skill <- out$position %in% c("RB", "WR", "TE")
    out$projected_total_td[skill] <-
      sos_stat_wide_num(out, "projected_rush_td")[skill] +
      sos_stat_wide_num(out, "projected_receiving_td")[skill]
  }
  if ("projected_dst_fantasy_points" %in% names(out)) {
    dst <- out$position == "DST"
    out$projected_dst_fantasy_points[dst] <- out$stat_target_p50_points[dst]
  }
  out <- sos_apply_stat_residual_bridge(out)
  out <- sos_apply_qb_pass_attempt_sanity(out)
  out <- sos_apply_qb_final_review_stat_context(out, prediction_season = prediction_season)
  out <- sos_apply_rb_final_review_stat_context(out, prediction_season = prediction_season)
  out <- sos_apply_wr_final_review_stat_context(out, prediction_season = prediction_season)
  out <- sos_apply_wr_historical_stat_curve(out, prediction_season = prediction_season)
  out <- sos_apply_te_historical_stat_curve(out, prediction_season = prediction_season)
  out <- sos_apply_te_final_review_stat_context(out, prediction_season = prediction_season)
  out <- sos_apply_k_historical_stat_curve(out, prediction_season = prediction_season)
  out <- sos_apply_dst_historical_component_rebalance(out, prediction_season = prediction_season)
  out <- sos_apply_dst_final_review_stat_context(out, prediction_season = prediction_season)
  
  out$stat_implied_fantasy_points_after <- sos_stat_implied_fantasy_points(out)
  out$stat_reconciliation_abs_delta_after <- abs(
    out$stat_implied_fantasy_points_after - out$stat_target_p50_points
  )
  out$stat_reconciliation_applied <- is.finite(out$stat_reconciliation_multiplier) &
    abs(out$stat_reconciliation_multiplier - 1) > 1e-8 &
    out$stat_reconciliation_allowed_cols > 0

  audit <- out |>
    dplyr::group_by(.data$position) |>
    dplyr::summarise(
      prediction_season = as.integer(.env$prediction_season),
      rows = dplyr::n(),
      seeded_missing_base_rows = sum(.data$stat_missing_base_seeded, na.rm = TRUE),
      reconciled_rows = sum(.data$stat_reconciliation_applied, na.rm = TRUE),
      selective_reconciliation = isTRUE(.env$selective_reconciliation),
      allowed_stat_cells = sum(.data$stat_reconciliation_allowed_cols, na.rm = TRUE),
      blocked_stat_cells = sum(.data$stat_reconciliation_blocked_cols, na.rm = TRUE),
      profile_protected_cells = sum(.data$stat_profile_protected_cols, na.rm = TRUE),
      context_sensitive_rows = sum(.data$stat_reconciliation_context_sensitive, na.rm = TRUE),
      severe_gap_rows = sum(.data$stat_reconciliation_severe_gap, na.rm = TRUE),
      residual_bridge_rows = sum(.data$stat_residual_bridge_applied, na.rm = TRUE),
      residual_bridge_cols = sum(.data$stat_residual_bridge_cols, na.rm = TRUE),
      qb_pass_attempt_sanity_rows = sum(.data$stat_qb_pass_attempt_sanity_applied, na.rm = TRUE),
      qb_final_review_stat_rows = sum(.data$qb_final_review_stat_applied, na.rm = TRUE),
      rb_final_review_stat_rows = sum(.data$rb_final_review_stat_applied, na.rm = TRUE),
      wr_final_review_stat_rows = sum(.data$wr_final_review_stat_applied, na.rm = TRUE),
      wr_historical_curve_rows = sum(.data$wr_historical_curve_applied, na.rm = TRUE),
      te_historical_curve_rows = sum(.data$te_historical_curve_applied, na.rm = TRUE),
      te_final_review_stat_rows = sum(.data$te_final_review_stat_applied, na.rm = TRUE),
      k_historical_curve_rows = sum(.data$k_historical_curve_applied, na.rm = TRUE),
      dst_historical_rebalance_rows = sum(.data$dst_historical_rebalance_applied, na.rm = TRUE),
      dst_final_review_stat_rows = sum(.data$dst_final_review_stat_applied, na.rm = TRUE),
      qb_projected_500_attempt_rows = sum(
        .data$position == "QB" & .data$projected_pass_attempts > 500,
        na.rm = TRUE
      ),
      qb_projected_4000_yard_rows = sum(
        .data$position == "QB" & .data$projected_pass_yards > 4000,
        na.rm = TRUE
      ),
      max_qb_pass_attempts_delta = max(.data$stat_qb_pass_attempts_delta, na.rm = TRUE),
      max_residual_bridge_multiplier = max(.data$stat_residual_bridge_multiplier, na.rm = TRUE),
      min_residual_bridge_multiplier = min(.data$stat_residual_bridge_multiplier, na.rm = TRUE),
      max_abs_delta_before = max(.data$stat_reconciliation_abs_delta_before, na.rm = TRUE),
      max_abs_delta_after = max(.data$stat_reconciliation_abs_delta_after, na.rm = TRUE),
      max_raw_multiplier = max(.data$stat_reconciliation_raw_multiplier, na.rm = TRUE),
      min_raw_multiplier = min(.data$stat_reconciliation_raw_multiplier, na.rm = TRUE),
      max_multiplier = max(.data$stat_reconciliation_multiplier, na.rm = TRUE),
      min_multiplier = min(.data$stat_reconciliation_multiplier, na.rm = TRUE),
      max_multiplier_ceiling_used = max(.data$stat_reconciliation_multiplier_ceiling, na.rm = TRUE),
      min_multiplier_floor_used = min(.data$stat_reconciliation_multiplier_floor, na.rm = TRUE),
      nonfinite_after_rows = sum(!is.finite(.data$stat_implied_fantasy_points_after), na.rm = TRUE),
      status = dplyr::if_else(
        .data$nonfinite_after_rows == 0 &
          .data$max_multiplier <= .data$max_multiplier_ceiling_used + 1e-8 &
          .data$min_multiplier >= .data$min_multiplier_floor_used - 1e-8,
        "PASS",
        "FAIL"
      ),
      .groups = "drop"
    ) |>
    dplyr::arrange(factor(.data$position, levels = c("QB", "RB", "WR", "TE", "K", "DST")))

  list(wide = out, audit = audit)
}

sos_apply_stat_alignment_status <- function(wide, prediction_season = 2026L) {
  if (is.null(wide) || nrow(wide) == 0L) {
    return(list(wide = wide, detail = data.frame(), summary = data.frame()))
  }
  out <- wide
  if (!"stat_target_p50_points" %in% names(out)) {
    out$stat_target_p50_points <- NA_real_
  }
  if (!"stat_implied_fantasy_points_after" %in% names(out)) {
    out$stat_implied_fantasy_points_after <- sos_stat_implied_fantasy_points(out)
  }
  if (!"active_projection_pool" %in% names(out)) {
    out$active_projection_pool <- TRUE
  }
  if (!"article_eligible" %in% names(out)) {
    out$article_eligible <- FALSE
  }
  if (!"eligibility_reason" %in% names(out)) {
    out$eligibility_reason <- NA_character_
  }
  if (!"article_rank" %in% names(out)) {
    out$article_rank <- NA_integer_
  }
  out$active_projection_pool <- out$active_projection_pool %in% c(TRUE, "TRUE", "true", 1L, "1")
  out$article_eligible <- out$article_eligible %in% c(TRUE, "TRUE", "true", 1L, "1")

  position <- toupper(as.character(out$position))
  target <- sos_prob_num(out$stat_target_p50_points)
  implied <- sos_prob_num(out$stat_implied_fantasy_points_after)
  gap <- abs(implied - target)
  ratio <- dplyr::if_else(is.finite(target) & target > 0, gap / target, NA_real_)

  aligned_abs <- dplyr::case_when(
    position == "QB" ~ 10,
    position %in% c("RB", "WR") ~ 8,
    position == "TE" ~ 6,
    position %in% c("K", "DST") ~ 5,
    TRUE ~ 8
  )
  watch_abs <- dplyr::case_when(
    position == "QB" ~ 20,
    position %in% c("RB", "WR") ~ 15,
    position == "TE" ~ 12,
    position %in% c("K", "DST") ~ 10,
    TRUE ~ 15
  )
  major_abs <- dplyr::case_when(
    position == "QB" ~ 45,
    position %in% c("RB", "WR") ~ 35,
    position == "TE" ~ 25,
    position %in% c("K", "DST") ~ 20,
    TRUE ~ 35
  )
  aligned_cutoff <- pmax(aligned_abs, 0.08 * target, na.rm = TRUE)
  watch_cutoff <- pmax(watch_abs, 0.16 * target, na.rm = TRUE)
  major_cutoff <- pmax(major_abs, 0.25 * target, na.rm = TRUE)

  out$stat_alignment_points_gap <- gap
  out$stat_alignment_gap_ratio <- ratio
  out$stat_alignment_aligned_cutoff <- aligned_cutoff
  out$stat_alignment_watch_cutoff <- watch_cutoff
  out$stat_alignment_major_cutoff <- major_cutoff
  out$stat_alignment_status <- dplyr::case_when(
    !out$active_projection_pool ~ "inactive_or_removed",
    !is.finite(target) ~ "missing_target",
    !is.finite(implied) ~ "missing_stat_implied_points",
    gap >= major_cutoff ~ "major_gap",
    gap > aligned_cutoff ~ "watch",
    TRUE ~ "aligned"
  )
  out$stat_alignment_reason <- dplyr::case_when(
    out$stat_alignment_status == "inactive_or_removed" ~ "outside_active_projection_pool",
    out$stat_alignment_status == "missing_target" ~ "missing_adjusted_p50_points",
    out$stat_alignment_status == "missing_stat_implied_points" ~ "missing_stat_implied_fantasy_points",
    out$stat_alignment_status == "major_gap" ~ "stat_implied_points_far_from_projection",
    out$stat_alignment_status == "watch" ~ "stat_implied_points_need_review",
    TRUE ~ "stat_implied_points_in_line"
  )
  out$stat_alignment_article_watch <- out$article_eligible &
    out$stat_alignment_status %in% c("watch", "major_gap", "missing_target", "missing_stat_implied_points")

  detail_cols <- c(
    "position", "prediction_season", "article_rank", "article_eligible",
    "active_projection_pool", "eligibility_reason", "player_key", "player",
    "current_team", "next_team", "stat_target_p50_points",
    "stat_implied_fantasy_points_before", "stat_implied_fantasy_points_after",
    "stat_alignment_points_gap", "stat_alignment_gap_ratio",
    "stat_alignment_status", "stat_alignment_reason",
    "stat_alignment_article_watch", "stat_reconciliation_abs_delta_before",
    "stat_reconciliation_abs_delta_after", "stat_reconciliation_multiplier",
    "stat_reconciliation_context_sensitive", "stat_reconciliation_severe_gap",
    "stat_reconciliation_allowed_cols", "stat_reconciliation_blocked_cols",
    "stat_profile_protected_cols", "stat_missing_base_seeded",
    "stat_residual_bridge_applied", "stat_residual_bridge_direction",
    "stat_residual_bridge_multiplier", "stat_residual_bridge_cols",
    "stat_residual_bridge_gap_before"
  )
  detail <- out |>
    dplyr::select(dplyr::any_of(detail_cols)) |>
    dplyr::mutate(
      stat_alignment_status_order = dplyr::case_when(
        .data$stat_alignment_status == "major_gap" ~ 1L,
        .data$stat_alignment_status == "watch" ~ 2L,
        .data$stat_alignment_status %in% c("missing_target", "missing_stat_implied_points") ~ 3L,
        .data$stat_alignment_status == "inactive_or_removed" ~ 4L,
        TRUE ~ 5L
      )
    ) |>
    dplyr::arrange(
      factor(.data$position, levels = c("QB", "RB", "WR", "TE", "K", "DST")),
      .data$stat_alignment_status_order,
      dplyr::desc(.data$article_eligible),
      dplyr::desc(.data$stat_alignment_points_gap)
    ) |>
    dplyr::select(-dplyr::all_of("stat_alignment_status_order"))

  summary <- out |>
    dplyr::group_by(.data$position, .data$stat_alignment_status) |>
    dplyr::summarise(
      prediction_season = as.integer(.env$prediction_season),
      rows = dplyr::n(),
      article_rows = sum(.data$article_eligible, na.rm = TRUE),
      article_watch_rows = sum(.data$stat_alignment_article_watch, na.rm = TRUE),
      avg_points_gap = if (any(is.finite(.data$stat_alignment_points_gap))) mean(.data$stat_alignment_points_gap, na.rm = TRUE) else NA_real_,
      max_points_gap = if (any(is.finite(.data$stat_alignment_points_gap))) max(.data$stat_alignment_points_gap, na.rm = TRUE) else NA_real_,
      avg_gap_ratio = if (any(is.finite(.data$stat_alignment_gap_ratio))) mean(.data$stat_alignment_gap_ratio, na.rm = TRUE) else NA_real_,
      max_gap_ratio = if (any(is.finite(.data$stat_alignment_gap_ratio))) max(.data$stat_alignment_gap_ratio, na.rm = TRUE) else NA_real_,
      .groups = "drop"
    ) |>
    dplyr::arrange(
      factor(.data$position, levels = c("QB", "RB", "WR", "TE", "K", "DST")),
      factor(.data$stat_alignment_status, levels = c("major_gap", "watch", "missing_target", "missing_stat_implied_points", "inactive_or_removed", "aligned"))
    )

  list(wide = out, detail = detail, summary = summary)
}

sos_selected_projection_backtest_targets <- function(backtest) {
  if (is.null(backtest) || is.null(backtest$predictions) || is.null(backtest$selection)) {
    return(data.frame())
  }
  selected <- backtest$predictions |>
    dplyr::inner_join(
      dplyr::select(backtest$selection, "position", "target", "candidate"),
      by = c("position", "target", "candidate"),
      relationship = "many-to-one"
    )
  if (!"player_key" %in% names(selected)) {
    selected$player_key <- make_player_key(selected$player)
  } else {
    selected$player_key <- make_player_key(selected$player_key)
  }

  ppg <- selected |>
    dplyr::filter(.data$target == "ppg") |>
    dplyr::select(
      "position", prediction_season = "test_season", "player_key",
      projected_ppg = "prediction"
    )
  total <- selected |>
    dplyr::filter(.data$target == "total") |>
    dplyr::select(
      "position", prediction_season = "test_season", "player_key",
      adjusted_p50_points = "prediction"
    )

  dplyr::full_join(
    ppg,
    total,
    by = c("position", "prediction_season", "player_key")
  ) |>
    dplyr::mutate(
      prediction_season = as.integer(.data$prediction_season),
      adjusted_projected_ppg = sos_prob_num(.data$projected_ppg),
      adjusted_p50_points = sos_prob_num(.data$adjusted_p50_points),
      adjusted_projected_games = dplyr::if_else(
        .data$adjusted_projected_ppg > 0,
        .data$adjusted_p50_points / .data$adjusted_projected_ppg,
        NA_real_
      ),
      adjusted_projected_games = pmin(
        17,
        pmax(1, dplyr::coalesce(.data$adjusted_projected_games, 12))
      )
    ) |>
    dplyr::select(
      "position", "prediction_season", "player_key",
      "adjusted_projected_games", "adjusted_projected_ppg", "adjusted_p50_points"
    )
}

sos_make_stat_prediction_wide <- function(selected_predictions) {
  if (is.null(selected_predictions) || nrow(selected_predictions) == 0L) return(data.frame())
  identity <- selected_predictions |>
    dplyr::mutate(prediction_season = as.integer(.data$test_season)) |>
    dplyr::distinct(
      .data$position, .data$prediction_season, .data$player_key, .data$player
    ) |>
    dplyr::mutate(current_team = NA_character_, next_team = NA_character_)

  wide <- identity
  for (stat in sort(unique(as.character(selected_predictions$stat)))) {
    rows <- selected_predictions[selected_predictions$stat == stat, , drop = FALSE] |>
      dplyr::mutate(prediction_season = as.integer(.data$test_season))
    key <- paste(wide$position, wide$prediction_season, wide$player_key)
    row_key <- paste(rows$position, rows$prediction_season, rows$player_key)
    wide[[paste0("projected_", stat)]] <- rows$prediction[match(key, row_key)]
    wide[[paste0("actual_", stat)]] <- rows$actual[match(key, row_key)]
  }
  wide
}

sos_stat_backtest_metrics <- function(predictions, sample_name = "overall") {
  if (is.null(predictions) || nrow(predictions) == 0L) return(data.frame())
  predictions |>
    dplyr::filter(
      is.finite(.data$prediction),
      is.finite(.data$actual)
    ) |>
    dplyr::group_by(.data$position, .data$stat, .data$projection_version) |>
    dplyr::summarise(
      sample = .env$sample_name,
      test_seasons = paste(sort(unique(.data$test_season)), collapse = ","),
      n = dplyr::n(),
      mean_actual = mean(.data$actual, na.rm = TRUE),
      mae = mean(abs(.data$prediction - .data$actual), na.rm = TRUE),
      rmse = sqrt(mean((.data$prediction - .data$actual)^2, na.rm = TRUE)),
      mae_vs_mean_actual = dplyr::if_else(
        abs(.data$mean_actual) > 1e-8,
        .data$mae / abs(.data$mean_actual),
        NA_real_
      ),
      rmse_vs_mean_actual = dplyr::if_else(
        abs(.data$mean_actual) > 1e-8,
        .data$rmse / abs(.data$mean_actual),
        NA_real_
      ),
      p95_abs_error = stats::quantile(abs(.data$prediction - .data$actual), 0.95, na.rm = TRUE, names = FALSE),
      spearman = suppressWarnings(stats::cor(.data$prediction, .data$actual, method = "spearman")),
      .groups = "drop"
    )
}

build_core_sos_reconciled_stat_backtest <- function(
    positions = c("QB", "RB", "WR", "TE", "K", "DST"),
    backtest = NULL,
    raw_predictions = NULL,
    raw_selection = NULL,
    write_output = TRUE,
    output_dir = sos_production_output_dir()
) {
  load_model_core_packages()
  positions <- toupper(as.character(positions))
  if (is.null(backtest)) {
    backtest <- build_core_sos_projection_backtest(positions)
  }

  if (is.null(raw_predictions)) {
    prediction_rows <- list()
    idx <- 1L
    for (position in positions) {
      stats <- sos_stat_specs(position)
      if (length(stats) == 0L) next
      history <- sos_stat_projection_history(position)
      if (nrow(history) == 0L) next
      available_stats <- stats[paste0("current_", stats) %in% names(history) & paste0("target_", stats) %in% names(history)]
      seasons <- sort(unique(history$season[is.finite(history$season)]))
      for (test_season in seasons[seasons > min(seasons)]) {
        train <- history[history$season < test_season, , drop = FALSE]
        test <- history[history$season == test_season, , drop = FALSE]
        if (nrow(train) == 0L || nrow(test) == 0L) next
        for (stat in available_stats) {
          candidates <- sos_stat_projection_candidates(train, test, stat)
          target_values <- sos_prob_num(test[[paste0("target_", stat)]])
          for (candidate in names(candidates)) {
            prediction_rows[[idx]] <- data.frame(
              position = position,
              stat = stat,
              test_season = test_season,
              train_seasons = paste(sort(unique(train$season)), collapse = ","),
              candidate = candidate,
              player_key = make_player_key(test$player),
              player = test$player,
              target_games = sos_prob_num(test$target_games),
              prediction = sos_prob_num(candidates[[candidate]]),
              actual = target_values,
              stringsAsFactors = FALSE
            )
            idx <- idx + 1L
          }
        }
      }
    }
    raw_predictions <- dplyr::bind_rows(prediction_rows)
  }

  if (!"player_key" %in% names(raw_predictions)) raw_predictions$player_key <- make_player_key(raw_predictions$player)
  if (!"target_games" %in% names(raw_predictions)) raw_predictions$target_games <- NA_real_
  raw_predictions <- raw_predictions |>
    dplyr::mutate(
      player_key = make_player_key(.data$player_key),
      target_games = sos_prob_num(.data$target_games)
    ) |>
    dplyr::filter(is.finite(.data$prediction), is.finite(.data$actual))
  if (nrow(raw_predictions) == 0L) {
    empty <- data.frame()
    return(list(
      predictions = empty,
      metrics = empty,
      impact = empty,
      selected_predictions = empty,
      reconciled_wide = empty
    ))
  }

  if (is.null(raw_selection)) {
    raw_metrics <- dplyr::bind_rows(lapply(split(raw_predictions, interaction(raw_predictions$position, raw_predictions$stat, raw_predictions$candidate, drop = TRUE)), function(x) {
      data.frame(
        position = x$position[1],
        stat = x$stat[1],
        candidate = x$candidate[1],
        test_seasons = paste(sort(unique(x$test_season)), collapse = ","),
        n = nrow(x),
        mae = mean(abs(x$prediction - x$actual)),
        rmse = sqrt(mean((x$prediction - x$actual)^2)),
        spearman = suppressWarnings(stats::cor(x$prediction, x$actual, method = "spearman")),
        stringsAsFactors = FALSE
      )
    }))
    raw_selection <- raw_metrics |>
      dplyr::group_by(.data$position, .data$stat) |>
      dplyr::slice_min(.data$mae, n = 1L, with_ties = FALSE) |>
      dplyr::ungroup() |>
      dplyr::mutate(selected = TRUE)
  }

  selected_raw <- raw_predictions |>
    dplyr::inner_join(
      dplyr::select(raw_selection, "position", "stat", "candidate"),
      by = c("position", "stat", "candidate"),
      relationship = "many-to-one"
    )
  raw_wide <- sos_make_stat_prediction_wide(selected_raw)
  target_board <- sos_selected_projection_backtest_targets(backtest)
  target_board <- target_board |>
    dplyr::filter(
      .data$position %in% .env$positions,
      .data$prediction_season %in% unique(raw_wide$prediction_season)
    )
  reconciled <- sos_reconcile_stat_projection_to_fantasy(
    target_board,
    raw_wide,
    prediction_season = max(raw_wide$prediction_season, na.rm = TRUE),
    selective_reconciliation = FALSE,
    multiplier_floor = 0.50,
    multiplier_ceiling = 1.75
  )
  reconciled_wide <- reconciled$wide

  key_reconciled <- paste(
    reconciled_wide$position,
    reconciled_wide$prediction_season,
    reconciled_wide$player_key
  )
  selected_reconciled <- selected_raw
  selected_reconciled$prediction_version <- "raw"
  selected_reconciled$prediction_season <- as.integer(selected_reconciled$test_season)
  selected_reconciled$raw_prediction <- selected_reconciled$prediction
  selected_reconciled$reconciled_prediction <- NA_real_
  for (stat in sort(unique(as.character(selected_reconciled$stat)))) {
    projected_col <- paste0("projected_", stat)
    if (!projected_col %in% names(reconciled_wide)) next
    rows <- selected_reconciled$stat == stat
    row_key <- paste(
      selected_reconciled$position[rows],
      selected_reconciled$prediction_season[rows],
      selected_reconciled$player_key[rows]
    )
    selected_reconciled$reconciled_prediction[rows] <- reconciled_wide[[projected_col]][
      match(row_key, key_reconciled)
    ]
  }

  raw_eval <- selected_reconciled |>
    dplyr::transmute(
      position = .data$position,
      stat = .data$stat,
      test_season = .data$test_season,
      train_seasons = .data$train_seasons,
      candidate = .data$candidate,
      player_key = .data$player_key,
      player = .data$player,
      target_games = .data$target_games,
      projection_version = "raw",
      prediction = .data$raw_prediction,
      actual = .data$actual
    )
  reconciled_eval <- selected_reconciled |>
    dplyr::transmute(
      position = .data$position,
      stat = .data$stat,
      test_season = .data$test_season,
      train_seasons = .data$train_seasons,
      candidate = .data$candidate,
      player_key = .data$player_key,
      player = .data$player,
      target_games = .data$target_games,
      projection_version = "reconciled",
      prediction = .data$reconciled_prediction,
      actual = .data$actual
    )
  evaluation_rows <- dplyr::bind_rows(raw_eval, reconciled_eval) |>
    dplyr::filter(is.finite(.data$prediction), is.finite(.data$actual))

  metrics_overall <- sos_stat_backtest_metrics(evaluation_rows, "overall")
  metrics_qualified <- sos_stat_backtest_metrics(
    dplyr::filter(evaluation_rows, is.finite(.data$target_games), .data$target_games >= 8),
    "qualified_8_games"
  )
  metrics <- dplyr::bind_rows(metrics_overall, metrics_qualified) |>
    dplyr::left_join(
      dplyr::select(raw_selection, "position", "stat", selected_candidate = "candidate"),
      by = c("position", "stat"),
      relationship = "many-to-one"
    ) |>
    dplyr::arrange(
      factor(.data$position, levels = c("QB", "RB", "WR", "TE", "K", "DST")),
      .data$stat,
      .data$sample,
      .data$projection_version
    )

  raw_metric <- metrics |>
    dplyr::filter(.data$projection_version == "raw") |>
    dplyr::select(
      "position", "stat", "sample", "selected_candidate",
      raw_n = "n", raw_mae = "mae", raw_rmse = "rmse",
      raw_rmse_vs_mean_actual = "rmse_vs_mean_actual",
      raw_spearman = "spearman"
    )
  rec_metric <- metrics |>
    dplyr::filter(.data$projection_version == "reconciled") |>
    dplyr::select(
      "position", "stat", "sample",
      reconciled_n = "n", reconciled_mae = "mae", reconciled_rmse = "rmse",
      reconciled_rmse_vs_mean_actual = "rmse_vs_mean_actual",
      reconciled_spearman = "spearman"
    )
  impact <- dplyr::left_join(
    raw_metric,
    rec_metric,
    by = c("position", "stat", "sample"),
    relationship = "one-to-one"
  ) |>
    dplyr::mutate(
      rmse_gain = .data$raw_rmse - .data$reconciled_rmse,
      relative_rmse_gain = dplyr::if_else(
        .data$raw_rmse > 0,
        .data$rmse_gain / .data$raw_rmse,
        NA_real_
      ),
      mae_gain = .data$raw_mae - .data$reconciled_mae,
      spearman_gain = .data$reconciled_spearman - .data$raw_spearman,
      reconciliation_status = dplyr::case_when(
        .data$relative_rmse_gain >= 0.01 ~ "improved",
        .data$relative_rmse_gain <= -0.01 ~ "worse",
        TRUE ~ "neutral"
      )
    ) |>
    dplyr::arrange(
      factor(.data$position, levels = c("QB", "RB", "WR", "TE", "K", "DST")),
      .data$sample,
      .data$relative_rmse_gain
    )

  if (isTRUE(write_output)) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    sos_try_write_csv(
      evaluation_rows,
      file.path(output_dir, "core_sos_stat_projection_reconciled_backtest_predictions_2023_2025.csv")
    )
    sos_try_write_csv(
      metrics,
      file.path(output_dir, "core_sos_stat_projection_reconciled_backtest_metrics_2023_2025.csv")
    )
    sos_try_write_csv(
      impact,
      file.path(output_dir, "core_sos_stat_projection_reconciliation_impact_2023_2025.csv")
    )
  }

  list(
    predictions = evaluation_rows,
    metrics = metrics,
    impact = impact,
    selected_predictions = selected_reconciled,
    reconciled_wide = reconciled_wide,
    reconciliation_audit = reconciled$audit
  )
}

build_core_sos_stat_projection_layer <- function(
    board,
    prediction_season = 2026L,
    backtest = NULL,
    write_output = TRUE,
    output_dir = sos_production_output_dir()
) {
  load_model_core_packages()
  prediction_season <- as.integer(prediction_season[[1]])
  prediction_rows <- list()
  future_rows <- list()
  idx <- 1L
  future_idx <- 1L

  for (position in unique(as.character(board$position))) {
    stats <- sos_stat_specs(position)
    if (length(stats) == 0L) next
    history <- sos_stat_projection_history(position)
    if (nrow(history) == 0L) next
    available_stats <- stats[paste0("current_", stats) %in% names(history) & paste0("target_", stats) %in% names(history)]
    if (length(available_stats) == 0L) next

    seasons <- sort(unique(history$season[is.finite(history$season)]))
    for (test_season in seasons[seasons > min(seasons)]) {
      train <- history[history$season < test_season, , drop = FALSE]
      test <- history[history$season == test_season, , drop = FALSE]
      if (nrow(train) == 0L || nrow(test) == 0L) next
      for (stat in available_stats) {
        candidates <- sos_stat_projection_candidates(train, test, stat)
        target_values <- sos_prob_num(test[[paste0("target_", stat)]])
        for (candidate in names(candidates)) {
          prediction_rows[[idx]] <- data.frame(
            position = position,
            stat = stat,
            test_season = test_season,
            train_seasons = paste(sort(unique(train$season)), collapse = ","),
            candidate = candidate,
            player_key = make_player_key(test$player),
            player = test$player,
            target_games = sos_prob_num(test$target_games),
            prediction = sos_prob_num(candidates[[candidate]]),
            actual = target_values,
            stringsAsFactors = FALSE
          )
          idx <- idx + 1L
        }
      }
    }

    future <- board[board$position == position, , drop = FALSE]
    source_stats <- sos_stat_season_table(position) |>
      dplyr::filter(.data$season == .env$prediction_season - 1L) |>
      dplyr::select("player_key", source_games = "games", dplyr::all_of(available_stats))
    names(source_stats)[names(source_stats) %in% available_stats] <- paste0("current_", available_stats)
    future <- future |>
      dplyr::left_join(source_stats, by = "player_key", relationship = "many-to-one")

    position_stat_predictions <- dplyr::bind_rows(prediction_rows)
    for (stat in available_stats) {
      if (nrow(position_stat_predictions) == 0L) next
      stat_metrics <- position_stat_predictions |>
        dplyr::filter(.data$position == .env$position, .data$stat == .env$stat, is.finite(.data$prediction), is.finite(.data$actual)) |>
        dplyr::group_by(.data$candidate) |>
        dplyr::summarise(
          mae = mean(abs(.data$prediction - .data$actual)),
          rmse = sqrt(mean((.data$prediction - .data$actual)^2)),
          spearman = suppressWarnings(stats::cor(.data$prediction, .data$actual, method = "spearman")),
          .groups = "drop"
        ) |>
        dplyr::arrange(.data$mae, .data$rmse)
      selected_candidate <- if (nrow(stat_metrics) > 0L) stat_metrics$candidate[[1]] else "anchor"
      train_all <- history[history$season < prediction_season, , drop = FALSE]
      candidates <- sos_stat_projection_candidates(train_all, future, stat)
      future_rows[[future_idx]] <- data.frame(
        position = position,
        prediction_season = prediction_season,
        player_key = future$player_key,
        player = future$player,
        team = dplyr::coalesce(as.character(future$next_team), as.character(future$current_team)),
        stat = stat,
        selected_candidate = selected_candidate,
        current_stat = sos_prob_num(future[[paste0("current_", stat)]]),
        projected_stat = sos_prob_num(candidates[[selected_candidate]]),
        stringsAsFactors = FALSE
      )
      future_idx <- future_idx + 1L
    }
  }

  predictions <- dplyr::bind_rows(prediction_rows) |>
    dplyr::filter(is.finite(.data$prediction), is.finite(.data$actual))
  metrics <- if (nrow(predictions) > 0L) {
    dplyr::bind_rows(lapply(split(predictions, interaction(predictions$position, predictions$stat, predictions$candidate, drop = TRUE)), function(x) {
      data.frame(
        position = x$position[1],
        stat = x$stat[1],
        candidate = x$candidate[1],
        test_seasons = paste(sort(unique(x$test_season)), collapse = ","),
        n = nrow(x),
        mae = mean(abs(x$prediction - x$actual)),
        rmse = sqrt(mean((x$prediction - x$actual)^2)),
        spearman = suppressWarnings(stats::cor(x$prediction, x$actual, method = "spearman")),
        stringsAsFactors = FALSE
      )
    })) |>
      dplyr::arrange(.data$position, .data$stat, .data$mae, .data$rmse)
  } else {
    data.frame()
  }
  selection <- if (nrow(metrics) > 0L) {
    metrics |>
      dplyr::group_by(.data$position, .data$stat) |>
      dplyr::slice_min(.data$mae, n = 1L, with_ties = FALSE) |>
      dplyr::ungroup() |>
      dplyr::mutate(selected = TRUE)
  } else {
    data.frame()
  }

  long_board <- dplyr::bind_rows(future_rows) |>
    dplyr::arrange(.data$position, .data$stat, dplyr::desc(.data$projected_stat))
  wide <- board |>
    dplyr::select("position", "prediction_season", "player_key", "player", "current_team", "next_team")
  if (nrow(long_board) > 0L) {
    for (stat in sort(unique(long_board$stat))) {
      stat_rows <- long_board[long_board$stat == stat, , drop = FALSE]
      wide[[paste0("projected_", stat)]] <- stat_rows$projected_stat[
        match(paste(wide$position, wide$player_key), paste(stat_rows$position, stat_rows$player_key))
      ]
    }
  }
  reconciled_backtest <- build_core_sos_reconciled_stat_backtest(
    positions = unique(as.character(board$position)),
    backtest = backtest,
    raw_predictions = predictions,
    raw_selection = selection,
    write_output = write_output,
    output_dir = output_dir
  )
  stat_reconciliation <- sos_reconcile_stat_projection_to_fantasy(
    board,
    wide,
    prediction_season = prediction_season,
    reconciliation_impact = reconciled_backtest$impact,
    selective_reconciliation = TRUE
  )
  wide <- stat_reconciliation$wide
  reconciliation_audit <- stat_reconciliation$audit
  if ("active_projection_pool" %in% names(board)) {
    inactive_keys <- board |>
      dplyr::filter(!dplyr::coalesce(as.logical(.data$active_projection_pool), TRUE)) |>
      dplyr::distinct(.data$position, .data$prediction_season, .data$player_key)
    inactive_rows <- match(
      paste(wide$position, wide$prediction_season, wide$player_key),
      paste(inactive_keys$position, inactive_keys$prediction_season, inactive_keys$player_key)
    )
    inactive_rows <- which(is.finite(inactive_rows))
    if (length(inactive_rows) > 0L) {
      inactive_stat_cols <- grep("^projected_", names(wide), value = TRUE)
      for (column in inactive_stat_cols) {
        wide[[column]][inactive_rows] <- 0
      }
      for (column in intersect(
        c(
          "stat_target_p50_points", "stat_implied_fantasy_points_before",
          "stat_implied_fantasy_points_after", "stat_reconciliation_abs_delta_before",
          "stat_reconciliation_abs_delta_after", "stat_residual_bridge_gap_before"
        ),
        names(wide)
      )) {
        wide[[column]][inactive_rows] <- 0
      }
      wide$stat_implied_fantasy_points_after <- sos_stat_implied_fantasy_points(wide)
    }
  }
  final_review_stat_promotion <- sos_promote_final_review_stats_to_projection_board(
    board,
    wide,
    prediction_season = prediction_season
  )
  board <- final_review_stat_promotion$board
  wide <- final_review_stat_promotion$wide
  final_review_stat_promotion_audit <- final_review_stat_promotion$audit
  stat_alignment <- sos_apply_stat_alignment_status(wide, prediction_season = prediction_season)
  wide <- stat_alignment$wide
  stat_alignment_detail <- stat_alignment$detail
  stat_alignment_summary <- stat_alignment$summary
  if (nrow(long_board) > 0L && nrow(wide) > 0L) {
    for (stat in sort(unique(long_board$stat))) {
      projected_col <- paste0("projected_", stat)
      if (!projected_col %in% names(wide)) next
      long_board$projected_stat[long_board$stat == stat] <- wide[[projected_col]][
        match(
          paste(long_board$position[long_board$stat == stat], long_board$player_key[long_board$stat == stat]),
          paste(wide$position, wide$player_key)
        )
      ]
    }
  }
  if (isTRUE(write_output)) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    sos_try_write_csv(
      long_board,
      file.path(output_dir, paste0("core_sos_stat_projection_long_", prediction_season, ".csv"))
    )
    sos_try_write_csv(
      wide,
      file.path(output_dir, paste0("core_sos_stat_projection_wide_", prediction_season, ".csv"))
    )
    sos_try_write_csv(
      metrics,
      file.path(output_dir, "core_sos_stat_projection_metrics_2023_2025.csv")
    )
    sos_try_write_csv(
      selection,
      file.path(output_dir, "core_sos_stat_projection_model_selection_2023_2025.csv")
    )
    sos_try_write_csv(
      reconciliation_audit,
      file.path(output_dir, paste0("core_sos_stat_projection_reconciliation_audit_", prediction_season, ".csv"))
    )
    sos_try_write_csv(
      stat_alignment_detail,
      file.path(output_dir, paste0("core_sos_stat_alignment_review_", prediction_season, ".csv"))
    )
    sos_try_write_csv(
      stat_alignment_summary,
      file.path(output_dir, paste0("core_sos_stat_alignment_summary_", prediction_season, ".csv"))
    )
    sos_try_write_csv(
      final_review_stat_promotion_audit,
      file.path(output_dir, paste0("core_sos_final_review_stat_promotion_audit_", prediction_season, ".csv"))
    )
  }

  list(
    board = board,
    long = long_board,
    wide = wide,
    predictions = predictions,
    metrics = metrics,
    selection = selection,
    reconciliation_audit = reconciliation_audit,
    final_review_stat_promotion_audit = final_review_stat_promotion_audit,
    stat_alignment_detail = stat_alignment_detail,
    stat_alignment_summary = stat_alignment_summary,
    reconciled_backtest = reconciled_backtest
  )
}

sos_article_rank_limit <- function(position) {
  position <- toupper(as.character(position))
  dplyr::case_when(
    position == "QB" ~ 40,
    position == "RB" ~ 100,
    position == "WR" ~ 120,
    position == "TE" ~ 70,
    position == "K" ~ 32,
    position == "DST" ~ 32,
    TRUE ~ Inf
  )
}

sos_apply_projection_pool_flags <- function(df) {
  out <- df
  if (is.null(out) || nrow(out) == 0L) return(out)
  if (!"manual_context_note" %in% names(out)) out$manual_context_note <- ""
  if (!"position" %in% names(out)) out$position <- NA_character_

  note <- tolower(dplyr::coalesce(as.character(out$manual_context_note), ""))
  inactive_pattern <- paste(
    c(
      "remove from .*projection pool",
      "remove from usable",
      "remove role expectation",
      "take .* off the list",
      "take .* out",
      "not in the nfl",
      "no longer in the league",
      "will not play",
      "unlikely to play",
      "out for the season",
      "unsigned; remove",
      "not currently with a team",
      "not signed with a team",
      "outside top-32 until",
      "non-starter kicker"
    ),
    collapse = "|"
  )
  forced_inactive <- grepl(inactive_pattern, note, perl = TRUE)

  rank_reference <- rep(NA_real_, nrow(out))
  for (candidate in c(
    "display_rank", "final_value_rank", "calibrated_rank",
    "manual_adjusted_projection_rank", "manual_adjusted_model_rank", "rank"
  )) {
    if (candidate %in% names(out)) {
      rank_reference <- dplyr::coalesce(rank_reference, safe_numeric(out[[candidate]]))
    }
  }

  p50 <- if ("adjusted_p50_points" %in% names(out)) {
    safe_numeric(out$adjusted_p50_points)
  } else {
    rep(NA_real_, nrow(out))
  }
  games <- if ("adjusted_projected_games" %in% names(out)) {
    safe_numeric(out$adjusted_projected_games)
  } else {
    rep(NA_real_, nrow(out))
  }

  article_rank_limit <- sos_article_rank_limit(out$position)
  active_projection_pool <- !forced_inactive
  article_valid_p50 <- is.na(p50) | p50 > 0.5
  article_valid_games <- is.na(games) | games > 0.5
  article_pool_candidate <- active_projection_pool &
    article_valid_p50 &
    article_valid_games

  out$active_projection_pool <- active_projection_pool
  out$article_rank_reference <- rank_reference
  out$article_rank_limit <- article_rank_limit
  out$article_valid_p50 <- article_valid_p50
  out$article_valid_games <- article_valid_games
  out$article_pool_candidate <- article_pool_candidate

  if ("position" %in% names(out)) {
    out <- out |>
      dplyr::group_by(.data$position) |>
      dplyr::arrange(
        .data$position,
        dplyr::coalesce(.data$article_rank_reference, Inf),
        .by_group = TRUE
      ) |>
      dplyr::mutate(
        article_pool_rank = dplyr::if_else(
          .data$article_pool_candidate,
          as.integer(cumsum(.data$article_pool_candidate)),
          NA_integer_
        ),
        article_eligible = .data$article_pool_candidate &
          .data$article_pool_rank <= .data$article_rank_limit,
        article_rank = dplyr::if_else(
          .data$article_eligible,
          as.integer(cumsum(.data$article_eligible)),
          NA_integer_
        )
      ) |>
      dplyr::ungroup()
  } else {
    out$article_pool_rank <- NA_integer_
    out$article_eligible <- FALSE
    out$article_rank <- NA_integer_
  }
  out$eligibility_reason <- dplyr::case_when(
    !out$active_projection_pool ~ "manual_context_removed_or_inactive",
    !out$article_valid_p50 ~ "near_zero_projection",
    !out$article_valid_games ~ "near_zero_games",
    !out$article_eligible ~ "outside_article_rank_window",
    TRUE ~ "eligible"
  )
  out
}

publish_core_sos_projection_console <- function(result, top_n = 10L) {
  top_n <- as.integer(top_n[[1]])
  if (!is.finite(top_n) || top_n < 1L) top_n <- 10L

  cat("\n", strrep("=", 78), "\n", sep = "")
  cat("2026 SOS PROJECTION RESULTS\n")
  cat(strrep("=", 78), "\n", sep = "")

  cat("\nProjection integrity audit\n")
  print(as.data.frame(result$audit), row.names = FALSE)

  cat("\nChronological projection model selections\n")
  model_selection <- result$backtest$selection |>
    dplyr::select(
      "position", "target", "candidate", "test_seasons",
      "n", "mae", "rmse", "spearman"
    ) |>
    dplyr::arrange(
      factor(.data$position, levels = c("QB", "RB", "WR", "TE", "K", "DST")),
      .data$target
    )
  print(as.data.frame(model_selection), row.names = FALSE, digits = 4)

  if (!is.null(result$stat_projection) && nrow(result$stat_projection$selection) > 0L) {
    cat("\nStat projection model selections\n")
    print(
      as.data.frame(
        result$stat_projection$selection |>
          dplyr::select("position", "stat", "candidate", "test_seasons", "n", "mae", "rmse", "spearman") |>
          dplyr::arrange(
            factor(.data$position, levels = c("QB", "RB", "WR", "TE", "K", "DST")),
            .data$stat
          )
      ),
      row.names = FALSE,
      digits = 4
    )
  }

  cat("\nTop ", top_n, " adjusted projections by position\n", sep = "")
  top_board <- result$board |>
    dplyr::group_by(.data$position) |>
    dplyr::slice_min(.data$manual_adjusted_model_rank, n = top_n, with_ties = FALSE) |>
    dplyr::ungroup() |>
    dplyr::transmute(
      position = .data$position,
      rank = .data$manual_adjusted_model_rank,
      projection_rank = .data$manual_adjusted_projection_rank,
      player = .data$player,
      team = dplyr::coalesce(as.character(.data$next_team), as.character(.data$current_team)),
      OMFG = round(.data$official_omfg, 1),
      games = round(.data$adjusted_projected_games, 1),
      P10 = round(.data$adjusted_p10_points, 1),
      P25 = round(.data$adjusted_p25_points, 1),
      P50 = round(.data$adjusted_p50_points, 1),
      P75 = round(.data$adjusted_p75_points, 1),
      P90 = round(.data$adjusted_p90_points, 1),
      context_rows = as.integer(.data$context_adjustment_count)
    ) |>
    dplyr::arrange(
      factor(.data$position, levels = c("QB", "RB", "WR", "TE", "K", "DST")),
      .data$rank
    )
  print(as.data.frame(top_board), row.names = FALSE)

  cat(
    "\nManual context ledger rows: ", nrow(result$ledger),
    "\nFull projection board rows: ", nrow(result$board),
    "\n",
    sep = ""
  )
  invisible(result)
}

sos_review_has_value <- function(x) {
  if (length(x) == 0L) return(FALSE)
  if (is.numeric(x) || is.integer(x)) return(any(is.finite(x)))
  values <- trimws(as.character(x))
  any(!is.na(values) & nzchar(values))
}

sos_compact_initial_projection_review <- function(review) {
  manual_note_cols <- c(
    "manual_context_note", "current_context_rows", "note_for_codex",
    "suggested_adjustment_channel", "suggested_direction",
    "suggested_magnitude_1_to_3", "suggested_confidence_0_to_1",
    "source_reference"
  )
  fixed_cols <- c(
    "position", "prediction_season", "rank", "projection_rank", "player",
    "team", "official_omfg", "projected_games", "projected_ppg",
    "P10", "P25", "P50", "P75", "P90"
  )
  candidate_dynamic_cols <- setdiff(names(review), c(fixed_cols, manual_note_cols))
  dynamic_cols <- candidate_dynamic_cols[vapply(
    review[candidate_dynamic_cols],
    sos_review_has_value,
    logical(1)
  )]
  keep <- c(
    fixed_cols[fixed_cols %in% names(review)],
    dynamic_cols,
    manual_note_cols[manual_note_cols %in% names(review)]
  )
  review[, keep, drop = FALSE]
}

sos_review_magnitude_to_context <- function(channel, magnitude) {
  channel <- sos_normalize_manual_context_channel(channel)
  magnitude <- sos_prob_num(magnitude)
  out <- rep(NA_real_, length(magnitude))
  games_channels <- channel %in% c("projected_games", "active_games", "games_started_distribution")
  out[games_channels] <- pmin(8, pmax(0, magnitude[games_channels]))
  out[!games_channels] <- pmin(1, pmax(0, magnitude[!games_channels] / 3))
  out[!is.finite(out)] <- NA_real_
  out
}

build_sos_manual_context_from_review <- function(
    review_paths = NULL,
    prediction_season = 2026L,
    output_path = sos_manual_context_path(prediction_season),
    append_existing = TRUE,
    write_output = TRUE
) {
  load_model_core_packages()
  prediction_season <- as.integer(prediction_season[[1]])
  if (is.null(review_paths)) {
    review_paths <- file.path(
      sos_production_output_dir(),
      paste0(
        "core_sos_initial_projection_review_",
        tolower(c("QB", "RB", "WR", "TE", "K", "DST")),
        "_",
        prediction_season,
        ".csv"
      )
    )
  }
  review_paths <- review_paths[file.exists(review_paths)]
  if (length(review_paths) == 0L) {
    stop("No SOS review files were found to convert into manual context.", call. = FALSE)
  }

  review <- dplyr::bind_rows(lapply(review_paths, function(path) {
    x <- utils::read.csv(path, stringsAsFactors = FALSE, check.names = FALSE)
    x$review_source_path <- path
    x
  }))

  needed <- c(
    "prediction_season", "position", "player", "team", "note_for_codex",
    "suggested_adjustment_channel", "suggested_direction",
    "suggested_magnitude_1_to_3", "suggested_confidence_0_to_1",
    "source_reference"
  )
  missing <- setdiff(needed, names(review))
  if (length(missing) > 0L) {
    stop("Review file(s) are missing columns: ", paste(missing, collapse = ", "), call. = FALSE)
  }

  notes <- review |>
    dplyr::mutate(
      note_for_codex = dplyr::coalesce(trimws(as.character(.data$note_for_codex)), ""),
      suggested_adjustment_channel = sos_normalize_manual_context_channel(.data$suggested_adjustment_channel),
      suggested_direction = dplyr::coalesce(
        tolower(trimws(as.character(.data$suggested_direction))),
        ""
      ),
      source_reference = dplyr::coalesce(trimws(as.character(.data$source_reference)), "")
    ) |>
    dplyr::filter(
      .data$prediction_season == .env$prediction_season,
      nzchar(.data$note_for_codex) | nzchar(.data$suggested_adjustment_channel)
    ) |>
    dplyr::mutate(
      adjustment_channel = dplyr::if_else(
        nzchar(.data$suggested_adjustment_channel),
        .data$suggested_adjustment_channel,
        "note_only"
      ),
      direction = dplyr::if_else(
        nzchar(.data$suggested_direction),
        .data$suggested_direction,
        "neutral"
      ),
      confidence = sos_normalize_context_confidence(.data$suggested_confidence_0_to_1),
      magnitude = sos_review_magnitude_to_context(
        .data$adjustment_channel,
        .data$suggested_magnitude_1_to_3
      ),
      magnitude = dplyr::if_else(.data$adjustment_channel == "note_only", 0, .data$magnitude),
      reason = .data$note_for_codex,
      source_type = "projection_review",
      enabled = "TRUE"
    ) |>
    dplyr::transmute(
      prediction_season = as.integer(.data$prediction_season),
      position = toupper(as.character(.data$position)),
      player = as.character(.data$player),
      team = normalize_team_abbr(as.character(.data$team)),
      note = .data$note_for_codex,
      adjustment_channel = .data$adjustment_channel,
      direction = .data$direction,
      magnitude = .data$magnitude,
      confidence = .data$confidence,
      reason = .data$reason,
      source_type = .data$source_type,
      source_reference = .data$source_reference,
      enabled = .data$enabled
    )

  if (isTRUE(append_existing) && file.exists(output_path)) {
    existing <- utils::read.csv(output_path, stringsAsFactors = FALSE, check.names = FALSE)
    for (col in setdiff(sos_manual_context_columns(), names(existing))) existing[[col]] <- NA
    for (col in setdiff(sos_manual_context_columns(), names(notes))) notes[[col]] <- NA
    context <- dplyr::bind_rows(
      existing[, sos_manual_context_columns(), drop = FALSE],
      notes[, sos_manual_context_columns(), drop = FALSE]
    )
  } else {
    for (col in setdiff(sos_manual_context_columns(), names(notes))) notes[[col]] <- NA
    context <- notes[, sos_manual_context_columns(), drop = FALSE]
  }

  context <- context |>
    dplyr::distinct(
      .data$prediction_season, .data$position, .data$player, .data$team,
      .data$note, .data$adjustment_channel, .data$direction,
      .data$magnitude, .data$confidence, .data$source_reference,
      .keep_all = TRUE
    )

  if (isTRUE(write_output)) {
    dir.create(dirname(output_path), recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(context, output_path, row.names = FALSE, na = "")
  }

  assign("sos_manual_context_from_review", context, envir = .GlobalEnv)
  invisible(context)
}

build_core_sos_initial_projection_review <- function(
    projection_result = get0("core_sos_projection_layer", envir = .GlobalEnv),
    prediction_season = NULL,
    top_n = Inf,
    write_output = TRUE,
    output_dir = sos_production_output_dir(),
    publish_console = TRUE,
    write_position_files = TRUE
) {
  load_model_core_packages()
  if (is.null(projection_result) || is.null(projection_result$board)) {
    if (!is.null(projection_result$projection_layer) && !is.null(projection_result$projection_layer$board)) {
      projection_result <- projection_result$projection_layer
    } else {
      stop(
        "No SOS projection layer is available. Run run_core_sos_production() first, ",
        "or pass sos_2026$projection_layer.",
        call. = FALSE
      )
    }
  }
  board <- projection_result$board
  if (is.null(prediction_season)) {
    prediction_season <- unique(as.integer(board$prediction_season))
    prediction_season <- prediction_season[is.finite(prediction_season)][1]
  }
  prediction_season <- as.integer(prediction_season[[1]])
  top_n_value <- suppressWarnings(as.numeric(top_n[[1]]))
  if (!is.finite(top_n_value)) {
    top_n <- Inf
  } else {
    top_n <- as.integer(top_n_value)
    if (top_n < 1L) top_n <- Inf
  }

  probability_cols <- grep("^prob_(ppg|total)_top[0-9]+$", names(board), value = TRUE)
  sim_probability_cols <- grep("^adjusted_sim_prob_top[0-9]+$", names(board), value = TRUE)
  stat_cols <- grep("^projected_", names(board), value = TRUE)
  stat_cols <- setdiff(stat_cols, c("projected_games", "projected_ppg"))
  roster_cols <- intersect(
    c(
      "player_key", "prior_team_2025", "depth_chart_team_2026",
      "depth_team_2026", "depth_ecr_2026", "roster_context_source",
      "is_2026_rookie", "is_new_to_sos_pool"
    ),
    names(board)
  )
  review <- board |>
    dplyr::mutate(
      team = dplyr::coalesce(as.character(.data$next_team), as.character(.data$current_team)),
      projected_games = .data$adjusted_projected_games,
      projected_ppg = dplyr::if_else(
        is.finite(.data$adjusted_projected_games) & .data$adjusted_projected_games > 0,
        .data$adjusted_p50_points / .data$adjusted_projected_games,
        NA_real_
      )
    ) |>
    dplyr::select(
      "position", "prediction_season",
      rank = "manual_adjusted_model_rank",
      projection_rank = "manual_adjusted_projection_rank",
      "player", "team", "official_omfg",
      dplyr::all_of(roster_cols),
      "projected_games", "projected_ppg",
      P10 = "adjusted_p10_points",
      P25 = "adjusted_p25_points",
      P50 = "adjusted_p50_points",
      P75 = "adjusted_p75_points",
      P90 = "adjusted_p90_points",
      dplyr::all_of(probability_cols),
      dplyr::all_of(sim_probability_cols),
      dplyr::all_of(stat_cols),
      "manual_context_note",
      current_context_rows = "context_adjustment_count"
    ) |>
    dplyr::mutate(
      note_for_codex = "",
      suggested_adjustment_channel = "",
      suggested_direction = "",
      suggested_magnitude_1_to_3 = NA_real_,
      suggested_confidence_0_to_1 = NA_real_,
      source_reference = ""
    ) |>
    dplyr::arrange(
      factor(.data$position, levels = c("QB", "RB", "WR", "TE", "K", "DST")),
      .data$rank
    )

  if (is.finite(top_n)) {
    review <- review |>
      dplyr::group_by(.data$position) |>
      dplyr::slice_min(.data$rank, n = top_n, with_ties = FALSE) |>
      dplyr::ungroup()
  }

  if (isTRUE(write_output)) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    utils::write.csv(
      review,
      file.path(output_dir, paste0("core_sos_initial_projection_review_", prediction_season, ".csv")),
      row.names = FALSE,
      na = ""
    )
    if (isTRUE(write_position_files)) {
      position_paths <- lapply(split(review, review$position), function(position_review) {
        position <- tolower(unique(position_review$position)[1])
        path <- file.path(
          output_dir,
          paste0("core_sos_initial_projection_review_", position, "_", prediction_season, ".csv")
        )
        utils::write.csv(
          sos_compact_initial_projection_review(position_review),
          path,
          row.names = FALSE,
          na = ""
        )
        data.frame(
          position = toupper(position),
          output_path = path,
          exists = file.exists(path),
          stringsAsFactors = FALSE
        )
      })
      position_paths <- dplyr::bind_rows(position_paths) |>
        dplyr::arrange(factor(.data$position, levels = c("QB", "RB", "WR", "TE", "K", "DST")))
      assign("core_sos_initial_projection_review_position_files", position_paths, envir = .GlobalEnv)
    }
  }

  if (isTRUE(publish_console)) {
    cat("\n", strrep("=", 78), "\n", sep = "")
    cat(prediction_season, " SOS INITIAL PROJECTION REVIEW BOARD\n", sep = "")
    cat(strrep("=", 78), "\n", sep = "")
    cat(
      "\nRows: ", nrow(review),
      " | Positions: ", paste(unique(review$position), collapse = ", "),
      "\n",
      sep = ""
    )
    print(
      as.data.frame(
        review |>
          dplyr::transmute(
            position = .data$position,
            rank = .data$rank,
            projection_rank = .data$projection_rank,
            player = .data$player,
            team = .data$team,
            OMFG = round(.data$official_omfg, 1),
            games = round(.data$projected_games, 1),
            ppg = round(.data$projected_ppg, 2),
            P10 = round(.data$P10, 1),
            P50 = round(.data$P50, 1),
            P90 = round(.data$P90, 1),
            context_rows = as.integer(.data$current_context_rows)
          )
      ),
      row.names = FALSE
    )
    if (isTRUE(write_output)) {
      cat(
        "\nReview CSV: ",
        file.path(output_dir, paste0("core_sos_initial_projection_review_", prediction_season, ".csv")),
        "\n",
        sep = ""
      )
      if (exists("position_paths", inherits = FALSE) && nrow(position_paths) > 0L) {
        cat("\nPosition review CSVs\n")
        print(as.data.frame(position_paths), row.names = FALSE)
      }
    }
  }

  assign("core_sos_initial_projection_review", review, envir = .GlobalEnv)
  invisible(review)
}

sos_default_market_adp_path <- function(prediction_season = 2026L) {
  file.path(
    dirname(getwd()),
    "NFLfastR",
    paste0(as.integer(prediction_season), " data"),
    paste0("FantasyPros_", as.integer(prediction_season), "_Overall_ADP_Rankings.csv")
  )
}

sos_default_manual_rank_dir <- function(prediction_season = 2026L) {
  file.path(
    dirname(getwd()),
    "NFLfastR",
    paste0(as.integer(prediction_season), " data")
  )
}

sos_find_manual_rank_file <- function(position, prediction_season = 2026L,
                                      manual_rank_dir = sos_default_manual_rank_dir(prediction_season)) {
  position <- toupper(as.character(position[[1]]))
  if (!dir.exists(manual_rank_dir)) return(NA_character_)
  candidates <- list.files(manual_rank_dir, pattern = "\\.csv$", full.names = TRUE)
  pattern <- paste0(
    "^NFL_", as.integer(prediction_season),
    "_.*_Draft_", position, "_Rankings( \\([0-9]+\\))?\\.csv$"
  )
  candidates <- candidates[grepl(pattern, basename(candidates), ignore.case = TRUE)]
  if (length(candidates) == 0L) return(NA_character_)
  candidates[order(file.info(candidates)$mtime, decreasing = TRUE)][[1]]
}

sos_read_manual_rank_files <- function(
    prediction_season = 2026L,
    manual_rank_dir = sos_default_manual_rank_dir(prediction_season),
    default_confidence = 0.75
) {
  load_model_core_packages()
  prediction_season <- as.integer(prediction_season[[1]])
  default_confidence <- pmin(1, pmax(0, as.numeric(default_confidence[[1]])))
  positions <- c("QB", "RB", "WR", "TE", "K", "DST")
  rows <- list()
  manifest <- list()

  for (position in positions) {
    path <- sos_find_manual_rank_file(position, prediction_season, manual_rank_dir)
    if (!is.character(path) || length(path) == 0L || is.na(path) || !file.exists(path)) {
      manifest[[position]] <- data.frame(
        position = position, source_file = NA_character_, source_rows = 0L,
        duplicate_player_keys = 0L, exists = FALSE, stringsAsFactors = FALSE
      )
      next
    }
    source <- utils::read.csv(path, stringsAsFactors = FALSE, check.names = FALSE)
    name_col <- names(source)[tolower(names(source)) %in% c("name", "player")][1]
    if (length(name_col) == 0L || is.na(name_col)) {
      stop("Manual rank file is missing a Name or Player column: ", path, call. = FALSE)
    }
    team_col <- names(source)[tolower(names(source)) %in% c("team", "tm")][1]
    rank_col <- names(source)[tolower(names(source)) %in% c("manual_rank", "rank")][1]
    confidence_col <- names(source)[tolower(names(source)) %in% c("manual_confidence", "confidence")][1]
    note_col <- names(source)[tolower(names(source)) %in% c("manual_rank_note", "note", "notes")][1]
    enabled_col <- names(source)[tolower(names(source)) %in% c("manual_rank_enabled", "enabled")][1]

    manual_rank <- if (length(rank_col) == 1L && !is.na(rank_col)) {
      suppressWarnings(as.integer(source[[rank_col]]))
    } else {
      seq_len(nrow(source))
    }
    manual_confidence <- if (length(confidence_col) == 1L && !is.na(confidence_col)) {
      suppressWarnings(as.numeric(source[[confidence_col]]))
    } else {
      rep(default_confidence, nrow(source))
    }
    manual_confidence <- pmin(1, pmax(0, dplyr::coalesce(manual_confidence, default_confidence)))
    manual_enabled <- if (length(enabled_col) == 1L && !is.na(enabled_col)) {
      sos_context_enabled(source[[enabled_col]])
    } else {
      rep(TRUE, nrow(source))
    }
    manual_player <- trimws(as.character(source[[name_col]]))
    manual_team <- if (length(team_col) == 1L && !is.na(team_col)) {
      normalize_team_abbr(toupper(trimws(as.character(source[[team_col]]))))
    } else {
      rep(NA_character_, nrow(source))
    }
    manual_note <- if (length(note_col) == 1L && !is.na(note_col)) {
      dplyr::coalesce(as.character(source[[note_col]]), "")
    } else {
      rep("", nrow(source))
    }
    parsed <- data.frame(
      position = position,
      prediction_season = prediction_season,
      manual_player = manual_player,
      manual_team = manual_team,
      player_key = make_player_key(manual_player),
      manual_rank = manual_rank,
      manual_rank_confidence = manual_confidence,
      manual_rank_note = manual_note,
      manual_rank_enabled = dplyr::coalesce(as.logical(manual_enabled), FALSE),
      manual_rank_field_size = nrow(source),
      manual_rank_source_file = basename(path),
      manual_rank_source_row = seq_len(nrow(source)),
      stringsAsFactors = FALSE
    ) |>
      dplyr::filter(
        nzchar(.data$manual_player), nzchar(.data$player_key),
        is.finite(.data$manual_rank), .data$manual_rank > 0,
        .data$manual_rank_enabled
      )
    duplicate_keys <- sum(duplicated(parsed[c("position", "player_key")]))
    manifest[[position]] <- data.frame(
      position = position, source_file = path, source_rows = nrow(source),
      duplicate_player_keys = duplicate_keys, exists = TRUE, stringsAsFactors = FALSE
    )
    rows[[position]] <- parsed |>
      dplyr::arrange(.data$manual_rank, .data$manual_rank_source_row) |>
      dplyr::distinct(.data$position, .data$player_key, .keep_all = TRUE)
  }

  list(
    ranks = dplyr::bind_rows(rows),
    manifest = dplyr::bind_rows(manifest)
  )
}

sos_seed_manual_rank_missing_players <- function(board, manual_ranks, prediction_season = 2026L) {
  load_model_core_packages()
  prediction_season <- as.integer(prediction_season[[1]])
  board_keys <- board |>
    dplyr::distinct(.data$position, .data$player_key)
  source_only <- manual_ranks |>
    dplyr::anti_join(board_keys, by = c("position", "player_key")) |>
    dplyr::arrange(
      factor(.data$position, levels = c("QB", "RB", "WR", "TE", "K", "DST")),
      .data$manual_rank
    )
  if (nrow(source_only) == 0L) {
    board$manual_rank_seeded_player <- FALSE
    board$manual_rank_seed_donor <- NA_character_
    board$manual_rank_seed_percentile <- NA_real_
    return(list(board = board, seeded = source_only))
  }

  seeded <- lapply(seq_len(nrow(source_only)), function(i) {
    source_row <- source_only[i, , drop = FALSE]
    position <- source_row$position[[1]]
    pool <- board[board$position == position, , drop = FALSE] |>
      dplyr::arrange(.data$baseline_projection_rank, .data$baseline_model_rank, .data$player)
    if (nrow(pool) == 0L) return(NULL)
    source_field_size <- max(2, sos_prob_num(source_row$manual_rank_field_size[[1]]))
    source_percentile <- pmin(
      1,
      pmax(0, (sos_prob_num(source_row$manual_rank[[1]]) - 1) / (source_field_size - 1))
    )
    donor_index <- as.integer(round(1 + source_percentile * (nrow(pool) - 1)))
    donor_index <- pmin(nrow(pool), pmax(1L, donor_index))
    donor <- pool[donor_index, , drop = FALSE]
    donor_player <- as.character(donor$player[[1]])
    donor$position <- position
    donor$prediction_season <- prediction_season
    donor$player <- as.character(source_row$manual_player[[1]])
    donor$player_key <- as.character(source_row$player_key[[1]])
    donor$current_team <- as.character(source_row$manual_team[[1]])
    donor$next_team <- as.character(source_row$manual_team[[1]])
    if ("team" %in% names(donor)) donor$team <- as.character(source_row$manual_team[[1]])
    if ("production_mode" %in% names(donor)) donor$production_mode <- "manual_rank_seeded_player"
    if ("rank" %in% names(donor)) donor$rank <- as.integer(source_row$manual_rank[[1]])
    if ("tier" %in% names(donor)) {
      donor$tier <- sos_rank_tier_from_rank(position, as.integer(source_row$manual_rank[[1]]))
    }
    if ("roster_context_source" %in% names(donor)) {
      donor$roster_context_source <- "manual_rank_authoritative_seed"
    }
    if ("depth_chart_team_2026" %in% names(donor)) {
      donor$depth_chart_team_2026 <- as.character(source_row$manual_team[[1]])
    }
    if ("depth_team_2026" %in% names(donor)) donor$depth_team_2026 <- NA_real_
    if ("depth_ecr_2026" %in% names(donor)) donor$depth_ecr_2026 <- NA_real_
    if ("is_2026_rookie" %in% names(donor)) donor$is_2026_rookie <- 0L
    if ("is_new_to_sos_pool" %in% names(donor)) donor$is_new_to_sos_pool <- 1L
    donor$manual_rank_seeded_player <- TRUE
    donor$manual_rank_seed_donor <- donor_player
    donor$manual_rank_seed_percentile <- source_percentile
    donor
  })
  seeded <- dplyr::bind_rows(seeded)
  board$manual_rank_seeded_player <- FALSE
  board$manual_rank_seed_donor <- NA_character_
  board$manual_rank_seed_percentile <- NA_real_
  augmented <- dplyr::bind_rows(board, seeded) |>
    dplyr::group_by(.data$position) |>
    dplyr::mutate(
      field_size = dplyr::n(),
      baseline_projection_rank = rank(
        -.data$baseline_average_range_score,
        ties.method = "first",
        na.last = "keep"
      ),
      baseline_model_rank = rank(
        -.data$official_omfg,
        ties.method = "first",
        na.last = "keep"
      )
    ) |>
    dplyr::ungroup()
  list(board = augmented, seeded = source_only)
}

sos_apply_manual_rank_context <- function(
    board,
    prediction_season = 2026L,
    manual_rank_dir = sos_default_manual_rank_dir(prediction_season),
    manual_rank_weight = 0.30,
    default_confidence = 0.75,
    max_projection_pct = 0.08
) {
  load_model_core_packages()
  prediction_season <- as.integer(prediction_season[[1]])
  manual_rank_weight <- pmin(0.45, pmax(0, as.numeric(manual_rank_weight[[1]])))
  max_projection_pct <- pmin(0.15, pmax(0, as.numeric(max_projection_pct[[1]])))
  imported <- sos_read_manual_rank_files(
    prediction_season = prediction_season,
    manual_rank_dir = manual_rank_dir,
    default_confidence = default_confidence
  )
  ranks <- imported$ranks
  # Confirmed post-rank-file signings remain model-driven until the next
  # manual rank refresh. Zero confidence keeps them in the pool without
  # adding a subjective manual-rank contribution.
  active_news_keys <- data.frame(
    position = "WR",
    player_key = make_player_key("Keenan Allen"),
    stringsAsFactors = FALSE
  )
  manual_rank_field_sizes <- ranks |>
    dplyr::group_by(.data$position) |>
    dplyr::summarise(
      manual_rank_field_size = max(.data$manual_rank_field_size, na.rm = TRUE),
      .groups = "drop"
    )
  active_news_rows <- board |>
    dplyr::semi_join(active_news_keys, by = c("position", "player_key")) |>
    dplyr::anti_join(ranks, by = c("position", "player_key")) |>
    dplyr::transmute(
      position = .data$position,
      player_key = .data$player_key,
      manual_player = .data$player,
      manual_team = "IND",
      manual_rank = dplyr::coalesce(
        safe_numeric(.data$baseline_projection_rank),
        safe_numeric(.data$rank)
      ),
      manual_rank_confidence = 0,
      manual_rank_note = "Confirmed Indianapolis signing after the manual-rank file was created; retain model-driven rank.",
      manual_rank_source_file = "nfl_context_brief_2026_08_19",
      manual_rank_source_row = NA_integer_
    ) |>
    dplyr::left_join(manual_rank_field_sizes, by = "position")
  if (nrow(active_news_rows) > 0L) {
    ranks <- dplyr::bind_rows(ranks, active_news_rows) |>
      dplyr::distinct(.data$position, .data$player_key, .keep_all = TRUE)
  }
  original_board_keys <- board |>
    dplyr::distinct(.data$position, .data$player_key, .data$player, .data$current_team)
  unmatched_board <- original_board_keys |>
    dplyr::anti_join(ranks, by = c("position", "player_key"))
  seeded_pool <- sos_seed_manual_rank_missing_players(board, ranks, prediction_season)
  unmatched_source <- seeded_pool$seeded
  board <- seeded_pool$board |>
    dplyr::semi_join(ranks, by = c("position", "player_key")) |>
    dplyr::mutate(manual_rank_authoritative_pool = TRUE) |>
    dplyr::group_by(.data$position) |>
    dplyr::mutate(
      manual_adjusted_projection_rank = rank(
        -.data$adjusted_average_range_score,
        ties.method = "first",
        na.last = "keep"
      ),
      manual_adjusted_model_rank = rank(
        -.data$official_omfg,
        ties.method = "first",
        na.last = "keep"
      ),
      manual_adjusted_rank_delta = .data$baseline_model_rank - .data$manual_adjusted_model_rank,
      manual_adjusted_projection_rank_delta =
        .data$baseline_projection_rank - .data$manual_adjusted_projection_rank
    ) |>
    dplyr::ungroup() |>
    dplyr::select(
      -dplyr::any_of(c(
        "manual_player", "manual_team", "manual_rank", "manual_rank_confidence",
        "manual_rank_note", "manual_rank_field_size", "manual_rank_source_file",
        "manual_rank_source_row", "manual_rank_has_input",
        "manual_rank_pre_projection_rank", "manual_rank_pre_projected_games",
        "manual_rank_pre_projected_ppg", "manual_rank_pre_p10_points",
        "manual_rank_pre_p25_points", "manual_rank_pre_p50_points",
        "manual_rank_pre_p75_points", "manual_rank_pre_p90_points",
        "manual_rank_model_score_0to100", "manual_rank_projection_score_0to100",
        "manual_rank_market_score_0to100", "manual_rank_input_score_0to100",
        "manual_rank_effective_weight", "manual_rank_model_weight",
        "manual_rank_projection_weight", "manual_rank_market_weight",
        "manual_rank_weight_total", "manual_rank_blend_score",
        "manual_rank_blend_rank", "manual_rank_delta_vs_projection",
        "manual_rank_projection_pct", "manual_rank_projection_multiplier",
        "manual_rank_context_applied"
      ))
    )

  out <- board |>
    dplyr::left_join(
      ranks |>
        dplyr::select(
          "position", "player_key", "manual_player", "manual_team",
          "manual_rank", "manual_rank_confidence", "manual_rank_note",
          "manual_rank_field_size", "manual_rank_source_file", "manual_rank_source_row"
        ),
      by = c("position", "player_key"),
      relationship = "many-to-one"
    ) |>
    dplyr::group_by(.data$position) |>
    dplyr::mutate(
      manual_rank_pre_projection_rank = .data$manual_adjusted_projection_rank,
      manual_rank_pre_projected_games = .data$adjusted_projected_games,
      manual_rank_pre_projected_ppg = .data$adjusted_projected_ppg,
      manual_rank_pre_p10_points = .data$adjusted_p10_points,
      manual_rank_pre_p25_points = .data$adjusted_p25_points,
      manual_rank_pre_p50_points = .data$adjusted_p50_points,
      manual_rank_pre_p75_points = .data$adjusted_p75_points,
      manual_rank_pre_p90_points = .data$adjusted_p90_points,
      manual_rank_has_input = is.finite(.data$manual_rank) & .data$manual_rank > 0,
      manual_rank_confidence = dplyr::if_else(
        .data$manual_rank_has_input,
        pmin(1, pmax(0, dplyr::coalesce(.data$manual_rank_confidence, .env$default_confidence))),
        0
      ),
      manual_rank_model_score_0to100 = sos_prob_rank_score(.data$manual_adjusted_model_rank, dplyr::n()),
      manual_rank_projection_score_0to100 = sos_prob_rank_score(.data$manual_adjusted_projection_rank, dplyr::n()),
      manual_rank_market_score_0to100 = dplyr::if_else(
        is.finite(.data$market_position_rank),
        sos_prob_rank_score(.data$market_position_rank, dplyr::n()),
        NA_real_
      ),
      manual_rank_input_score_0to100 = dplyr::if_else(
        .data$manual_rank_has_input,
        sos_prob_rank_score(.data$manual_rank, pmax(2, .data$manual_rank_field_size)),
        NA_real_
      ),
      manual_rank_effective_weight = dplyr::if_else(
        .data$manual_rank_has_input,
        .env$manual_rank_weight * .data$manual_rank_confidence,
        0
      ),
      manual_rank_model_weight = 0.30 +
        (.env$manual_rank_weight - .data$manual_rank_effective_weight) * 0.60,
      manual_rank_projection_weight = 0.20 +
        (.env$manual_rank_weight - .data$manual_rank_effective_weight) * 0.40,
      manual_rank_market_weight = dplyr::if_else(is.finite(.data$market_position_rank), 0.20, 0),
      manual_rank_weight_total = .data$manual_rank_model_weight +
        .data$manual_rank_projection_weight + .data$manual_rank_effective_weight +
        .data$manual_rank_market_weight,
      manual_rank_blend_score = (
        .data$manual_rank_model_weight * .data$manual_rank_model_score_0to100 +
          .data$manual_rank_projection_weight * .data$manual_rank_projection_score_0to100 +
          .data$manual_rank_effective_weight * dplyr::coalesce(
            .data$manual_rank_input_score_0to100,
            .data$manual_rank_projection_score_0to100
          ) +
          .data$manual_rank_market_weight * dplyr::coalesce(
            .data$manual_rank_market_score_0to100,
            .data$manual_rank_projection_score_0to100
          )
      ) / pmax(.data$manual_rank_weight_total, 1e-6),
      manual_rank_blend_rank = rank(
        -.data$manual_rank_blend_score,
        ties.method = "first",
        na.last = "keep"
      ),
      manual_rank_delta_vs_projection = .data$manual_rank_pre_projection_rank - .data$manual_rank_blend_rank,
      manual_rank_projection_pct = dplyr::if_else(
        .data$manual_rank_has_input,
        pmin(
          .env$max_projection_pct,
          pmax(
            -.env$max_projection_pct,
            .data$manual_rank_delta_vs_projection * 0.004 * .data$manual_rank_confidence
          )
        ),
        0
      ),
      manual_rank_projection_multiplier = 1 + .data$manual_rank_projection_pct,
      manual_rank_context_applied = .data$manual_rank_has_input &
        abs(.data$manual_rank_projection_pct) > 1e-12,
      adjusted_projected_ppg = pmax(
        0,
        .data$adjusted_projected_ppg * .data$manual_rank_projection_multiplier
      ),
      adjusted_p10_points = pmax(0, .data$adjusted_p10_points * .data$manual_rank_projection_multiplier),
      adjusted_p25_points = pmax(0, .data$adjusted_p25_points * .data$manual_rank_projection_multiplier),
      adjusted_p50_points = pmax(0, .data$adjusted_p50_points * .data$manual_rank_projection_multiplier),
      adjusted_p75_points = pmax(0, .data$adjusted_p75_points * .data$manual_rank_projection_multiplier),
      adjusted_p90_points = pmax(0, .data$adjusted_p90_points * .data$manual_rank_projection_multiplier)
    ) |>
    dplyr::ungroup()
  out <- sos_enforce_projection_ranges(
    out,
    c(
      "adjusted_p10_points", "adjusted_p25_points", "adjusted_p50_points",
      "adjusted_p75_points", "adjusted_p90_points"
    )
  ) |>
    dplyr::mutate(
      adjusted_average_range_score = (
        .data$adjusted_p25_points + .data$adjusted_p50_points + .data$adjusted_p75_points
      ) / 3
    ) |>
    dplyr::group_by(.data$position) |>
    dplyr::mutate(
      manual_adjusted_projection_rank = rank(
        -.data$adjusted_average_range_score,
        ties.method = "first",
        na.last = "keep"
      ),
      manual_adjusted_projection_rank_delta =
        .data$baseline_projection_rank - .data$manual_adjusted_projection_rank
    ) |>
    dplyr::ungroup()

  audit <- dplyr::bind_rows(lapply(c("QB", "RB", "WR", "TE", "K", "DST"), function(position) {
    x <- out[out$position == position, , drop = FALSE]
    source <- ranks[ranks$position == position, , drop = FALSE]
    source_duplicates <- imported$manifest$duplicate_player_keys[imported$manifest$position == position]
    source_duplicates <- if (length(source_duplicates) == 1L) source_duplicates else 0L
    data.frame(
      position = position,
      prediction_season = prediction_season,
      board_rows = nrow(x),
      source_rows = nrow(source),
      matched_board_rows = sum(x$manual_rank_has_input, na.rm = TRUE),
      unmatched_board_rows = sum(!x$manual_rank_has_input, na.rm = TRUE),
      omitted_model_rows = sum(unmatched_board$position == position),
      source_only_seeded_rows = sum(unmatched_source$position == position),
      unmatched_source_rows = 0L,
      board_match_rate = if (nrow(x) > 0L) mean(x$manual_rank_has_input) else NA_real_,
      source_duplicate_player_keys = source_duplicates,
      projection_adjustment_rows = sum(x$manual_rank_context_applied, na.rm = TRUE),
      max_abs_rank_move = max(abs(x$manual_rank_pre_projection_rank - x$manual_adjusted_projection_rank), na.rm = TRUE),
      max_abs_projection_pct = max(abs(x$manual_rank_projection_pct), na.rm = TRUE),
      missing_final_projection_ranks = sum(!is.finite(x$manual_adjusted_projection_rank)),
      status = if (
        nrow(x) > 0L && sum(x$manual_rank_has_input, na.rm = TRUE) > 0L &&
          source_duplicates == 0L &&
          sum(!is.finite(x$manual_adjusted_projection_rank)) == 0L &&
          max(abs(x$manual_rank_projection_pct), na.rm = TRUE) <= max_projection_pct + 1e-12
      ) "PASS" else "FAIL",
      stringsAsFactors = FALSE
    )
  }))

  list(
    board = out,
    audit = audit,
    ranks = ranks,
    source_manifest = imported$manifest,
    source_only_seeded = unmatched_source,
    omitted_model_players = unmatched_board,
    unmatched_source = unmatched_source,
    unmatched_board = unmatched_board
  )
}

sos_parse_fantasypros_adp <- function(path = sos_default_market_adp_path(2026L)) {
  if (!file.exists(path)) {
    stop("Missing FantasyPros ADP file: ", path, call. = FALSE)
  }
  adp <- utils::read.csv(path, stringsAsFactors = FALSE, check.names = FALSE)
  required <- c("Rank", "Player (Bye)", "POS", "AVG")
  missing <- setdiff(required, names(adp))
  if (length(missing) > 0L) {
    stop("FantasyPros ADP file is missing columns: ", paste(missing, collapse = ", "), call. = FALSE)
  }

  raw_player <- as.character(adp[["Player (Bye)"]])
  player <- sub("\\s{2,}[A-Z]{2,3}\\s*\\([0-9]+\\)\\s*$", "", raw_player)
  team <- sub("^.*\\s{2,}([A-Z]{2,3})\\s*\\([0-9]+\\)\\s*$", "\\1", raw_player)
  team[team == raw_player] <- NA_character_
  pos <- toupper(gsub("[0-9]+", "", as.character(adp$POS)))
  pos_rank <- suppressWarnings(as.integer(gsub("[^0-9]", "", as.character(adp$POS))))

  data.frame(
    market_source = basename(path),
    market_overall_rank = suppressWarnings(as.numeric(adp$Rank)),
    market_avg_adp = suppressWarnings(as.numeric(adp$AVG)),
    market_yahoo_rank = if ("Yahoo" %in% names(adp)) suppressWarnings(as.numeric(adp$Yahoo)) else NA_real_,
    market_sleeper_rank = if ("Sleeper" %in% names(adp)) suppressWarnings(as.numeric(adp$Sleeper)) else NA_real_,
    market_rtsports_rank = if ("RTSports" %in% names(adp)) suppressWarnings(as.numeric(adp$RTSports)) else NA_real_,
    market_realtime_rank = if ("Real-Time" %in% names(adp)) suppressWarnings(as.numeric(adp$`Real-Time`)) else NA_real_,
    market_position = pos,
    market_position_rank = pos_rank,
    market_player = player,
    market_team = normalize_team_abbr(team),
    player_key = make_player_key(player),
    stringsAsFactors = FALSE
  ) |>
    dplyr::filter(nzchar(.data$market_player), nzchar(.data$market_position)) |>
    dplyr::arrange(.data$market_position, .data$market_position_rank, .data$market_overall_rank) |>
    dplyr::distinct(.data$market_position, .data$player_key, .keep_all = TRUE)
}

sos_try_write_csv <- function(x, path) {
  ok <- tryCatch(
    {
      utils::write.csv(x, path, row.names = FALSE, na = "")
      TRUE
    },
    error = function(e) {
      alt_path <- sub(
        "\\.csv$",
        paste0("_alternate_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".csv"),
        path
      )
      alt_ok <- tryCatch(
        {
          utils::write.csv(x, alt_path, row.names = FALSE, na = "")
          TRUE
        },
        error = function(e2) {
          warning(
            "Could not write ", path, " or alternate ", alt_path, ": ",
            conditionMessage(e2),
            call. = FALSE
          )
          FALSE
        }
      )
      if (isTRUE(alt_ok)) {
        warning(
          "Could not write ", path, ": ", conditionMessage(e),
          ". Wrote alternate file: ", alt_path,
          call. = FALSE
        )
      }
      alt_ok
    }
  )
  invisible(ok)
}

sos_apply_adp_market_context <- function(
    board,
    prediction_season = 2026L,
    market_path = sos_default_market_adp_path(prediction_season),
    market_weight = 0.20,
    max_projection_pct = 0.12
) {
  load_model_core_packages()
  prediction_season <- as.integer(prediction_season[[1]])
  if (!file.exists(market_path)) {
    board$market_context_applied <- FALSE
    board$market_context_note <- "missing_market_adp_file"
    return(board)
  }

  market <- sos_parse_fantasypros_adp(market_path)
  out <- board |>
    dplyr::left_join(
      market |>
        dplyr::select(
          "player_key", "market_source", "market_player", "market_team",
          "market_position", "market_position_rank", "market_overall_rank",
          "market_avg_adp", "market_yahoo_rank", "market_sleeper_rank",
          "market_rtsports_rank", "market_realtime_rank"
        ),
      by = "player_key",
      relationship = "many-to-one"
    ) |>
    dplyr::group_by(.data$position) |>
    dplyr::mutate(
      position_field_size = dplyr::n(),
      pre_market_projected_games = .data$baseline_projected_games,
      pre_market_projected_ppg = .data$baseline_projected_ppg,
      pre_market_p10_points = .data$baseline_p10_points,
      pre_market_p25_points = .data$baseline_p25_points,
      pre_market_p50_points = .data$baseline_p50_points,
      pre_market_p75_points = .data$baseline_p75_points,
      pre_market_p90_points = .data$baseline_p90_points,
      pre_market_projection_rank = .data$baseline_projection_rank,
      pre_market_average_range_score = .data$baseline_average_range_score,
      has_market_rank = !is.na(.data$market_position_rank) &
        .data$market_position == .data$position,
      market_position_rank = dplyr::if_else(
        .data$has_market_rank,
        .data$market_position_rank,
        NA_integer_
      ),
      market_overall_rank = dplyr::if_else(
        .data$has_market_rank,
        .data$market_overall_rank,
        NA_real_
      ),
      market_avg_adp = dplyr::if_else(
        .data$has_market_rank,
        .data$market_avg_adp,
        NA_real_
      ),
      market_rank_score_0to100 = dplyr::if_else(
        .data$has_market_rank,
        sos_prob_rank_score(.data$market_position_rank, .data$position_field_size),
        NA_real_
      ),
      model_rank_score_0to100 = sos_prob_rank_score(.data$baseline_model_rank, .data$position_field_size),
      projection_rank_score_0to100 = sos_prob_rank_score(.data$baseline_projection_rank, .data$position_field_size),
      market_context_score = dplyr::if_else(
        .data$has_market_rank,
        (1 - .env$market_weight) * (
          0.5625 * .data$model_rank_score_0to100 +
            0.4375 * .data$projection_rank_score_0to100
        ) +
          .env$market_weight * .data$market_rank_score_0to100,
        0.5625 * .data$model_rank_score_0to100 +
          0.4375 * .data$projection_rank_score_0to100
      ),
      market_context_rank = rank(
        -.data$market_context_score,
        ties.method = "first",
        na.last = "keep"
      ),
      market_context_rank_delta_vs_projection =
        .data$baseline_projection_rank - .data$market_context_rank,
      market_projection_rank_gap = .data$baseline_projection_rank - .data$market_position_rank,
      market_context_pct = dplyr::if_else(
        .data$has_market_rank,
        pmin(
          .env$max_projection_pct,
          pmax(
            -.env$max_projection_pct,
            .data$market_context_rank_delta_vs_projection * 0.005
          )
        ),
        0
      ),
      market_context_applied = .data$has_market_rank & abs(.data$market_context_pct) > 1e-12,
      market_context_note = dplyr::case_when(
        !.data$has_market_rank ~ "no_market_rank",
        .data$market_context_pct > 0 ~ "adp_context_projection_increase",
        .data$market_context_pct < 0 ~ "adp_context_projection_decrease",
        TRUE ~ "adp_context_no_projection_change"
      ),
      baseline_projected_ppg = pmax(
        0,
        .data$baseline_projected_ppg * (1 + .data$market_context_pct)
      ),
      baseline_p50_points = pmax(
        0,
        .data$baseline_projected_ppg * .data$baseline_projected_games
      ),
      baseline_p10_points = pmax(0, .data$baseline_p10_points * (1 + .data$market_context_pct)),
      baseline_p25_points = pmax(0, .data$baseline_p25_points * (1 + .data$market_context_pct)),
      baseline_p75_points = pmax(0, .data$baseline_p75_points * (1 + .data$market_context_pct)),
      baseline_p90_points = pmax(0, .data$baseline_p90_points * (1 + .data$market_context_pct))
    ) |>
    dplyr::ungroup()

  out <- sos_enforce_projection_ranges(
    out,
    c(
      "baseline_p10_points", "baseline_p25_points", "baseline_p50_points",
      "baseline_p75_points", "baseline_p90_points"
    )
  )
  out |>
    dplyr::group_by(.data$position) |>
    dplyr::mutate(
      baseline_average_range_score = (
        .data$baseline_p25_points + .data$baseline_p50_points + .data$baseline_p75_points
      ) / 3,
      baseline_projection_rank = rank(
        -.data$baseline_average_range_score,
        ties.method = "first",
        na.last = "keep"
      )
    ) |>
    dplyr::ungroup()
}

build_core_sos_rank_signal_coherence_audit <- function(
    rankings,
    prediction_season = 2026L,
    min_rank_gap = 2,
    min_omfg_margin = 1,
    min_projection_margin = 5,
    output_dir = sos_production_output_dir(),
    write_output = TRUE
) {
  if (is.null(rankings) || nrow(rankings) == 0L) {
    return(list(detail = data.frame(), summary = data.frame()))
  }
  ranked <- rankings |>
    dplyr::filter(
      .data$prediction_season == as.integer(prediction_season[[1]]),
      is.finite(.data$final_value_rank),
      is.finite(.data$official_omfg),
      is.finite(.data$adjusted_p50_points)
    )
  detail_parts <- list()
  part_index <- 0L
  for (pos in unique(ranked$position)) {
    position_rows <- ranked[ranked$position == pos, , drop = FALSE]
    position_rows <- position_rows[order(position_rows$final_value_rank), , drop = FALSE]
    if (nrow(position_rows) < 2L) next
    manual_rank <- if ("manual_rank" %in% names(position_rows)) {
      sos_prob_num(position_rows$manual_rank)
    } else rep(NA_real_, nrow(position_rows))
    adp_rank <- if ("market_position_rank" %in% names(position_rows)) {
      sos_prob_num(position_rows$market_position_rank)
    } else rep(NA_real_, nrow(position_rows))
    for (behind_index in seq_len(nrow(position_rows))) {
      ahead_index <- which(
        position_rows$final_value_rank < position_rows$final_value_rank[[behind_index]] &
          position_rows$official_omfg <=
            position_rows$official_omfg[[behind_index]] - min_omfg_margin &
          position_rows$adjusted_p50_points <=
            position_rows$adjusted_p50_points[[behind_index]] - min_projection_margin &
          position_rows$final_value_rank[[behind_index]] - position_rows$final_value_rank >= min_rank_gap
      )
      if (length(ahead_index) == 0L) next
      for (ahead in ahead_index) {
        manual_support <- is.finite(manual_rank[[ahead]]) &&
          is.finite(manual_rank[[behind_index]]) &&
          manual_rank[[ahead]] < manual_rank[[behind_index]]
        adp_support <- is.finite(adp_rank[[ahead]]) &&
          is.finite(adp_rank[[behind_index]]) &&
          adp_rank[[ahead]] < adp_rank[[behind_index]]
        rank_gap <- position_rows$final_value_rank[[behind_index]] -
          position_rows$final_value_rank[[ahead]]
        omfg_margin <- position_rows$official_omfg[[behind_index]] -
          position_rows$official_omfg[[ahead]]
        projection_margin <- position_rows$adjusted_p50_points[[behind_index]] -
          position_rows$adjusted_p50_points[[ahead]]
        part_index <- part_index + 1L
        detail_parts[[part_index]] <- data.frame(
          position = pos,
          prediction_season = as.integer(prediction_season[[1]]),
          ahead_rank = position_rows$final_value_rank[[ahead]],
          ahead_player = position_rows$player[[ahead]],
          ahead_omfg = position_rows$official_omfg[[ahead]],
          ahead_p50 = position_rows$adjusted_p50_points[[ahead]],
          ahead_manual_rank = manual_rank[[ahead]],
          ahead_adp_rank = adp_rank[[ahead]],
          behind_rank = position_rows$final_value_rank[[behind_index]],
          behind_player = position_rows$player[[behind_index]],
          behind_omfg = position_rows$official_omfg[[behind_index]],
          behind_p50 = position_rows$adjusted_p50_points[[behind_index]],
          behind_manual_rank = manual_rank[[behind_index]],
          behind_adp_rank = adp_rank[[behind_index]],
          rank_gap = rank_gap,
          omfg_margin = omfg_margin,
          projection_margin = projection_margin,
          manual_rank_supports_ahead = manual_support,
          adp_rank_supports_ahead = adp_support,
          coherence_status = if (
            rank_gap >= 8 && omfg_margin >= 5 && projection_margin >= 20 &&
              !manual_support && !adp_support
          ) "material_unexplained" else if (manual_support || adp_support) {
            "explained_by_manual_or_adp"
          } else "minor_unexplained",
          stringsAsFactors = FALSE
        )
      }
    }
  }
  detail <- if (length(detail_parts) > 0L) {
    dplyr::bind_rows(detail_parts) |>
      dplyr::arrange(
        factor(.data$position, levels = c("QB", "RB", "WR", "TE", "K", "DST")),
        dplyr::desc(.data$rank_gap), dplyr::desc(.data$projection_margin)
      )
  } else data.frame()
  summary <- if (nrow(detail) > 0L) {
    detail |>
      dplyr::group_by(.data$position, .data$coherence_status) |>
      dplyr::summarise(
        pairs = dplyr::n(),
        affected_lower_ranked_players = dplyr::n_distinct(.data$behind_player),
        max_rank_gap = max(.data$rank_gap, na.rm = TRUE),
        max_omfg_margin = max(.data$omfg_margin, na.rm = TRUE),
        max_projection_margin = max(.data$projection_margin, na.rm = TRUE),
        .groups = "drop"
      )
  } else data.frame(
    position = character(), coherence_status = character(), pairs = integer(),
    affected_lower_ranked_players = integer(), max_rank_gap = numeric(),
    max_omfg_margin = numeric(), max_projection_margin = numeric()
  )
  if (isTRUE(write_output)) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    sos_try_write_csv(
      detail,
      file.path(output_dir, paste0("core_sos_rank_signal_coherence_detail_", prediction_season, ".csv"))
    )
    sos_try_write_csv(
      summary,
      file.path(output_dir, paste0("core_sos_rank_signal_coherence_summary_", prediction_season, ".csv"))
    )
  }
  out <- list(detail = detail, summary = summary)
  assign("core_sos_rank_signal_coherence", out, envir = .GlobalEnv)
  out
}

sos_k_starter_depth_chart_2026 <- function() {
  data.frame(
    team = c(
      "ARI", "ATL", "BAL", "BUF", "CAR", "CHI", "CIN", "CLE",
      "DAL", "DEN", "DET", "GB", "HOU", "IND", "JAX", "KC",
      "LAC", "LAR", "LV", "MIA", "MIN", "NE", "NO", "NYG",
      "NYJ", "PHI", "PIT", "SEA", "SF", "TB", "TEN", "WAS"
    ),
    player = c(
      "Chad Ryland", "Nick Folk", "Tyler Loop", "Tyler Bass",
      "Ryan Fitzgerald", "Cairo Santos", "Evan McPherson", "Andre Szmyt",
      "Brandon Aubrey", "Wil Lutz", "Jake Bates", "Trey Smack",
      "Ka'imi Fairbairn", "Blake Grupe", "Cam Little", "Harrison Butker",
      "Cameron Dicker", "Harrison Mevis", "Kansei Matsuzawa", "Zane Gonzalez",
      "Will Reichard", "Andres Borregales", "Charlie Smyth", "Ben Sauls",
      "Jason Sanders", "Jake Elliott", "Chris Boswell", "Jason Myers",
      "Eddy Pineiro", "Chase McLaughlin", "Joey Slye", "Jake Moody"
    ),
    starter_source = c(
      rep("ourlads_2026_depth_chart", 13),
      "colts_official_2026_depth_chart",
      rep("ourlads_2026_depth_chart", 4),
      "manual_post_depth_chart_override",
      rep("ourlads_2026_depth_chart", 13)
    ),
    stringsAsFactors = FALSE
  ) |>
    dplyr::mutate(player_key = make_player_key(.data$player))
}

sos_apply_k_starter_depth_chart <- function(board, prediction_season = 2026L) {
  load_model_core_packages()
  if (is.null(board) || nrow(board) == 0L) {
    return(list(board = board, audit = data.frame(), missing_starters = data.frame()))
  }
  out <- board
  out$k_confirmed_starter <- FALSE
  out$k_starter_team <- NA_character_
  out$k_starter_depth_source <- NA_character_
  out$k_removed_inactive_override <- FALSE
  if (as.integer(prediction_season[[1]]) != 2026L) {
    return(list(board = out, audit = data.frame(), missing_starters = data.frame()))
  }

  starters <- sos_k_starter_depth_chart_2026()
  remove_key <- make_player_key("Matt Gay")
  remove_rows <- toupper(as.character(out$position)) == "K" &
    as.character(out$player_key) == remove_key
  removed_rows <- sum(remove_rows, na.rm = TRUE)
  out <- out[!remove_rows, , drop = FALSE]

  starter_match <- match(as.character(out$player_key), starters$player_key)
  confirmed <- toupper(as.character(out$position)) == "K" & !is.na(starter_match)
  out$k_confirmed_starter[confirmed] <- TRUE
  out$k_starter_team[confirmed] <- starters$team[starter_match[confirmed]]
  out$k_starter_depth_source[confirmed] <- starters$starter_source[starter_match[confirmed]]
  for (team_col in intersect(
    c("current_team", "next_team", "team", "depth_chart_team_2026"),
    names(out)
  )) {
    out[[team_col]][confirmed] <- out$k_starter_team[confirmed]
  }
  if ("depth_team_2026" %in% names(out)) out$depth_team_2026[confirmed] <- 1
  if ("roster_context_source" %in% names(out)) {
    out$roster_context_source[confirmed] <- out$k_starter_depth_source[confirmed]
  }

  found_keys <- unique(as.character(out$player_key[confirmed]))
  missing_starters <- starters |>
    dplyr::filter(!.data$player_key %in% found_keys)
  audit <- data.frame(
    position = "K",
    prediction_season = as.integer(prediction_season[[1]]),
    starter_teams_expected = nrow(starters),
    starters_found = length(found_keys),
    missing_starters = nrow(missing_starters),
    duplicate_starter_teams = sum(duplicated(starters$team)),
    matt_gay_rows_removed = removed_rows,
    matt_gay_rows_remaining = sum(
      toupper(as.character(out$position)) == "K" &
        as.character(out$player_key) == remove_key,
      na.rm = TRUE
    ),
    status = if (
      length(found_keys) == 32L && nrow(missing_starters) == 0L &&
        !anyDuplicated(starters$team) &&
        !any(
          toupper(as.character(out$position)) == "K" &
            as.character(out$player_key) == remove_key,
          na.rm = TRUE
        )
    ) "PASS" else "FAIL",
    stringsAsFactors = FALSE
  )
  list(board = out, audit = audit, missing_starters = missing_starters)
}

build_core_sos_market_rank_review <- function(
    projection_board_path = file.path(sos_production_output_dir(), "core_sos_projection_board_2026.csv"),
    prediction_season = 2026L,
    market_path = sos_default_market_adp_path(prediction_season),
    manual_rank_blend_profile = "model_50_manual_30_adp_20",
    availability_guardrail_max_manual_rank_drop = 10L,
    output_dir = sos_production_output_dir(),
    write_output = TRUE
) {
  load_model_core_packages()
  prediction_season <- as.integer(prediction_season[[1]])
  manual_rank_blend_profile <- match.arg(
    as.character(manual_rank_blend_profile[[1]]),
    c("model_50_manual_30_adp_20", "model_55_manual_35_adp_10")
  )
  availability_guardrail_max_manual_rank_drop <- pmax(
    0L,
    as.integer(availability_guardrail_max_manual_rank_drop[[1]])
  )
  if (!file.exists(projection_board_path)) {
    stop("Missing SOS projection board: ", projection_board_path, call. = FALSE)
  }
  board <- utils::read.csv(projection_board_path, stringsAsFactors = FALSE, check.names = FALSE)
  if (!"manual_rank_has_input" %in% names(board)) board$manual_rank_has_input <- FALSE
  if (!"manual_rank" %in% names(board)) board$manual_rank <- NA_real_
  if (!"manual_rank_field_size" %in% names(board)) board$manual_rank_field_size <- NA_real_
  if (!"manual_rank_confidence" %in% names(board)) board$manual_rank_confidence <- NA_real_
  if (!"k_confirmed_starter" %in% names(board)) board$k_confirmed_starter <- FALSE
  if (!"k_starter_team" %in% names(board)) board$k_starter_team <- NA_character_
  if (!"k_starter_depth_source" %in% names(board)) board$k_starter_depth_source <- NA_character_
  market <- sos_parse_fantasypros_adp(market_path)
  board_for_market_review <- board |>
    dplyr::select(
      -dplyr::any_of(c(
        "market_source", "market_player", "market_team", "market_position",
        "market_position_rank", "market_overall_rank", "market_avg_adp",
        "market_yahoo_rank", "market_sleeper_rank", "market_rtsports_rank",
        "market_realtime_rank", "has_market_rank"
      ))
    )
  review <- board_for_market_review |>
    dplyr::left_join(
      market |>
        dplyr::select(
          "player_key", "market_source", "market_player", "market_team",
          "market_position", "market_position_rank", "market_overall_rank",
          "market_avg_adp", "market_yahoo_rank", "market_sleeper_rank",
          "market_rtsports_rank", "market_realtime_rank"
        ),
      by = "player_key",
      relationship = "many-to-one"
    ) |>
    dplyr::group_by(.data$position) |>
    dplyr::mutate(
      has_market_rank = !is.na(.data$market_position_rank) &
        .data$market_position == .data$position,
      market_position_rank = dplyr::if_else(.data$has_market_rank, .data$market_position_rank, NA_integer_),
      market_overall_rank = dplyr::if_else(.data$has_market_rank, .data$market_overall_rank, NA_real_),
      market_avg_adp = dplyr::if_else(.data$has_market_rank, .data$market_avg_adp, NA_real_),
      market_projection_rank_gap = .data$manual_adjusted_projection_rank - .data$market_position_rank,
      market_model_rank_gap = .data$manual_adjusted_model_rank - .data$market_position_rank,
      market_gap_abs = abs(.data$market_projection_rank_gap),
      market_gap_bucket = dplyr::case_when(
        is.na(.data$market_position_rank) ~ "no_market_rank",
        .data$market_gap_abs >= 20 ~ "major_20_plus",
        .data$market_gap_abs >= 12 ~ "large_12_to_19",
        .data$market_gap_abs >= 6 ~ "watch_6_to_11",
        TRUE ~ "aligned"
      ),
      market_flag = dplyr::case_when(
        is.na(.data$market_position_rank) ~ "no_market_rank",
        .data$market_projection_rank_gap <= -12 ~ "model_much_higher_than_market",
        .data$market_projection_rank_gap >= 12 ~ "market_much_higher_than_model",
        TRUE ~ "within_range"
      ),
      position_field_size = dplyr::n(),
      model_rank_score_0to100 = sos_prob_rank_score(.data$manual_adjusted_model_rank, .data$position_field_size),
      projection_rank_score_0to100 = sos_prob_rank_score(.data$manual_adjusted_projection_rank, .data$position_field_size),
      market_rank_score_0to100 = dplyr::if_else(
        .data$has_market_rank,
        sos_prob_rank_score(.data$market_position_rank, .data$position_field_size),
        NA_real_
      ),
      manual_rank_has_input = dplyr::coalesce(as.logical(.data$manual_rank_has_input), FALSE) &
        is.finite(.data$manual_rank) & .data$manual_rank > 0,
      manual_rank_score_0to100 = dplyr::if_else(
        .data$manual_rank_has_input,
        sos_prob_rank_score(.data$manual_rank, pmax(2, .data$manual_rank_field_size)),
        NA_real_
      ),
      blend_50_model_rank_weight = dplyr::if_else(.data$manual_rank_has_input, 0.30, 0),
      blend_50_projection_rank_weight = dplyr::if_else(.data$manual_rank_has_input, 0.20, 0),
      blend_50_manual_rank_weight = dplyr::if_else(.data$manual_rank_has_input, 0.30, 0),
      blend_50_adp_rank_weight = dplyr::if_else(
        .data$manual_rank_has_input & .data$has_market_rank,
        0.20,
        0
      ),
      blend_50_weight_total = .data$blend_50_model_rank_weight +
        .data$blend_50_projection_rank_weight + .data$blend_50_manual_rank_weight +
        .data$blend_50_adp_rank_weight,
      blend_score_model_50_manual_30_adp_20_before_cap =
        dplyr::if_else(
          .data$manual_rank_has_input,
          (
            .data$blend_50_model_rank_weight * .data$model_rank_score_0to100 +
              .data$blend_50_projection_rank_weight * .data$projection_rank_score_0to100 +
              .data$blend_50_manual_rank_weight * .data$manual_rank_score_0to100 +
              .data$blend_50_adp_rank_weight * dplyr::coalesce(
                .data$market_rank_score_0to100,
                .data$projection_rank_score_0to100
              )
          ) / pmax(.data$blend_50_weight_total, 1e-6),
          NA_real_
        ),
      blend_55_model_rank_weight = dplyr::if_else(.data$manual_rank_has_input, 0.33, 0),
      blend_55_projection_rank_weight = dplyr::if_else(.data$manual_rank_has_input, 0.22, 0),
      blend_55_manual_rank_weight = dplyr::if_else(.data$manual_rank_has_input, 0.35, 0),
      blend_55_adp_rank_weight = dplyr::if_else(
        .data$manual_rank_has_input & .data$has_market_rank,
        0.10,
        0
      ),
      blend_55_weight_total = .data$blend_55_model_rank_weight +
        .data$blend_55_projection_rank_weight + .data$blend_55_manual_rank_weight +
        .data$blend_55_adp_rank_weight,
      blend_score_model_55_manual_35_adp_10_before_cap =
        dplyr::if_else(
          .data$manual_rank_has_input,
          (
            .data$blend_55_model_rank_weight * .data$model_rank_score_0to100 +
              .data$blend_55_projection_rank_weight * .data$projection_rank_score_0to100 +
              .data$blend_55_manual_rank_weight * .data$manual_rank_score_0to100 +
              .data$blend_55_adp_rank_weight * dplyr::coalesce(
                .data$market_rank_score_0to100,
                .data$projection_rank_score_0to100
              )
          ) / pmax(.data$blend_55_weight_total, 1e-6),
          NA_real_
        ),
      market_blend_score_45_model_35_projection_20_market = dplyr::if_else(
        .data$has_market_rank,
        0.45 * .data$model_rank_score_0to100 +
          0.35 * .data$projection_rank_score_0to100 +
          0.20 * .data$market_rank_score_0to100,
        NA_real_
      ),
      projection_market_agreement_abs = dplyr::if_else(
        .data$has_market_rank,
        abs(.data$manual_adjusted_projection_rank - .data$market_position_rank),
        NA_real_
      ),
      model_projection_disagreement_abs =
        abs(.data$manual_adjusted_model_rank - .data$manual_adjusted_projection_rank),
      market_consensus_override_applied =
        .data$has_market_rank &
          .data$projection_market_agreement_abs <= 8 &
          .data$model_projection_disagreement_abs >= 8,
      market_consensus_score_15_model_55_projection_30_market = dplyr::if_else(
        .data$has_market_rank,
        0.15 * .data$model_rank_score_0to100 +
          0.55 * .data$projection_rank_score_0to100 +
          0.30 * .data$market_rank_score_0to100,
        NA_real_
      ),
      fallback_blend_score_all_players = dplyr::if_else(
        .data$manual_rank_has_input,
        NA_real_,
        dplyr::if_else(
          .data$has_market_rank & .data$market_consensus_override_applied,
          .data$market_consensus_score_15_model_55_projection_30_market,
          dplyr::if_else(
            .data$has_market_rank,
            .data$market_blend_score_45_model_35_projection_20_market,
            (0.45 * .data$model_rank_score_0to100 +
              0.35 * .data$projection_rank_score_0to100) / 0.80
          )
        )
      ),
      selected_blend_profile = .env$manual_rank_blend_profile,
      market_blend_score_before_availability_cap = dplyr::case_when(
        .data$manual_rank_has_input &
          .env$manual_rank_blend_profile == "model_50_manual_30_adp_20" ~
          .data$blend_score_model_50_manual_30_adp_20_before_cap,
        .data$manual_rank_has_input &
          .env$manual_rank_blend_profile == "model_55_manual_35_adp_10" ~
          .data$blend_score_model_55_manual_35_adp_10_before_cap,
        TRUE ~ .data$fallback_blend_score_all_players
      ),
      context_availability_score_cap_raw = dplyr::case_when(
        .data$adjusted_projected_games <= 2 |
          .data$adjusted_p50_points <= 10 ~ pmin(.data$projection_rank_score_0to100, 5),
        .data$adjusted_projected_games <= 5 |
          .data$adjusted_p50_points <= 25 ~ pmin(.data$projection_rank_score_0to100 + 3, 20),
        .data$adjusted_projected_games <= 8 |
          .data$adjusted_p50_points <= 45 ~ pmin(.data$projection_rank_score_0to100 + 6, 35),
        TRUE ~ 100
      ),
      availability_guardrail_max_rank = dplyr::if_else(
        .data$manual_rank_has_input,
        pmin(
          .data$position_field_size,
          .data$manual_rank + .env$availability_guardrail_max_manual_rank_drop
        ),
        NA_real_
      ),
      availability_guardrail_score_floor = dplyr::if_else(
        .data$manual_rank_has_input,
        sos_prob_rank_score(
          .data$availability_guardrail_max_rank,
          .data$position_field_size
        ),
        0
      ),
      context_availability_score_cap = dplyr::if_else(
        .data$manual_rank_has_input,
        pmax(
          .data$context_availability_score_cap_raw,
          .data$availability_guardrail_score_floor
        ),
        .data$context_availability_score_cap_raw
      ),
      availability_guardrail_applied = .data$manual_rank_has_input &
        .data$context_availability_score_cap_raw < .data$availability_guardrail_score_floor,
      blend_score_model_50_manual_30_adp_20 = pmin(
        .data$blend_score_model_50_manual_30_adp_20_before_cap,
        .data$context_availability_score_cap
      ),
      blend_score_model_55_manual_35_adp_10 = pmin(
        .data$blend_score_model_55_manual_35_adp_10_before_cap,
        .data$context_availability_score_cap
      ),
      market_blend_score_all_players = pmin(
        .data$market_blend_score_before_availability_cap,
        .data$context_availability_score_cap
      ),
      availability_cap_applied =
        .data$context_availability_score_cap < .data$market_blend_score_before_availability_cap
    ) |>
    dplyr::ungroup() |>
    dplyr::group_by(.data$position) |>
    dplyr::mutate(
      qb_final_review_rank_guardrail_target = dplyr::if_else(
        .data$position == "QB" &
          .data$player_key == make_player_key("Kirk Cousins") &
          .data$prediction_season == 2026L,
        32L,
        NA_integer_
      ),
      qb_final_review_rank_guardrail_score_floor = dplyr::if_else(
        is.finite(.data$qb_final_review_rank_guardrail_target),
        dplyr::nth(
          sort(.data$market_blend_score_all_players, decreasing = TRUE),
          n = pmin(32L, dplyr::n()),
          default = -Inf
        ) + 1e-6,
        NA_real_
      ),
      qb_final_review_rank_guardrail_applied =
        is.finite(.data$qb_final_review_rank_guardrail_score_floor) &
          .data$market_blend_score_all_players <
            .data$qb_final_review_rank_guardrail_score_floor,
      market_blend_score_all_players = dplyr::if_else(
        .data$qb_final_review_rank_guardrail_applied,
        .data$qb_final_review_rank_guardrail_score_floor,
        .data$market_blend_score_all_players
      ),
      rb_final_review_rank_floor_target = dplyr::case_when(
        .data$position == "RB" & .data$prediction_season == 2026L &
          .data$player_key == make_player_key("Kenneth Walker") ~ 15L,
        .data$position == "RB" & .data$prediction_season == 2026L &
          .data$player_key == make_player_key("Bhayshul Tuten") ~ 20L,
        .data$position == "RB" & .data$prediction_season == 2026L &
          .data$player_key == make_player_key("David Montgomery") ~ 23L,
        .data$position == "RB" & .data$prediction_season == 2026L &
          .data$player_key == make_player_key("Jonathon Brooks") ~ 36L,
        .data$position == "RB" & .data$prediction_season == 2026L &
          .data$player_key == make_player_key("Blake Corum") ~ 40L,
        TRUE ~ NA_integer_
      ),
      rb_final_review_rank_score_floor = sos_rank_guardrail_score(
        .data$market_blend_score_all_players,
        .data$rb_final_review_rank_floor_target,
        offset = 1e-6
      ),
      rb_final_review_rank_floor_applied =
        is.finite(.data$rb_final_review_rank_score_floor) &
          .data$market_blend_score_all_players < .data$rb_final_review_rank_score_floor,
      market_blend_score_all_players = dplyr::if_else(
        .data$rb_final_review_rank_floor_applied,
        .data$rb_final_review_rank_score_floor,
        .data$market_blend_score_all_players
      ),
      wr_final_review_rank_floor_target = dplyr::case_when(
        .data$position == "WR" & .data$prediction_season == 2026L & .data$player_key == make_player_key("CeeDee Lamb") ~ 6L,
        .data$position == "WR" & .data$prediction_season == 2026L & .data$player_key == make_player_key("Rashee Rice") ~ 12L,
        .data$position == "WR" & .data$prediction_season == 2026L & .data$player_key == make_player_key("Ladd McConkey") ~ 12L,
        .data$position == "WR" & .data$prediction_season == 2026L & .data$player_key == make_player_key("Jaylen Waddle") ~ 13L,
        .data$position == "WR" & .data$prediction_season == 2026L & .data$player_key == make_player_key("Marvin Harrison") ~ 18L,
        .data$position == "WR" & .data$prediction_season == 2026L & .data$player_key == make_player_key("Rome Odunze") ~ 17L,
        .data$position == "WR" & .data$prediction_season == 2026L & .data$player_key == make_player_key("Christian Watson") ~ 18L,
        .data$position == "WR" & .data$prediction_season == 2026L & .data$player_key == make_player_key("Michael Pittman") ~ 22L,
        .data$position == "WR" & .data$prediction_season == 2026L & .data$player_key == make_player_key("Luther Burden") ~ 20L,
        .data$position == "WR" & .data$prediction_season == 2026L & .data$player_key == make_player_key("Malik Nabers") ~ 16L,
        .data$position == "WR" & .data$prediction_season == 2026L & .data$player_key == make_player_key("Mike Evans") ~ 30L,
        .data$position == "WR" & .data$prediction_season == 2026L & .data$player_key == make_player_key("DJ Moore") ~ 30L,
        .data$position == "WR" & .data$prediction_season == 2026L & .data$player_key == make_player_key("Parker Washington") ~ 36L,
        .data$position == "WR" & .data$prediction_season == 2026L & .data$player_key == make_player_key("Stefon Diggs") ~ 36L,
        .data$position == "WR" & .data$prediction_season == 2026L & .data$player_key == make_player_key("De'Zhaun Stribling") ~ 44L,
        .data$position == "WR" & .data$prediction_season == 2026L & .data$player_key == make_player_key("Dontayvion Wicks") ~ 45L,
        .data$position == "WR" & .data$prediction_season == 2026L & .data$player_key == make_player_key("Denzel Boston") ~ 55L,
        .data$position == "WR" & .data$prediction_season == 2026L & .data$player_key == make_player_key("Adonai Mitchell") ~ 56L,
        TRUE ~ NA_integer_
      ),
      wr_final_review_rank_score_floor = sos_rank_guardrail_score(
        .data$market_blend_score_all_players,
        .data$wr_final_review_rank_floor_target,
        offset = 1e-6
      ),
      wr_final_review_rank_floor_applied =
        is.finite(.data$wr_final_review_rank_score_floor) &
          .data$market_blend_score_all_players < .data$wr_final_review_rank_score_floor,
      market_blend_score_all_players = dplyr::if_else(
        .data$wr_final_review_rank_floor_applied,
        .data$wr_final_review_rank_score_floor,
        .data$market_blend_score_all_players
      ),
      te_final_review_rank_floor_target = dplyr::case_when(
        .data$position == "TE" & .data$prediction_season == 2026L &
          .data$player_key == make_player_key("Brock Bowers") ~ 1L,
        .data$position == "TE" & .data$prediction_season == 2026L &
          .data$player_key == make_player_key("Terrance Ferguson") ~ 30L,
        TRUE ~ NA_integer_
      ),
      te_final_review_rank_score_floor = sos_rank_guardrail_score(
        .data$market_blend_score_all_players,
        .data$te_final_review_rank_floor_target,
        offset = 1e-6
      ),
      te_final_review_rank_floor_applied =
        is.finite(.data$te_final_review_rank_score_floor) &
          .data$market_blend_score_all_players < .data$te_final_review_rank_score_floor,
      market_blend_score_all_players = dplyr::if_else(
        .data$te_final_review_rank_floor_applied,
        .data$te_final_review_rank_score_floor,
        .data$market_blend_score_all_players
      ),
      qb_final_review_rank_ceiling_target = dplyr::if_else(
        .data$position == "QB" &
          .data$player_key == make_player_key("Bo Nix") &
          .data$prediction_season == 2026L,
        13L,
        NA_integer_
      ),
      qb_final_review_rank_guardrail_score_ceiling = dplyr::if_else(
        is.finite(.data$qb_final_review_rank_ceiling_target),
        dplyr::nth(
          sort(.data$market_blend_score_all_players, decreasing = TRUE),
          n = pmin(13L, dplyr::n()),
          default = Inf
        ) - 1e-6,
        NA_real_
      ),
      qb_final_review_rank_ceiling_applied =
        is.finite(.data$qb_final_review_rank_guardrail_score_ceiling) &
          .data$market_blend_score_all_players >
            .data$qb_final_review_rank_guardrail_score_ceiling,
      market_blend_score_all_players = dplyr::if_else(
        .data$qb_final_review_rank_ceiling_applied,
        .data$qb_final_review_rank_guardrail_score_ceiling,
        .data$market_blend_score_all_players
      ),
      rb_final_review_rank_ceiling_target = dplyr::case_when(
        .data$position == "RB" & .data$prediction_season == 2026L &
          .data$player_key == make_player_key("Christian McCaffrey") ~ 8L,
        .data$position == "RB" & .data$prediction_season == 2026L &
          .data$player_key == make_player_key("De'Von Achane") ~ 12L,
        .data$position == "RB" & .data$prediction_season == 2026L &
          .data$player_key == make_player_key("Travis Etienne") ~ 20L,
        .data$position == "RB" & .data$prediction_season == 2026L &
          .data$player_key == make_player_key("Isaac Guerendo") ~ 120L,
        TRUE ~ NA_integer_
      ),
      rb_final_review_rank_score_ceiling = sos_rank_guardrail_score(
        .data$market_blend_score_all_players,
        .data$rb_final_review_rank_ceiling_target,
        offset = -1e-6
      ),
      rb_final_review_rank_ceiling_applied =
        is.finite(.data$rb_final_review_rank_score_ceiling) &
          .data$market_blend_score_all_players > .data$rb_final_review_rank_score_ceiling,
      market_blend_score_all_players = dplyr::if_else(
        .data$rb_final_review_rank_ceiling_applied,
        .data$rb_final_review_rank_score_ceiling,
        .data$market_blend_score_all_players
      ),
      wr_final_review_rank_ceiling_target = dplyr::case_when(
        .data$position == "WR" & .data$prediction_season == 2026L & .data$player_key == make_player_key("Jaxon Smith-Njigba") ~ 5L,
        .data$position == "WR" & .data$prediction_season == 2026L & .data$player_key == make_player_key("Courtland Sutton") ~ 30L,
        .data$position == "WR" & .data$prediction_season == 2026L & .data$player_key == make_player_key("DK Metcalf") ~ 30L,
        .data$position == "WR" & .data$prediction_season == 2026L & .data$player_key == make_player_key("Alec Pierce") ~ 45L,
        .data$position == "WR" & .data$prediction_season == 2026L & .data$player_key == make_player_key("Michael Wilson") ~ 50L,
        .data$position == "WR" & .data$prediction_season == 2026L & .data$player_key == make_player_key("Brian Thomas") ~ 35L,
        .data$position == "WR" & .data$prediction_season == 2026L & .data$player_key == make_player_key("Travis Hunter") ~ 80L,
        .data$position == "WR" & .data$prediction_season == 2026L & .data$player_key == make_player_key("Jordyn Tyson") ~ 85L,
        TRUE ~ NA_integer_
      ),
      wr_final_review_rank_score_ceiling = sos_rank_guardrail_score(
        .data$market_blend_score_all_players,
        .data$wr_final_review_rank_ceiling_target,
        offset = -1e-6
      ),
      wr_final_review_rank_ceiling_applied =
        is.finite(.data$wr_final_review_rank_score_ceiling) &
          .data$market_blend_score_all_players > .data$wr_final_review_rank_score_ceiling,
      market_blend_score_all_players = dplyr::if_else(
        .data$wr_final_review_rank_ceiling_applied,
        .data$wr_final_review_rank_score_ceiling,
        .data$market_blend_score_all_players
      ),
      te_final_review_rank_ceiling_target = dplyr::case_when(
        .data$position == "TE" & .data$prediction_season == 2026L &
          .data$player_key == make_player_key("George Kittle") ~ 6L,
        TRUE ~ NA_integer_
      ),
      te_final_review_rank_score_ceiling = sos_rank_guardrail_score(
        .data$market_blend_score_all_players,
        .data$te_final_review_rank_ceiling_target,
        offset = -1e-6
      ),
      te_final_review_rank_ceiling_applied =
        is.finite(.data$te_final_review_rank_score_ceiling) &
          .data$market_blend_score_all_players > .data$te_final_review_rank_score_ceiling,
      market_blend_score_all_players = dplyr::if_else(
        .data$te_final_review_rank_ceiling_applied,
        .data$te_final_review_rank_score_ceiling,
        .data$market_blend_score_all_players
      ),
      dst_final_review_rank_floor_target = dplyr::case_when(
        .data$position == "DST" & .data$prediction_season == 2026L &
          .data$player_key == make_player_key("Houston Texans") ~ 1L,
        .data$position == "DST" & .data$prediction_season == 2026L &
          .data$player_key == make_player_key("Los Angeles Rams") ~ 6L,
        TRUE ~ NA_integer_
      ),
      dst_final_review_rank_score_floor = sos_rank_guardrail_score(
        .data$market_blend_score_all_players,
        .data$dst_final_review_rank_floor_target,
        offset = 1e-6
      ),
      dst_final_review_rank_guardrail_applied =
        is.finite(.data$dst_final_review_rank_score_floor) &
          .data$market_blend_score_all_players < .data$dst_final_review_rank_score_floor,
      market_blend_score_all_players = dplyr::if_else(
        .data$dst_final_review_rank_guardrail_applied,
        .data$dst_final_review_rank_score_floor,
        .data$market_blend_score_all_players
      ),
      k_confirmed_starter = dplyr::coalesce(as.logical(.data$k_confirmed_starter), FALSE),
      k_starter_backup_score_ceiling = dplyr::if_else(
        .data$position == "K",
        suppressWarnings(max(
          .data$market_blend_score_all_players[!.data$k_confirmed_starter],
          na.rm = TRUE
        )),
        NA_real_
      ),
      k_starter_rank_guardrail_score_floor = dplyr::if_else(
        .data$position == "K" & .data$k_confirmed_starter &
          is.finite(.data$k_starter_backup_score_ceiling),
        pmin(
          100,
          .data$k_starter_backup_score_ceiling + 1e-4 +
            (pmax(1, .data$position_field_size) - dplyr::coalesce(
              .data$manual_rank,
              .data$manual_adjusted_projection_rank
            )) * 1e-8
        ),
        NA_real_
      ),
      k_starter_rank_guardrail_applied =
        is.finite(.data$k_starter_rank_guardrail_score_floor) &
          .data$market_blend_score_all_players <
            .data$k_starter_rank_guardrail_score_floor,
      market_blend_score_all_players = dplyr::if_else(
        .data$k_starter_rank_guardrail_applied,
        .data$k_starter_rank_guardrail_score_floor,
        .data$market_blend_score_all_players
      ),
      nfl_context_exact_rank_target = dplyr::case_when(
        .data$position == "RB" & .data$prediction_season == 2026L &
          .data$player_key == make_player_key("Najee Harris") ~ 76L,
        .data$position == "TE" & .data$prediction_season == 2026L &
          .data$player_key == make_player_key("Darren Waller") ~ 34L,
        TRUE ~ NA_integer_
      ),
      nfl_context_exact_rank_score = sos_exact_rank_score(
        .data$market_blend_score_all_players,
        .data$nfl_context_exact_rank_target
      ),
      nfl_context_exact_rank_applied = is.finite(.data$nfl_context_exact_rank_score),
      market_blend_score_all_players = dplyr::if_else(
        .data$nfl_context_exact_rank_applied,
        .data$nfl_context_exact_rank_score,
        .data$market_blend_score_all_players
      ),
      qb_final_review_rank_guardrail_applied =
        .data$qb_final_review_rank_guardrail_applied |
          .data$qb_final_review_rank_ceiling_applied,
      rb_final_review_rank_guardrail_applied =
        .data$rb_final_review_rank_floor_applied |
          .data$rb_final_review_rank_ceiling_applied,
      wr_final_review_rank_guardrail_applied =
        .data$wr_final_review_rank_floor_applied |
          .data$wr_final_review_rank_ceiling_applied,
      te_final_review_rank_guardrail_applied =
        .data$te_final_review_rank_floor_applied |
          .data$te_final_review_rank_ceiling_applied,
      market_blend_rank_matched_only = rank(
        -.data$market_blend_score_45_model_35_projection_20_market,
        ties.method = "first",
        na.last = "keep"
      ),
      blend_rank_model_50_manual_30_adp_20 = rank(
        -.data$blend_score_model_50_manual_30_adp_20,
        ties.method = "first",
        na.last = "keep"
      ),
      blend_rank_model_55_manual_35_adp_10 = rank(
        -.data$blend_score_model_55_manual_35_adp_10,
        ties.method = "first",
        na.last = "keep"
      ),
      market_blend_rank = rank(
        -.data$market_blend_score_all_players,
        ties.method = "first",
        na.last = "keep"
      )
    ) |>
    dplyr::ungroup() |>
    sos_enforce_exact_rank_targets(
      rank_col = "market_blend_rank",
      target_col = "nfl_context_exact_rank_target"
    ) |>
    dplyr::select(
      "position", "prediction_season", "player_key", "player", "current_team",
      "manual_adjusted_model_rank", "manual_adjusted_projection_rank",
      "market_position_rank", "market_blend_rank", "market_blend_rank_matched_only",
      "selected_blend_profile",
      "blend_rank_model_50_manual_30_adp_20",
      "blend_rank_model_55_manual_35_adp_10",
      "blend_score_model_50_manual_30_adp_20",
      "blend_score_model_55_manual_35_adp_10",
      "market_projection_rank_gap",
      "market_model_rank_gap", "market_gap_bucket", "market_flag",
      "official_omfg", "adjusted_projected_games", "adjusted_projected_ppg",
      "adjusted_p50_points", "context_adjustment_count", "manual_context_note",
      "market_overall_rank", "market_avg_adp", "market_player", "market_team",
      "market_source", "market_yahoo_rank", "market_sleeper_rank",
      "market_rtsports_rank", "market_realtime_rank",
      "model_rank_score_0to100", "projection_rank_score_0to100",
      "market_rank_score_0to100",
      "market_blend_score_45_model_35_projection_20_market",
      "projection_market_agreement_abs", "model_projection_disagreement_abs",
      "market_consensus_override_applied",
      "market_consensus_score_15_model_55_projection_30_market",
      "market_blend_score_before_availability_cap",
      "context_availability_score_cap",
      "availability_cap_applied",
      "market_blend_score_all_players",
      dplyr::everything()
    )

  summary <- review |>
    dplyr::group_by(.data$position) |>
    dplyr::summarise(
      board_rows = dplyr::n(),
      matched_market_rows = sum(.data$has_market_rank, na.rm = TRUE),
      match_rate = .data$matched_market_rows / .data$board_rows,
      major_market_gaps = sum(.data$market_gap_bucket == "major_20_plus", na.rm = TRUE),
      large_market_gaps = sum(.data$market_gap_bucket == "large_12_to_19", na.rm = TRUE),
      watch_market_gaps = sum(.data$market_gap_bucket == "watch_6_to_11", na.rm = TRUE),
      availability_guardrail_rows = sum(.data$availability_guardrail_applied, na.rm = TRUE),
      availability_cap_rows = sum(.data$availability_cap_applied, na.rm = TRUE),
      k_confirmed_starter_rows = sum(.data$k_confirmed_starter, na.rm = TRUE),
      k_starter_guardrail_rows = sum(.data$k_starter_rank_guardrail_applied, na.rm = TRUE),
      k_starters_outside_top32 = sum(
        .data$k_confirmed_starter & .data$market_blend_rank > 32,
        na.rm = TRUE
      ),
      dst_final_review_guardrail_rows = sum(
        .data$dst_final_review_rank_guardrail_applied,
        na.rm = TRUE
      ),
      houston_dst_rank = suppressWarnings(min(
        .data$market_blend_rank[
          .data$position == "DST" &
            .data$player_key == make_player_key("Houston Texans")
        ],
        na.rm = TRUE
      )),
      rams_dst_rank = suppressWarnings(min(
        .data$market_blend_rank[
          .data$position == "DST" &
            .data$player_key == make_player_key("Los Angeles Rams")
        ],
        na.rm = TRUE
      )),
      .groups = "drop"
    )

  blend_profile_comparison <- review |>
    dplyr::transmute(
      position = .data$position,
      prediction_season = .data$prediction_season,
      player_key = .data$player_key,
      player = .data$player,
      current_team = .data$current_team,
      selected_blend_profile = .data$selected_blend_profile,
      model_rank = .data$manual_adjusted_model_rank,
      projection_rank = .data$manual_adjusted_projection_rank,
      manual_rank = .data$manual_rank,
      adp_rank = .data$market_position_rank,
      rank_model_50_manual_30_adp_20 = .data$blend_rank_model_50_manual_30_adp_20,
      rank_model_55_manual_35_adp_10 = .data$blend_rank_model_55_manual_35_adp_10,
      rank_delta_50_minus_55 =
        .data$blend_rank_model_50_manual_30_adp_20 -
        .data$blend_rank_model_55_manual_35_adp_10,
      abs_rank_delta = abs(.data$rank_delta_50_minus_55),
      score_model_50_manual_30_adp_20 = .data$blend_score_model_50_manual_30_adp_20,
      score_model_55_manual_35_adp_10 = .data$blend_score_model_55_manual_35_adp_10,
      context_availability_score_cap_raw = .data$context_availability_score_cap_raw,
      availability_guardrail_max_rank = .data$availability_guardrail_max_rank,
      availability_guardrail_score_floor = .data$availability_guardrail_score_floor,
      availability_guardrail_applied = .data$availability_guardrail_applied,
      availability_cap_applied = .data$availability_cap_applied
    ) |>
    dplyr::arrange(
      factor(.data$position, levels = c("QB", "RB", "WR", "TE", "K", "DST")),
      dplyr::desc(.data$abs_rank_delta),
      .data$rank_model_50_manual_30_adp_20
    )

  blend_profile_summary <- blend_profile_comparison |>
    dplyr::group_by(.data$position) |>
    dplyr::summarise(
      prediction_season = dplyr::first(.data$prediction_season),
      selected_blend_profile = dplyr::first(.data$selected_blend_profile),
      rows = dplyr::n(),
      rows_with_adp = sum(is.finite(.data$adp_rank)),
      avg_abs_rank_delta = mean(.data$abs_rank_delta, na.rm = TRUE),
      median_abs_rank_delta = stats::median(.data$abs_rank_delta, na.rm = TRUE),
      max_abs_rank_delta = max(.data$abs_rank_delta, na.rm = TRUE),
      rows_moving_3_plus = sum(.data$abs_rank_delta >= 3, na.rm = TRUE),
      rows_moving_6_plus = sum(.data$abs_rank_delta >= 6, na.rm = TRUE),
      .groups = "drop"
    )

  final_value <- review |>
    dplyr::mutate(
      final_value_rank = .data$market_blend_rank,
      final_value_score = .data$market_blend_score_all_players,
      display_rank = .data$final_value_rank,
      display_score = .data$final_value_score,
      display_rank_source = dplyr::if_else(
        .data$manual_rank_has_input,
        "final_value_rank_manual_blend",
        "final_value_rank_market_blend"
      ),
      final_value_rank_source = dplyr::case_when(
        .data$manual_rank_has_input & .data$has_market_rank ~ "omfg_projection_manual_adp_blend",
        .data$manual_rank_has_input ~ "omfg_projection_manual_blend",
        .data$has_market_rank ~ "omfg_projection_adp_blend",
        TRUE ~ "omfg_projection_fallback"
      ),
      final_value_rank_delta_vs_projection =
        .data$manual_adjusted_projection_rank - .data$final_value_rank,
      final_value_rank_delta_vs_model =
        .data$manual_adjusted_model_rank - .data$final_value_rank,
      final_value_rank_delta_vs_market =
        .data$market_position_rank - .data$final_value_rank
    ) |>
    dplyr::arrange(.data$position, .data$final_value_rank) |>
    dplyr::select(
      "position", "prediction_season", "display_rank", "display_score",
      "display_rank_source", "final_value_rank", "final_value_score",
      "final_value_rank_source", "player_key", "player", "current_team",
      "manual_adjusted_model_rank", "manual_adjusted_projection_rank",
      "market_position_rank", "market_blend_rank",
      "availability_cap_applied",
      "final_value_rank_delta_vs_projection",
      "final_value_rank_delta_vs_model",
      "final_value_rank_delta_vs_market",
      "market_projection_rank_gap", "market_flag", "market_gap_bucket",
      "official_omfg", "adjusted_projected_games", "adjusted_projected_ppg",
      "adjusted_p50_points", "adjusted_p10_points", "adjusted_p25_points",
      "adjusted_p75_points", "adjusted_p90_points",
      "context_adjustment_count", "manual_context_note",
      "market_overall_rank", "market_avg_adp", "market_player", "market_team",
      dplyr::starts_with("adjusted_sim_prob_"),
      dplyr::starts_with("prob_"),
      dplyr::starts_with("projected_"),
      dplyr::everything()
    )

  rank_signal_coherence <- build_core_sos_rank_signal_coherence_audit(
    final_value,
    prediction_season = prediction_season,
    output_dir = output_dir,
    write_output = write_output
  )

  if (isTRUE(write_output)) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    sos_try_write_csv(
      review,
      file.path(output_dir, paste0("core_sos_market_rank_review_", prediction_season, ".csv"))
    )
    sos_try_write_csv(
      summary,
      file.path(output_dir, paste0("core_sos_market_rank_review_summary_", prediction_season, ".csv"))
    )
    sos_try_write_csv(
      final_value,
      file.path(output_dir, paste0("core_sos_final_value_rankings_", prediction_season, ".csv"))
    )
    sos_try_write_csv(
      review |>
        dplyr::arrange(.data$position, .data$market_blend_rank),
      file.path(output_dir, paste0("core_sos_market_blend_rank_board_", prediction_season, ".csv"))
    )
    sos_try_write_csv(
      blend_profile_comparison,
      file.path(output_dir, paste0("core_sos_manual_rank_blend_profile_comparison_", prediction_season, ".csv"))
    )
    sos_try_write_csv(
      blend_profile_summary,
      file.path(output_dir, paste0("core_sos_manual_rank_blend_profile_summary_", prediction_season, ".csv"))
    )
  }
  out <- list(
    review = review,
    summary = summary,
    market = market,
    final_value = final_value,
    rank_signal_coherence = rank_signal_coherence,
    blend_profile_comparison = blend_profile_comparison,
    blend_profile_summary = blend_profile_summary,
    selected_blend_profile = manual_rank_blend_profile
  )
  assign("core_sos_market_rank_review", out, envir = .GlobalEnv)
  assign("core_sos_final_value_rankings", final_value, envir = .GlobalEnv)
  invisible(out)
}

build_core_sos_calibrated_rankings <- function(
    market_review = get0("core_sos_market_rank_review", envir = .GlobalEnv),
    prediction_season = 2026L,
    output_dir = sos_production_output_dir(),
    write_output = TRUE
) {
  load_model_core_packages()
  prediction_season <- as.integer(prediction_season[[1]])
  if (is.null(market_review) || is.null(market_review$final_value)) {
    market_review <- build_core_sos_market_rank_review(
      prediction_season = prediction_season,
      write_output = write_output
    )
  }
  final_value <- market_review$final_value
  required <- c(
    "position", "prediction_season", "player_key", "player", "current_team",
    "final_value_rank", "final_value_score", "manual_adjusted_model_rank",
    "manual_adjusted_projection_rank", "market_position_rank",
    "market_projection_rank_gap", "official_omfg", "context_adjustment_count"
  )
  missing <- setdiff(required, names(final_value))
  if (length(missing) > 0L) {
    stop("Final value rankings are missing columns: ", paste(missing, collapse = ", "), call. = FALSE)
  }

  calibrated <- final_value |>
    dplyr::group_by(.data$position) |>
    dplyr::mutate(
      position_field_size = dplyr::n(),
      omfg_projection_gap = .data$manual_adjusted_projection_rank - .data$manual_adjusted_model_rank,
      omfg_market_gap = .data$market_position_rank - .data$manual_adjusted_model_rank,
      projection_market_gap = .data$market_position_rank - .data$manual_adjusted_projection_rank,
      has_market_rank = !is.na(.data$market_position_rank),
      signal_agreement_count =
        as.integer(abs(.data$manual_adjusted_model_rank - .data$final_value_rank) <= 6) +
        as.integer(abs(.data$manual_adjusted_projection_rank - .data$final_value_rank) <= 6) +
        as.integer(.data$has_market_rank & abs(.data$market_position_rank - .data$final_value_rank) <= 6),
      projection_instability =
        abs(.data$manual_adjusted_projection_rank - .data$manual_adjusted_model_rank) +
        dplyr::if_else(.data$has_market_rank, abs(.data$manual_adjusted_projection_rank - .data$market_position_rank), 0),
      context_weight = pmin(1, pmax(0, .data$context_adjustment_count / 3)),
      omfg_anchor_pull = dplyr::case_when(
        abs(.data$manual_adjusted_model_rank - .data$final_value_rank) <= 4 ~ 0,
        .data$signal_agreement_count >= 2 ~ 0,
        .data$context_weight >= 0.67 ~ 0,
        TRUE ~ (.data$manual_adjusted_model_rank - .data$final_value_rank) * 0.18
      ),
      projection_softener = dplyr::case_when(
        abs(.data$manual_adjusted_projection_rank - .data$final_value_rank) <= 4 ~ 0,
        .data$projection_instability >= 24 ~ (.data$manual_adjusted_projection_rank - .data$final_value_rank) * -0.08,
        TRUE ~ 0
      ),
      market_softener = dplyr::case_when(
        !.data$has_market_rank ~ 0,
        abs(.data$market_projection_rank_gap) < 12 ~ 0,
        .data$signal_agreement_count >= 2 ~ 0,
        TRUE ~ (.data$market_position_rank - .data$final_value_rank) * 0.08
      ),
      raw_calibrated_rank = .data$final_value_rank +
        .data$omfg_anchor_pull +
        .data$projection_softener +
        .data$market_softener,
      max_rank_move = dplyr::case_when(
        .data$signal_agreement_count >= 2 ~ 2,
        .data$context_weight >= 0.67 ~ 2,
        .data$has_market_rank & abs(.data$market_projection_rank_gap) >= 20 ~ 4,
        TRUE ~ 3
      ),
      calibrated_rank_position = pmin(
        .data$position_field_size,
        pmax(
          1,
          .data$final_value_rank +
            pmin(.data$max_rank_move, pmax(-.data$max_rank_move, .data$raw_calibrated_rank - .data$final_value_rank))
        )
      ),
      calibrated_score = 100 - 100 * ((.data$calibrated_rank_position - 1) / pmax(1, .data$position_field_size - 1)),
      rank_confidence = pmin(
        1,
        pmax(
          0,
          0.35 +
            0.15 * .data$signal_agreement_count +
            0.15 * as.integer(.data$context_adjustment_count > 0) +
            0.10 * as.integer(.data$has_market_rank) -
            0.01 * pmin(30, .data$projection_instability)
        )
      ),
      calibration_reason = dplyr::case_when(
        abs(.data$calibrated_rank_position - .data$final_value_rank) < 0.50 ~ "kept_final_value_rank",
        .data$omfg_anchor_pull != 0 ~ "soft_omfg_anchor_pull",
        .data$market_softener != 0 ~ "soft_market_gap_adjustment",
        .data$projection_softener != 0 ~ "projection_instability_softener",
        TRUE ~ "minor_rank_calibration"
      ),
      needs_manual_review = dplyr::case_when(
        .data$has_market_rank & abs(.data$market_projection_rank_gap) >= 20 ~ TRUE,
        abs(.data$manual_adjusted_projection_rank - .data$manual_adjusted_model_rank) >= 25 ~ TRUE,
        .data$rank_confidence < 0.40 ~ TRUE,
        TRUE ~ FALSE
      )
    ) |>
    dplyr::arrange(.data$position, .data$calibrated_rank_position, desc(.data$final_value_score)) |>
    dplyr::mutate(
      calibrated_rank = dplyr::row_number(),
      display_rank = .data$final_value_rank,
      display_score = .data$final_value_score,
      display_rank_source = dplyr::if_else(
        dplyr::coalesce(as.logical(.data$manual_rank_has_input), FALSE),
          "final_value_rank_manual_blend",
        "final_value_rank_market_blend"
      ),
      calibrated_rank_role = "audit_only",
      calibrated_rank_delta_vs_final_value = .data$final_value_rank - .data$calibrated_rank,
      calibrated_rank_delta_vs_projection = .data$manual_adjusted_projection_rank - .data$calibrated_rank,
      calibrated_rank_delta_vs_model = .data$manual_adjusted_model_rank - .data$calibrated_rank,
      tier = sos_rank_tier_from_rank(.data$position, .data$calibrated_rank)
    ) |>
    dplyr::ungroup() |>
    sos_apply_projection_pool_flags() |>
    dplyr::select(
      "position", "prediction_season", "display_rank", "display_score",
      "display_rank_source", "tier",
      "article_rank", "article_eligible", "active_projection_pool",
      "eligibility_reason",
      "calibrated_rank", "calibrated_rank_role",
      "calibrated_score", "rank_confidence", "calibration_reason",
      "needs_manual_review", "final_value_rank", "final_value_score",
      "manual_adjusted_model_rank", "manual_adjusted_projection_rank",
      "market_position_rank", "calibrated_rank_delta_vs_final_value",
      "calibrated_rank_delta_vs_projection", "calibrated_rank_delta_vs_model",
      "player_key", "player", "current_team", "official_omfg",
      "adjusted_projected_games", "adjusted_projected_ppg", "adjusted_p50_points",
      "context_adjustment_count", "manual_context_note",
      "signal_agreement_count", "projection_instability",
      "market_projection_rank_gap", "market_flag", "market_gap_bucket",
      dplyr::everything()
    )

  summary <- calibrated |>
    dplyr::group_by(.data$position) |>
    dplyr::summarise(
      rows = dplyr::n(),
      active_projection_pool_rows = sum(.data$active_projection_pool, na.rm = TRUE),
      article_eligible_rows = sum(.data$article_eligible, na.rm = TRUE),
      manual_review_rows = sum(.data$needs_manual_review, na.rm = TRUE),
      avg_rank_confidence = mean(.data$rank_confidence, na.rm = TRUE),
      avg_abs_move_vs_final_value = mean(abs(.data$calibrated_rank_delta_vs_final_value), na.rm = TRUE),
      max_abs_move_vs_final_value = max(abs(.data$calibrated_rank_delta_vs_final_value), na.rm = TRUE),
      .groups = "drop"
    )

  if (isTRUE(write_output)) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    sos_try_write_csv(
      calibrated,
      file.path(output_dir, paste0("core_sos_calibrated_rankings_", prediction_season, ".csv"))
    )
    sos_try_write_csv(
      summary,
      file.path(output_dir, paste0("core_sos_calibrated_rankings_summary_", prediction_season, ".csv"))
    )
    sos_try_write_csv(
      calibrated |>
        dplyr::filter(.data$article_eligible) |>
        dplyr::arrange(.data$position, .data$article_rank),
      file.path(output_dir, paste0("core_sos_article_rankings_", prediction_season, ".csv"))
    )
  }

  out <- list(calibrated = calibrated, summary = summary, final_value = final_value)
  assign("core_sos_calibrated_rankings", out, envir = .GlobalEnv)
  invisible(out)
}

sos_editor_output_dir <- function(prediction_season = 2026L) {
  file.path(
    model_paths$model_root_dir,
    "outputs",
    "editor",
    as.character(as.integer(prediction_season[[1]]))
  )
}

sos_editor_stat_columns <- function(position) {
  switch(
    toupper(as.character(position[[1]])),
    QB = c(
      "Projected Pass Attempts" = "projected_pass_attempts",
      "Projected Pass Yards" = "projected_pass_yards",
      "Projected Pass TDs" = "projected_pass_td",
      "Projected Interceptions" = "projected_interceptions",
      "Projected Rush Attempts" = "projected_rush_attempts",
      "Projected Rush Yards" = "projected_rush_yards",
      "Projected Rush TDs" = "projected_rush_td"
    ),
    RB = c(
      "Projected Rush Attempts" = "projected_rush_attempts",
      "Projected Rush Yards" = "projected_rush_yards",
      "Projected Rush TDs" = "projected_rush_td",
      "Projected Targets" = "projected_targets",
      "Projected Receptions" = "projected_receptions",
      "Projected Receiving Yards" = "projected_receiving_yards",
      "Projected Receiving TDs" = "projected_receiving_td",
      "Projected Scrimmage Yards" = "projected_scrimmage_yards",
      "Projected Total TDs" = "projected_total_td"
    ),
    WR = c(
      "Projected Targets" = "projected_targets",
      "Projected Receptions" = "projected_receptions",
      "Projected Receiving Yards" = "projected_receiving_yards",
      "Projected Receiving TDs" = "projected_receiving_td",
      "Projected Air Yards" = "projected_air_yards",
      "Projected First Read Targets" = "projected_first_read_targets",
      "Projected End Zone Targets" = "projected_end_zone_targets",
      "Projected Receiving First Downs" = "projected_receiving_first_downs",
      "Projected Rush Attempts" = "projected_rush_attempts",
      "Projected Rush Yards" = "projected_rush_yards",
      "Projected Rush TDs" = "projected_rush_td",
      "Projected Scrimmage Yards" = "projected_scrimmage_yards",
      "Projected Total TDs" = "projected_total_td"
    ),
    TE = c(
      "Projected Targets" = "projected_targets",
      "Projected Receptions" = "projected_receptions",
      "Projected Receiving Yards" = "projected_receiving_yards",
      "Projected Receiving TDs" = "projected_receiving_td",
      "Projected Air Yards" = "projected_air_yards",
      "Projected First Read Targets" = "projected_first_read_targets",
      "Projected End Zone Targets" = "projected_end_zone_targets",
      "Projected Receiving First Downs" = "projected_receiving_first_downs"
    ),
    K = c(
      "Projected FG Attempts" = "projected_fga",
      "Projected FGs Made" = "projected_fgm",
      "Projected 40-49 FG Attempts" = "projected_fga_40_49",
      "Projected 40-49 FGs Made" = "projected_fgm_40_49",
      "Projected 50+ FG Attempts" = "projected_fga_50_plus",
      "Projected 50+ FGs Made" = "projected_fgm_50_plus",
      "Projected XP Attempts" = "projected_xpa",
      "Projected XPs Made" = "projected_xpm"
    ),
    DST = c(
      "Projected Sacks" = "projected_sacks",
      "Projected Interceptions" = "projected_interceptions",
      "Projected Fumbles" = "projected_fumbles",
      "Projected Defensive TDs" = "projected_defensive_tds",
      "Projected DST Fantasy Points" = "projected_dst_fantasy_points"
    ),
    character()
  )
}

sos_historical_editor_output_dir <- function() {
  file.path(model_paths$model_root_dir, "outputs", "editor", "historical")
}

sos_historical_feature_path <- function(position) {
  file.path(
    model_paths$wow_output_dir,
    paste0(tolower(position), "_weekly_feature_base_2021_2025_regular.csv")
  )
}

sos_historical_stat_columns <- function(position) {
  switch(
    toupper(as.character(position[[1]])),
    QB = c(
      "Pass Attempts" = "pass_attempts",
      "Pass Yards" = "pass_yards",
      "Pass TDs" = "pass_td",
      "Interceptions" = "interceptions",
      "Rush Attempts" = "rush_attempts",
      "Rush Yards" = "rush_yards",
      "Rush TDs" = "rush_td"
    ),
    RB = c(
      "Rush Attempts" = "rush_attempts",
      "Rush Yards" = "rush_yards",
      "Rush TDs" = "rush_td",
      "Targets" = "targets",
      "Receptions" = "receptions",
      "Receiving Yards" = "receiving_yards",
      "Receiving TDs" = "receiving_td",
      "Scrimmage Yards" = "scrimmage_yards",
      "Total TDs" = "total_td"
    ),
    WR = c(
      "Targets" = "targets",
      "Receptions" = "receptions",
      "Receiving Yards" = "receiving_yards",
      "Receiving TDs" = "receiving_td",
      "Air Yards" = "air_yards",
      "First Read Targets" = "first_read_targets",
      "End Zone Targets" = "end_zone_targets",
      "Receiving First Downs" = "receiving_first_downs",
      "Rush Attempts" = "rush_attempts",
      "Rush Yards" = "rush_yards",
      "Rush TDs" = "rush_td",
      "Scrimmage Yards" = "scrimmage_yards",
      "Total TDs" = "total_td"
    ),
    TE = c(
      "Targets" = "targets",
      "Receptions" = "receptions",
      "Receiving Yards" = "receiving_yards",
      "Receiving TDs" = "receiving_td",
      "Air Yards" = "air_yards",
      "First Read Targets" = "first_read_targets",
      "End Zone Targets" = "end_zone_targets",
      "Receiving First Downs" = "receiving_first_downs"
    ),
    K = c(
      "FG Attempts" = "fga",
      "FGs Made" = "fgm",
      "40-49 FG Attempts" = "fga_40_49",
      "40-49 FGs Made" = "fgm_40_49",
      "50+ FG Attempts" = "fga_50_plus",
      "50+ FGs Made" = "fgm_50_plus",
      "XP Attempts" = "extra_points_attempt",
      "XPs Made" = "extra_points_made"
    ),
    DST = c(
      "Sacks" = "sacks",
      "Interceptions" = "interceptions",
      "Fumbles" = "fumbles",
      "Defensive TDs" = "defensive_tds",
      "DST Fantasy Points" = "dst_fantasy_points"
    ),
    character()
  )
}

sos_build_historical_board <- function(seasons = 2021:2025) {
  load_model_core_packages()
  seasons <- sort(unique(as.integer(seasons)))
  positions <- c("QB", "RB", "WR", "TE", "K", "DST")
  historical <- dplyr::bind_rows(lapply(positions, function(position) {
    path <- file.path(
      model_paths$sos_output_dir,
      paste0(tolower(position), "_sos_final_export_2022_2025.csv")
    )
    if (!file.exists(path)) {
      stop("Missing historical SOS final export: ", path, call. = FALSE)
    }
    board <- read_csv_flexible(path)
    if (position == "DST") {
      dplyr::transmute(
        board,
        historical_season = safe_integer(.data$source_season),
        position = "DST",
        sos_rank_raw = safe_integer(.data$dst_sos_rank),
        tier = as.character(.data$dst_sos_tier),
        player = as.character(.data$player),
        player_key = make_player_key(.data$player),
        board_team = normalize_team_abbr(.data$team),
        omfg_score = safe_numeric(.data$dst_sos_final_score),
        sos_model_score = safe_numeric(.data$dst_sos_final_score)
      )
    } else {
      dplyr::transmute(
        board,
        historical_season = safe_integer(.data$season) - 1L,
        position = .env$position,
        sos_rank_raw = safe_integer(.data$rank),
        tier = as.character(.data$tier),
        player = as.character(.data$player),
        player_key = make_player_key(.data$player),
        board_team = normalize_team_abbr(.data$current_team),
        omfg_score = safe_numeric(.data$preseason_omfg),
        sos_model_score = safe_numeric(.data$final_score)
      )
    }
  })) |>
    dplyr::filter(.data$historical_season %in% .env$seasons)

  if (2025L %in% seasons) {
    production_path <- file.path(
      sos_production_output_dir(),
      "core_sos_production_2026.csv"
    )
    if (!file.exists(production_path)) {
      stop("Missing 2026 production board needed for 2025 history: ", production_path, call. = FALSE)
    }
    production <- read_csv_flexible(production_path) |>
      dplyr::filter(.data$source_season == 2025L) |>
      dplyr::mutate(
        player_key = dplyr::if_else(
          is.na(.data$player_key) | !nzchar(trimws(as.character(.data$player_key))),
          make_player_key(.data$player),
          as.character(.data$player_key)
        )
      ) |>
      dplyr::transmute(
        historical_season = 2025L,
        position = toupper(as.character(.data$position)),
        sos_rank_raw = safe_integer(.data$rank),
        tier = as.character(.data$tier),
        player = as.character(.data$player),
        player_key = as.character(.data$player_key),
        board_team = normalize_team_abbr(dplyr::coalesce(
          as.character(.data$prior_team_2025),
          as.character(.data$current_team)
        )),
        omfg_score = dplyr::coalesce(
          safe_numeric(.data$preseason_omfg),
          safe_numeric(.data$final_score)
        ),
        sos_model_score = safe_numeric(.data$final_score)
      )
    historical <- dplyr::bind_rows(historical, production)
  }

  historical |>
    dplyr::filter(
      .data$historical_season %in% .env$seasons,
      .data$position %in% positions,
      nzchar(trimws(.data$player_key)),
      is.finite(.data$sos_rank_raw)
    ) |>
    dplyr::arrange(.data$historical_season, .data$position, .data$sos_rank_raw) |>
    dplyr::distinct(.data$historical_season, .data$position, .data$player_key, .keep_all = TRUE)
}

sos_build_historical_actuals <- function(position, seasons = 2021:2025) {
  load_model_core_packages()
  position <- toupper(as.character(position[[1]]))
  seasons <- sort(unique(as.integer(seasons)))
  path <- sos_historical_feature_path(position)
  if (!file.exists(path)) {
    stop("Missing historical weekly feature base: ", path, call. = FALSE)
  }
  weekly <- read_csv_flexible(path)
  if (!"player_key" %in% names(weekly)) {
    weekly$player_key <- make_player_key(weekly$player)
  } else {
    missing_key <- is.na(weekly$player_key) | !nzchar(trimws(as.character(weekly$player_key)))
    weekly$player_key[missing_key] <- make_player_key(weekly$player[missing_key])
  }
  if (!"game_number" %in% names(weekly)) weekly$game_number <- weekly$week
  point_candidates <- switch(
    position,
    QB = c("fantasy_points_official", "fantasy_points_calc"),
    RB = c("half_ppr_points", "fantasy_points_calc"),
    WR = c("half_ppr_points", "fantasy_points_calc"),
    TE = c("half_ppr_points", "fantasy_points_calc"),
    K = c("fantasy_points_official", "fantasy_points_calc"),
    DST = c("dst_fantasy_points"),
    character()
  )
  weekly$actual_fantasy_points <- pick_first_existing_numeric(weekly, point_candidates)
  stat_columns <- unique(unname(sos_historical_stat_columns(position)))
  for (column in setdiff(stat_columns, names(weekly))) weekly[[column]] <- NA_real_

  weekly |>
    dplyr::mutate(
      season = safe_integer(.data$season),
      week = safe_integer(.data$week),
      player_key = as.character(.data$player_key),
      team = normalize_team_abbr(.data$team)
    ) |>
    dplyr::filter(
      .data$season %in% .env$seasons,
      nzchar(trimws(.data$player_key)),
      is.finite(.data$week)
    ) |>
    dplyr::arrange(.data$season, .data$week, .data$player_key, .data$game_number) |>
    dplyr::distinct(.data$season, .data$week, .data$player_key, .keep_all = TRUE) |>
    dplyr::group_by(.data$season, .data$player_key) |>
    dplyr::summarise(
      actual_player = first_non_missing_character(.data$player),
      actual_team = first_non_missing_character(rev(.data$team)),
      games = dplyr::n_distinct(.data$week),
      actual_fantasy_points = sum(safe_numeric(.data$actual_fantasy_points), na.rm = TRUE),
      dplyr::across(dplyr::all_of(stat_columns), ~ sum(safe_numeric(.x), na.rm = TRUE)),
      .groups = "drop"
    ) |>
    dplyr::mutate(
      position = .env$position,
      actual_ppg = safe_div(.data$actual_fantasy_points, .data$games)
    ) |>
    dplyr::filter(.data$games > 0L)
}

build_core_sos_historical_editor_exports <- function(
    seasons = 2021:2025,
    output_dir = sos_historical_editor_output_dir(),
    write_output = TRUE
) {
  load_model_core_packages()
  seasons <- sort(unique(as.integer(seasons)))
  positions <- c("QB", "RB", "WR", "TE", "K", "DST")
  replacement_rank <- c(QB = 12L, RB = 36L, WR = 48L, TE = 12L, K = 12L, DST = 12L)
  board <- sos_build_historical_board(seasons)
  actuals <- dplyr::bind_rows(lapply(
    positions,
    sos_build_historical_actuals,
    seasons = seasons
  ))
  matched <- board |>
    dplyr::inner_join(
      actuals,
      by = c(
        "historical_season" = "season",
        "position",
        "player_key"
      ),
      relationship = "one-to-one"
    ) |>
    dplyr::mutate(
      team = dplyr::coalesce(.data$actual_team, .data$board_team),
      player = dplyr::coalesce(.data$player, .data$actual_player)
    ) |>
    dplyr::group_by(.data$historical_season, .data$position) |>
    dplyr::arrange(.data$sos_rank_raw, dplyr::desc(.data$omfg_score), .by_group = TRUE) |>
    dplyr::mutate(sos_rank = dplyr::row_number()) |>
    dplyr::arrange(
      dplyr::desc(.data$actual_fantasy_points),
      dplyr::desc(.data$actual_ppg),
      dplyr::desc(.data$omfg_score),
      .by_group = TRUE
    ) |>
    dplyr::mutate(actual_position_finish = dplyr::row_number()) |>
    dplyr::ungroup()

  add_stat_columns <- function(out, rows, stat_map) {
    for (label in names(stat_map)) {
      source_column <- unname(stat_map[[label]])
      out[[label]] <- if (source_column %in% names(rows)) {
        round(safe_numeric(rows[[source_column]]), 1)
      } else {
        NA_real_
      }
    }
    out
  }
  add_common_columns <- function(rows, include_overall = FALSE) {
    out <- data.frame(row.names = seq_len(nrow(rows)), check.names = FALSE)
    if (isTRUE(include_overall)) {
      out[["Overall Result Rank"]] <- as.integer(rows$overall_result_rank)
      out[["Actual Position Finish"]] <- as.integer(rows$actual_position_finish)
    }
    out[["SOS Rank"]] <- as.integer(rows$sos_rank)
    if (!isTRUE(include_overall)) out[["Actual Finish"]] <- as.integer(rows$actual_position_finish)
    out[["Player"]] <- as.character(rows$player)
    out[["Position"]] <- as.character(rows$position)
    out[["Team"]] <- as.character(rows$team)
    out[["Season"]] <- as.integer(rows$historical_season)
    out[["Tier"]] <- as.character(rows$tier)
    out[["OMFG Score"]] <- round(safe_numeric(rows$omfg_score), 1)
    out[["Games"]] <- as.integer(rows$games)
    out[["Actual PPG"]] <- round(safe_numeric(rows$actual_ppg), 1)
    out[["Actual Fantasy Points"]] <- round(safe_numeric(rows$actual_fantasy_points), 1)
    out
  }

  results <- lapply(seasons, function(season) {
    season_rows <- matched |>
      dplyr::filter(.data$historical_season == .env$season)
    replacement <- dplyr::bind_rows(lapply(positions, function(position) {
      rows <- season_rows |>
        dplyr::filter(.data$position == .env$position) |>
        dplyr::arrange(.data$actual_position_finish)
      target <- min(nrow(rows), replacement_rank[[position]])
      data.frame(
        position = position,
        replacement_actual_points = if (target > 0L) rows$actual_fantasy_points[[target]] else NA_real_,
        stringsAsFactors = FALSE
      )
    }))
    season_rows <- season_rows |>
      dplyr::left_join(replacement, by = "position", relationship = "many-to-one") |>
      dplyr::mutate(
        actual_value_over_replacement = .data$actual_fantasy_points -
          .data$replacement_actual_points
      ) |>
      dplyr::arrange(
        dplyr::desc(.data$actual_value_over_replacement),
        dplyr::desc(.data$actual_fantasy_points),
        dplyr::desc(.data$actual_ppg),
        dplyr::desc(.data$omfg_score),
        .data$actual_position_finish,
        .data$player
      ) |>
      dplyr::mutate(overall_result_rank = dplyr::row_number())

    overall <- add_common_columns(season_rows, include_overall = TRUE)
    all_stat_map <- unlist(lapply(positions, sos_historical_stat_columns), use.names = TRUE)
    all_stat_map <- all_stat_map[!duplicated(names(all_stat_map))]
    overall <- add_stat_columns(overall, season_rows, all_stat_map)
    position_exports <- lapply(positions, function(position) {
      rows <- season_rows |>
        dplyr::filter(.data$position == .env$position) |>
        dplyr::arrange(.data$sos_rank)
      add_stat_columns(add_common_columns(rows), rows, sos_historical_stat_columns(position))
    })
    names(position_exports) <- positions

    actual_order_inversions <- sum(vapply(
      split(season_rows, season_rows$position),
      function(rows) {
        rows <- rows[order(rows$actual_position_finish), , drop = FALSE]
        sum(diff(rows$overall_result_rank) < 0L)
      },
      integer(1)
    ))
    audit <- data.frame(
      historical_season = season,
      board_rows = sum(board$historical_season == season),
      matched_rows = nrow(season_rows),
      unmatched_board_rows = sum(board$historical_season == season) - nrow(season_rows),
      duplicate_overall_result_ranks = sum(duplicated(overall[["Overall Result Rank"]])),
      duplicate_player_position_keys = sum(duplicated(paste(season_rows$position, season_rows$player_key))),
      missing_player_names = sum(!nzchar(trimws(as.character(season_rows$player)))),
      missing_teams = sum(!nzchar(trimws(as.character(season_rows$team)))),
      missing_omfg_scores = sum(!is.finite(safe_numeric(season_rows$omfg_score))),
      missing_actual_points = sum(!is.finite(safe_numeric(season_rows$actual_fantasy_points))),
      actual_result_order_inversions = actual_order_inversions,
      status = if (
        nrow(season_rows) > 0L &&
          !anyDuplicated(overall[["Overall Result Rank"]]) &&
          !anyDuplicated(paste(season_rows$position, season_rows$player_key)) &&
          all(nzchar(trimws(as.character(season_rows$player)))) &&
          all(nzchar(trimws(as.character(season_rows$team)))) &&
          all(is.finite(safe_numeric(season_rows$omfg_score))) &&
          all(is.finite(safe_numeric(season_rows$actual_fantasy_points))) &&
          actual_order_inversions == 0L
      ) "PASS" else "FAIL",
      stringsAsFactors = FALSE
    )
    summary <- season_rows |>
      dplyr::count(.data$position, name = "rows") |>
      dplyr::mutate(
        historical_season = .env$season,
        replacement_rank = unname(.env$replacement_rank[.data$position])
      ) |>
      dplyr::select("position", "historical_season", "rows", "replacement_rank")

    season_output_dir <- file.path(output_dir, as.character(season))
    manifest <- data.frame(
      artifact = c("overall", tolower(positions), "audit", "summary"),
      output_path = c(
        file.path(season_output_dir, paste0("sos_", season, "_historical_overall.csv")),
        file.path(season_output_dir, paste0("sos_", season, "_historical_", tolower(positions), ".csv")),
        file.path(season_output_dir, paste0("sos_", season, "_historical_audit.csv")),
        file.path(season_output_dir, paste0("sos_", season, "_historical_summary.csv"))
      ),
      stringsAsFactors = FALSE
    )
    if (isTRUE(write_output)) {
      dir.create(season_output_dir, recursive = TRUE, showWarnings = FALSE)
      sos_try_write_csv(overall, manifest$output_path[manifest$artifact == "overall"])
      for (position in positions) {
        sos_try_write_csv(
          position_exports[[position]],
          manifest$output_path[manifest$artifact == tolower(position)]
        )
      }
      sos_try_write_csv(audit, manifest$output_path[manifest$artifact == "audit"])
      sos_try_write_csv(summary, manifest$output_path[manifest$artifact == "summary"])
      manifest$exists <- file.exists(manifest$output_path)
      sos_try_write_csv(
        manifest,
        file.path(season_output_dir, paste0("sos_", season, "_historical_manifest.csv"))
      )
    } else {
      manifest$exists <- NA
    }
    list(
      season = season,
      overall = overall,
      positions = position_exports,
      audit = audit,
      summary = summary,
      manifest = manifest
    )
  })
  names(results) <- as.character(seasons)
  if (isTRUE(write_output)) {
    sos_try_write_csv(
      dplyr::bind_rows(lapply(results, `[[`, "overall")),
      file.path(output_dir, paste0("sos_", min(seasons), "_", max(seasons), "_historical_master.csv"))
    )
    sos_try_write_csv(
      dplyr::bind_rows(lapply(results, `[[`, "audit")),
      file.path(output_dir, paste0("sos_", min(seasons), "_", max(seasons), "_historical_audit.csv"))
    )
  }
  assign("core_sos_historical_editor_exports", results, envir = .GlobalEnv)
  invisible(results)
}

build_core_sos_editor_exports <- function(
    calibrated_rankings = get0("core_sos_calibrated_rankings", envir = .GlobalEnv),
    prediction_season = 2026L,
    output_dir = sos_editor_output_dir(prediction_season),
    write_output = TRUE
) {
  load_model_core_packages()
  prediction_season <- as.integer(prediction_season[[1]])
  calibrated <- if (is.list(calibrated_rankings) && !is.null(calibrated_rankings$calibrated)) {
    calibrated_rankings$calibrated
  } else {
    calibrated_rankings
  }
  if (is.null(calibrated) || !is.data.frame(calibrated) || nrow(calibrated) == 0L) {
    calibrated_path <- file.path(
      sos_production_output_dir(),
      paste0("core_sos_calibrated_rankings_", prediction_season, ".csv")
    )
    if (!file.exists(calibrated_path)) {
      stop("Missing calibrated SOS rankings for editor export: ", calibrated_path, call. = FALSE)
    }
    calibrated <- utils::read.csv(
      calibrated_path,
      stringsAsFactors = FALSE,
      check.names = FALSE
    )
  }
  as_flag <- function(x) {
    tolower(trimws(as.character(x))) %in% c("true", "t", "1", "yes")
  }
  required <- c(
    "position", "prediction_season", "player_key", "player", "current_team",
    "display_rank", "active_projection_pool", "official_omfg",
    "adjusted_projected_games", "adjusted_projected_ppg", "adjusted_p25_points",
    "adjusted_p50_points", "adjusted_p75_points"
  )
  missing <- setdiff(required, names(calibrated))
  if (length(missing) > 0L) {
    stop("Editor export is missing columns: ", paste(missing, collapse = ", "), call. = FALSE)
  }

  pool <- calibrated |>
    dplyr::filter(
      .data$prediction_season == .env$prediction_season,
      .data$position %in% c("QB", "RB", "WR", "TE", "K", "DST"),
      .env$as_flag(.data$active_projection_pool),
      is.finite(sos_prob_num(.data$display_rank)),
      is.finite(sos_prob_num(.data$adjusted_p50_points))
    ) |>
    dplyr::mutate(
      position_rank = as.integer(round(sos_prob_num(.data$display_rank))),
      editor_p50_points = sos_prob_num(.data$adjusted_p50_points),
      editor_omfg = sos_prob_num(.data$official_omfg)
    ) |>
    dplyr::arrange(
      factor(.data$position, levels = c("QB", "RB", "WR", "TE", "K", "DST")),
      .data$position_rank
    )
  pool <- sos_seed_missing_stat_projection_from_p50(pool)

  replacement_rank <- c(QB = 12L, RB = 36L, WR = 48L, TE = 12L, K = 12L, DST = 12L)
  replacement <- dplyr::bind_rows(lapply(names(replacement_rank), function(pos) {
    position_rows <- pool |>
      dplyr::filter(.data$position == .env$pos) |>
      dplyr::arrange(.data$position_rank)
    target <- pmin(nrow(position_rows), replacement_rank[[pos]])
    data.frame(
      position = pos,
      replacement_rank = replacement_rank[[pos]],
      replacement_p50_points = if (target > 0L) position_rows$editor_p50_points[[target]] else NA_real_,
      stringsAsFactors = FALSE
    )
  }))
  pool <- pool |>
    dplyr::left_join(replacement, by = "position", relationship = "many-to-one") |>
    dplyr::mutate(
      value_over_replacement = .data$editor_p50_points - .data$replacement_p50_points
    ) |>
    dplyr::group_by(.data$position) |>
    dplyr::arrange(.data$position_rank, .by_group = TRUE) |>
    dplyr::mutate(
      constrained_value_over_replacement = cummin(.data$value_over_replacement),
      overall_order_score = .data$constrained_value_over_replacement -
        .data$position_rank * 1e-6
    ) |>
    dplyr::ungroup() |>
    dplyr::arrange(
      dplyr::desc(.data$overall_order_score),
      dplyr::desc(.data$value_over_replacement),
      dplyr::desc(.data$editor_omfg),
      .data$position_rank,
      .data$player
    ) |>
    dplyr::mutate(overall_rank = dplyr::row_number())

  add_common_columns <- function(rows, include_overall = FALSE) {
    out <- data.frame(row.names = seq_len(nrow(rows)), check.names = FALSE)
    if (isTRUE(include_overall)) out[["Overall Rank"]] <- as.integer(rows$overall_rank)
    out[[if (isTRUE(include_overall)) "Position Rank" else "Rank"]] <- as.integer(rows$position_rank)
    out[["Player"]] <- as.character(rows$player)
    out[["Position"]] <- as.character(rows$position)
    out[["Team"]] <- dplyr::coalesce(as.character(rows$current_team), as.character(rows$next_team))
    out[["Tier"]] <- as.character(rows$tier)
    out[["OMFG Score"]] <- round(sos_prob_num(rows$official_omfg), 1)
    out[["Projected Games"]] <- round(sos_prob_num(rows$adjusted_projected_games), 1)
    out[["Projected PPG"]] <- round(sos_prob_num(rows$adjusted_projected_ppg), 1)
    out[["Floor (P25)"]] <- round(sos_prob_num(rows$adjusted_p25_points), 1)
    out[["Base (P50)"]] <- round(sos_prob_num(rows$adjusted_p50_points), 1)
    out[["Ceiling (P75)"]] <- round(sos_prob_num(rows$adjusted_p75_points), 1)
    out
  }
  add_stat_columns <- function(out, rows, stat_map) {
    for (label in names(stat_map)) {
      source_col <- unname(stat_map[[label]])
      out[[label]] <- if (source_col %in% names(rows)) {
        round(sos_prob_num(rows[[source_col]]), 1)
      } else {
        NA_real_
      }
    }
    out
  }

  position_exports <- lapply(c("QB", "RB", "WR", "TE", "K", "DST"), function(pos) {
    rows <- pool |>
      dplyr::filter(.data$position == .env$pos) |>
      dplyr::arrange(.data$position_rank)
    add_stat_columns(add_common_columns(rows), rows, sos_editor_stat_columns(pos))
  })
  names(position_exports) <- c("QB", "RB", "WR", "TE", "K", "DST")

  overall <- pool |>
    dplyr::arrange(.data$overall_rank)
  overall_export <- add_common_columns(overall, include_overall = TRUE)
  all_stat_map <- unlist(
    lapply(c("QB", "RB", "WR", "TE", "K", "DST"), sos_editor_stat_columns),
    use.names = TRUE
  )
  all_stat_map <- all_stat_map[!duplicated(names(all_stat_map))]
  overall_export <- add_stat_columns(overall_export, overall, all_stat_map)

  summary <- pool |>
    dplyr::count(.data$position, name = "rows") |>
    dplyr::mutate(
      prediction_season = .env$prediction_season,
      replacement_rank = unname(.env$replacement_rank[.data$position])
    ) |>
    dplyr::select("position", "prediction_season", "rows", "replacement_rank")
  position_order_inversions <- sum(vapply(
    split(pool, pool$position),
    function(rows) {
      rows <- rows[order(rows$position_rank), , drop = FALSE]
      sum(diff(rows$overall_rank) < 0L)
    },
    integer(1)
  ))
  audit <- data.frame(
    prediction_season = prediction_season,
    overall_rows = nrow(overall_export),
    position_rows = sum(vapply(position_exports, nrow, integer(1))),
    duplicate_overall_ranks = sum(duplicated(overall_export[["Overall Rank"]])),
    duplicate_player_position_keys = sum(duplicated(paste(pool$position, pool$player_key))),
    missing_player_names = sum(!nzchar(trimws(as.character(pool$player)))),
    missing_teams = sum(!nzchar(trimws(dplyr::coalesce(as.character(pool$current_team), as.character(pool$next_team))))),
    missing_omfg_scores = sum(!is.finite(sos_prob_num(pool$official_omfg))),
    missing_p50_points = sum(!is.finite(sos_prob_num(pool$adjusted_p50_points))),
    within_position_order_inversions = position_order_inversions,
    overall_rank_before_position_rank = sum(pool$overall_rank < pool$position_rank),
    status = if (
      nrow(overall_export) == sum(vapply(position_exports, nrow, integer(1))) &&
        !anyDuplicated(overall_export[["Overall Rank"]]) &&
        !anyDuplicated(paste(pool$position, pool$player_key)) &&
        all(nzchar(trimws(as.character(pool$player)))) &&
        all(nzchar(trimws(dplyr::coalesce(as.character(pool$current_team), as.character(pool$next_team))))) &&
        all(is.finite(sos_prob_num(pool$official_omfg))) &&
        all(is.finite(sos_prob_num(pool$adjusted_p50_points))) &&
        position_order_inversions == 0L &&
        !any(pool$overall_rank < pool$position_rank)
    ) "PASS" else "FAIL",
    stringsAsFactors = FALSE
  )

  manifest <- data.frame(
    artifact = c("overall", tolower(names(position_exports)), "audit", "summary"),
    output_path = c(
      file.path(output_dir, paste0("sos_", prediction_season, "_editor_overall.csv")),
      file.path(
        output_dir,
        paste0("sos_", prediction_season, "_editor_", tolower(names(position_exports)), ".csv")
      ),
      file.path(output_dir, paste0("sos_", prediction_season, "_editor_audit.csv")),
      file.path(output_dir, paste0("sos_", prediction_season, "_editor_summary.csv"))
    ),
    stringsAsFactors = FALSE
  )
  if (isTRUE(write_output)) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    sos_try_write_csv(overall_export, manifest$output_path[manifest$artifact == "overall"])
    for (pos in names(position_exports)) {
      sos_try_write_csv(
        position_exports[[pos]],
        manifest$output_path[manifest$artifact == tolower(pos)]
      )
    }
    sos_try_write_csv(audit, manifest$output_path[manifest$artifact == "audit"])
    sos_try_write_csv(summary, manifest$output_path[manifest$artifact == "summary"])
    manifest$exists <- file.exists(manifest$output_path)
    sos_try_write_csv(
      manifest,
      file.path(output_dir, paste0("sos_", prediction_season, "_editor_manifest.csv"))
    )
  } else {
    manifest$exists <- NA
  }
  result <- list(
    prediction_season = prediction_season,
    overall = overall_export,
    positions = position_exports,
    replacement = replacement,
    summary = summary,
    audit = audit,
    manifest = manifest,
    overall_rank_method = paste(
      "Rank-constrained Base (P50) points above a 12-team replacement baseline",
      "(QB12, RB36, WR48, TE12, K12, DST12); approved position order is absolute",
      "and OMFG breaks remaining ties."
    )
  )
  assign("core_sos_editor_exports", result, envir = .GlobalEnv)
  invisible(result)
}

build_core_sos_projection_rank_calibration <- function(
    prediction_season = 2026L,
    predictions_path = file.path(sos_production_output_dir(), "core_sos_projection_backtest_predictions_2023_2025.csv"),
    selection_path = file.path(sos_production_output_dir(), "core_sos_projection_model_selection_2023_2025.csv"),
    current_projection_path = file.path(sos_production_output_dir(), paste0("core_sos_projection_board_", prediction_season, ".csv")),
    write_output = TRUE,
    output_dir = sos_production_output_dir()
) {
  load_model_core_packages()
  prediction_season <- as.integer(prediction_season[[1]])

  rank_bucket_fields <- function(position, projected_rank) {
    position <- toupper(as.character(position))
    projected_rank <- safe_numeric(projected_rank)

    bucket_min <- dplyr::case_when(
      position == "QB" & projected_rank <= 6 ~ 1,
      position == "QB" & projected_rank <= 12 ~ 7,
      position == "QB" & projected_rank <= 18 ~ 13,
      position == "QB" & projected_rank <= 24 ~ 19,
      position == "QB" & projected_rank <= 36 ~ 25,
      position == "QB" ~ 37,
      position == "RB" & projected_rank <= 12 ~ 1,
      position == "RB" & projected_rank <= 24 ~ 13,
      position == "RB" & projected_rank <= 36 ~ 25,
      position == "RB" & projected_rank <= 48 ~ 37,
      position == "RB" & projected_rank <= 60 ~ 49,
      position == "RB" ~ 61,
      position == "WR" & projected_rank <= 12 ~ 1,
      position == "WR" & projected_rank <= 24 ~ 13,
      position == "WR" & projected_rank <= 36 ~ 25,
      position == "WR" & projected_rank <= 48 ~ 37,
      position == "WR" & projected_rank <= 60 ~ 49,
      position == "WR" ~ 61,
      position == "TE" & projected_rank <= 6 ~ 1,
      position == "TE" & projected_rank <= 12 ~ 7,
      position == "TE" & projected_rank <= 18 ~ 13,
      position == "TE" & projected_rank <= 24 ~ 19,
      position == "TE" & projected_rank <= 36 ~ 25,
      position == "TE" ~ 37,
      position %in% c("K", "DST") & projected_rank <= 6 ~ 1,
      position %in% c("K", "DST") & projected_rank <= 12 ~ 7,
      position %in% c("K", "DST") & projected_rank <= 18 ~ 13,
      position %in% c("K", "DST") & projected_rank <= 24 ~ 19,
      position %in% c("K", "DST") & projected_rank <= 32 ~ 25,
      position %in% c("K", "DST") ~ 33,
      TRUE ~ NA_real_
    )

    bucket_max <- dplyr::case_when(
      position == "QB" & bucket_min == 1 ~ 6,
      position == "QB" & bucket_min == 7 ~ 12,
      position == "QB" & bucket_min == 13 ~ 18,
      position == "QB" & bucket_min == 19 ~ 24,
      position == "QB" & bucket_min == 25 ~ 36,
      position == "QB" & bucket_min == 37 ~ 999,
      position %in% c("RB", "WR") & bucket_min == 1 ~ 12,
      position %in% c("RB", "WR") & bucket_min == 13 ~ 24,
      position %in% c("RB", "WR") & bucket_min == 25 ~ 36,
      position %in% c("RB", "WR") & bucket_min == 37 ~ 48,
      position %in% c("RB", "WR") & bucket_min == 49 ~ 60,
      position %in% c("RB", "WR") & bucket_min == 61 ~ 999,
      position == "TE" & bucket_min == 1 ~ 6,
      position == "TE" & bucket_min == 7 ~ 12,
      position == "TE" & bucket_min == 13 ~ 18,
      position == "TE" & bucket_min == 19 ~ 24,
      position == "TE" & bucket_min == 25 ~ 36,
      position == "TE" & bucket_min == 37 ~ 999,
      position %in% c("K", "DST") & bucket_min == 1 ~ 6,
      position %in% c("K", "DST") & bucket_min == 7 ~ 12,
      position %in% c("K", "DST") & bucket_min == 13 ~ 18,
      position %in% c("K", "DST") & bucket_min == 19 ~ 24,
      position %in% c("K", "DST") & bucket_min == 25 ~ 32,
      position %in% c("K", "DST") & bucket_min == 33 ~ 999,
      TRUE ~ NA_real_
    )

    bucket_label <- dplyr::case_when(
      !is.finite(bucket_min) ~ NA_character_,
      bucket_max >= 999 ~ paste0(as.integer(bucket_min), "+"),
      TRUE ~ paste0(as.integer(bucket_min), "-", as.integer(bucket_max))
    )

    data.frame(
      rank_bucket = bucket_label,
      bucket_min = bucket_min,
      bucket_max = bucket_max,
      stringsAsFactors = FALSE
    )
  }

  if (!file.exists(predictions_path) || !file.exists(selection_path)) {
    backtest <- build_core_sos_projection_backtest()
    historical_predictions <- backtest$predictions
    model_selection <- backtest$selection
  } else {
    historical_predictions <- read_csv_flexible(predictions_path)
    model_selection <- read_csv_flexible(selection_path)
  }

  selected_models <- model_selection |>
    dplyr::filter(.data$selected %in% c(TRUE, "TRUE", "true", 1L)) |>
    dplyr::select("position", "target", "candidate")

  historical_ranked <- historical_predictions |>
    dplyr::inner_join(
      selected_models,
      by = c("position", "target", "candidate"),
      relationship = "many-to-one"
    ) |>
    dplyr::mutate(
      position = toupper(as.character(.data$position)),
      prediction = safe_numeric(.data$prediction),
      actual = safe_numeric(.data$actual)
    ) |>
    dplyr::filter(is.finite(.data$prediction), is.finite(.data$actual)) |>
    dplyr::group_by(.data$position, .data$target, .data$test_season) |>
    dplyr::arrange(dplyr::desc(.data$prediction), .by_group = TRUE) |>
    dplyr::mutate(projected_rank = dplyr::row_number()) |>
    dplyr::ungroup()

  historical_bucket_fields <- rank_bucket_fields(
    historical_ranked$position,
    historical_ranked$projected_rank
  )
  historical_ranked <- dplyr::bind_cols(historical_ranked, historical_bucket_fields)

  bucket_calibration <- historical_ranked |>
    dplyr::group_by(.data$position, .data$target, .data$rank_bucket, .data$bucket_min, .data$bucket_max) |>
    dplyr::summarise(
      test_seasons = paste(sort(unique(.data$test_season)), collapse = ","),
      rows = dplyr::n(),
      avg_projected = mean(.data$prediction, na.rm = TRUE),
      avg_actual = mean(.data$actual, na.rm = TRUE),
      median_projected = stats::median(.data$prediction, na.rm = TRUE),
      median_actual = stats::median(.data$actual, na.rm = TRUE),
      projected_minus_actual = .data$avg_projected - .data$avg_actual,
      pct_bias_vs_actual = dplyr::if_else(
        abs(.data$avg_actual) > 0.0001,
        .data$projected_minus_actual / abs(.data$avg_actual),
        NA_real_
      ),
      calibration_multiplier = dplyr::if_else(
        abs(.data$avg_projected) > 0.0001,
        .data$avg_actual / .data$avg_projected,
        NA_real_
      ),
      mae = mean(abs(.data$prediction - .data$actual), na.rm = TRUE),
      rmse = sqrt(mean((.data$prediction - .data$actual)^2, na.rm = TRUE)),
      .groups = "drop"
    ) |>
    dplyr::mutate(
      projection_curve_status = dplyr::case_when(
        !is.finite(.data$pct_bias_vs_actual) ~ "insufficient_actual_baseline",
        .data$pct_bias_vs_actual >= 0.10 ~ "historically_over_projected",
        .data$pct_bias_vs_actual <= -0.10 ~ "historically_under_projected",
        TRUE ~ "historically_in_line"
      )
    ) |>
    dplyr::arrange(.data$position, .data$target, .data$bucket_min)

  curve_shape <- bucket_calibration |>
    dplyr::group_by(.data$position, .data$target) |>
    dplyr::arrange(.data$bucket_min, .by_group = TRUE) |>
    dplyr::summarise(
      top_bucket = dplyr::first(.data$rank_bucket),
      bottom_bucket = dplyr::last(.data$rank_bucket),
      top_projected = dplyr::first(.data$avg_projected),
      bottom_projected = dplyr::last(.data$avg_projected),
      top_actual = dplyr::first(.data$avg_actual),
      bottom_actual = dplyr::last(.data$avg_actual),
      projected_spread = .data$top_projected - .data$bottom_projected,
      actual_spread = .data$top_actual - .data$bottom_actual,
      spread_ratio_projected_to_actual = dplyr::if_else(
        abs(.data$actual_spread) > 0.0001,
        .data$projected_spread / .data$actual_spread,
        NA_real_
      ),
      curve_shape_status = dplyr::case_when(
        !is.finite(.data$spread_ratio_projected_to_actual) ~ "insufficient_actual_baseline",
        .data$spread_ratio_projected_to_actual < 0.85 ~ "historically_compressed",
        .data$spread_ratio_projected_to_actual > 1.15 ~ "historically_aggressive",
        TRUE ~ "historically_in_line"
      ),
      .groups = "drop"
    ) |>
    dplyr::arrange(.data$position, .data$target)

  current_bucket_comparison <- data.frame()
  if (file.exists(current_projection_path)) {
    current_board <- read_csv_flexible(current_projection_path) |>
      dplyr::mutate(position = toupper(as.character(.data$position)))

    current_targets <- dplyr::bind_rows(
      current_board |>
        dplyr::transmute(
          position = .data$position,
          prediction_season = safe_integer(.data$prediction_season),
          target = "ppg",
          player = as.character(.data$player),
          projected_value = safe_numeric(.data$adjusted_projected_ppg)
        ),
      current_board |>
        dplyr::transmute(
          position = .data$position,
          prediction_season = safe_integer(.data$prediction_season),
          target = "total",
          player = as.character(.data$player),
          projected_value = safe_numeric(.data$adjusted_p50_points)
        )
    ) |>
      dplyr::filter(is.finite(.data$projected_value)) |>
      dplyr::group_by(.data$position, .data$target) |>
      dplyr::arrange(dplyr::desc(.data$projected_value), .by_group = TRUE) |>
      dplyr::mutate(projected_rank = dplyr::row_number()) |>
      dplyr::ungroup()

    current_bucket_fields <- rank_bucket_fields(
      current_targets$position,
      current_targets$projected_rank
    )
    current_targets <- dplyr::bind_cols(current_targets, current_bucket_fields)

    current_bucket_comparison <- current_targets |>
      dplyr::group_by(.data$position, .data$target, .data$rank_bucket, .data$bucket_min, .data$bucket_max) |>
      dplyr::summarise(
        prediction_season = dplyr::first(.data$prediction_season),
        rows = dplyr::n(),
        current_avg_projection = mean(.data$projected_value, na.rm = TRUE),
        current_median_projection = stats::median(.data$projected_value, na.rm = TRUE),
        .groups = "drop"
      ) |>
      dplyr::left_join(
        dplyr::select(
          bucket_calibration,
          "position", "target", "rank_bucket", "historical_avg_actual" = "avg_actual",
          "historical_avg_projected" = "avg_projected",
          "historical_calibration_multiplier" = "calibration_multiplier"
        ),
        by = c("position", "target", "rank_bucket"),
        relationship = "many-to-one"
      ) |>
      dplyr::mutate(
        current_vs_historical_actual = .data$current_avg_projection - .data$historical_avg_actual,
        current_pct_vs_historical_actual = dplyr::if_else(
          abs(.data$historical_avg_actual) > 0.0001,
          .data$current_vs_historical_actual / abs(.data$historical_avg_actual),
          NA_real_
        ),
        suggested_bucket_multiplier = dplyr::if_else(
          abs(.data$current_avg_projection) > 0.0001,
          .data$historical_avg_actual / .data$current_avg_projection,
          NA_real_
        ),
        current_curve_status = dplyr::case_when(
          !is.finite(.data$current_pct_vs_historical_actual) ~ "insufficient_historical_baseline",
          .data$current_pct_vs_historical_actual >= 0.10 ~ "current_boosted_vs_history",
          .data$current_pct_vs_historical_actual <= -0.10 ~ "current_compressed_vs_history",
          TRUE ~ "current_in_line"
        )
      ) |>
      dplyr::arrange(.data$position, .data$target, .data$bucket_min)
  }

  if (isTRUE(write_output)) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    sos_try_write_csv(
      historical_ranked,
      file.path(output_dir, "core_sos_projection_rank_calibration_rows_2023_2025.csv")
    )
    sos_try_write_csv(
      bucket_calibration,
      file.path(output_dir, "core_sos_projection_rank_bucket_calibration_2023_2025.csv")
    )
    sos_try_write_csv(
      curve_shape,
      file.path(output_dir, "core_sos_projection_curve_shape_calibration_2023_2025.csv")
    )
    sos_try_write_csv(
      current_bucket_comparison,
      file.path(output_dir, paste0("core_sos_projection_rank_bucket_current_vs_history_", prediction_season, ".csv"))
    )
  }

  out <- list(
    historical_rows = historical_ranked,
    bucket_calibration = bucket_calibration,
    curve_shape = curve_shape,
    current_bucket_comparison = current_bucket_comparison
  )
  assign("core_sos_projection_rank_calibration", out, envir = .GlobalEnv)
  invisible(out)
}

build_core_sos_projected_games_calibration <- function(
    prediction_season = 2026L,
    predictions_path = file.path(sos_production_output_dir(), "core_sos_projection_backtest_predictions_2023_2025.csv"),
    selection_path = file.path(sos_production_output_dir(), "core_sos_projection_model_selection_2023_2025.csv"),
    current_projection_path = file.path(sos_production_output_dir(), paste0("core_sos_projection_board_", prediction_season, ".csv")),
    write_output = TRUE,
    output_dir = sos_production_output_dir()
) {
  load_model_core_packages()
  prediction_season <- as.integer(prediction_season[[1]])

  rank_bucket_fields <- function(position, projected_rank) {
    position <- toupper(as.character(position))
    projected_rank <- safe_numeric(projected_rank)
    bucket_min <- dplyr::case_when(
      position == "QB" & projected_rank <= 6 ~ 1,
      position == "QB" & projected_rank <= 12 ~ 7,
      position == "QB" & projected_rank <= 18 ~ 13,
      position == "QB" & projected_rank <= 24 ~ 19,
      position == "QB" & projected_rank <= 36 ~ 25,
      position == "QB" ~ 37,
      position %in% c("RB", "WR") & projected_rank <= 12 ~ 1,
      position %in% c("RB", "WR") & projected_rank <= 24 ~ 13,
      position %in% c("RB", "WR") & projected_rank <= 36 ~ 25,
      position %in% c("RB", "WR") & projected_rank <= 48 ~ 37,
      position %in% c("RB", "WR") & projected_rank <= 60 ~ 49,
      position %in% c("RB", "WR") ~ 61,
      position == "TE" & projected_rank <= 6 ~ 1,
      position == "TE" & projected_rank <= 12 ~ 7,
      position == "TE" & projected_rank <= 18 ~ 13,
      position == "TE" & projected_rank <= 24 ~ 19,
      position == "TE" & projected_rank <= 36 ~ 25,
      position == "TE" ~ 37,
      position %in% c("K", "DST") & projected_rank <= 6 ~ 1,
      position %in% c("K", "DST") & projected_rank <= 12 ~ 7,
      position %in% c("K", "DST") & projected_rank <= 18 ~ 13,
      position %in% c("K", "DST") & projected_rank <= 24 ~ 19,
      position %in% c("K", "DST") & projected_rank <= 32 ~ 25,
      position %in% c("K", "DST") ~ 33,
      TRUE ~ NA_real_
    )
    bucket_max <- dplyr::case_when(
      position == "QB" & bucket_min == 1 ~ 6,
      position == "QB" & bucket_min == 7 ~ 12,
      position == "QB" & bucket_min == 13 ~ 18,
      position == "QB" & bucket_min == 19 ~ 24,
      position == "QB" & bucket_min == 25 ~ 36,
      position == "QB" & bucket_min == 37 ~ 999,
      position %in% c("RB", "WR") & bucket_min == 1 ~ 12,
      position %in% c("RB", "WR") & bucket_min == 13 ~ 24,
      position %in% c("RB", "WR") & bucket_min == 25 ~ 36,
      position %in% c("RB", "WR") & bucket_min == 37 ~ 48,
      position %in% c("RB", "WR") & bucket_min == 49 ~ 60,
      position %in% c("RB", "WR") & bucket_min == 61 ~ 999,
      position == "TE" & bucket_min == 1 ~ 6,
      position == "TE" & bucket_min == 7 ~ 12,
      position == "TE" & bucket_min == 13 ~ 18,
      position == "TE" & bucket_min == 19 ~ 24,
      position == "TE" & bucket_min == 25 ~ 36,
      position == "TE" & bucket_min == 37 ~ 999,
      position %in% c("K", "DST") & bucket_min == 1 ~ 6,
      position %in% c("K", "DST") & bucket_min == 7 ~ 12,
      position %in% c("K", "DST") & bucket_min == 13 ~ 18,
      position %in% c("K", "DST") & bucket_min == 19 ~ 24,
      position %in% c("K", "DST") & bucket_min == 25 ~ 32,
      position %in% c("K", "DST") & bucket_min == 33 ~ 999,
      TRUE ~ NA_real_
    )
    data.frame(
      rank_bucket = dplyr::case_when(
        !is.finite(bucket_min) ~ NA_character_,
        bucket_max >= 999 ~ paste0(as.integer(bucket_min), "+"),
        TRUE ~ paste0(as.integer(bucket_min), "-", as.integer(bucket_max))
      ),
      bucket_min = bucket_min,
      bucket_max = bucket_max,
      stringsAsFactors = FALSE
    )
  }

  if (!file.exists(predictions_path) || !file.exists(selection_path)) {
    backtest <- build_core_sos_projection_backtest()
    historical_predictions <- backtest$predictions
    model_selection <- backtest$selection
  } else {
    historical_predictions <- read_csv_flexible(predictions_path)
    model_selection <- read_csv_flexible(selection_path)
  }

  selected_models <- model_selection |>
    dplyr::filter(.data$selected %in% c(TRUE, "TRUE", "true", 1L)) |>
    dplyr::select("position", "target", "candidate")

  selected_predictions <- historical_predictions |>
    dplyr::inner_join(
      selected_models,
      by = c("position", "target", "candidate"),
      relationship = "many-to-one"
    ) |>
    dplyr::mutate(
      position = toupper(as.character(.data$position)),
      prediction = safe_numeric(.data$prediction),
      actual = safe_numeric(.data$actual)
    )

  historical_games <- dplyr::inner_join(
    selected_predictions |>
      dplyr::filter(.data$target == "ppg") |>
      dplyr::select(
        "position", "test_season", "train_seasons", "player",
        ppg_candidate = "candidate",
        predicted_ppg = "prediction",
        actual_ppg = "actual"
      ),
    selected_predictions |>
      dplyr::filter(.data$target == "total") |>
      dplyr::select(
        "position", "test_season", "player",
        total_candidate = "candidate",
        predicted_total = "prediction",
        actual_total = "actual"
      ),
    by = c("position", "test_season", "player"),
    relationship = "one-to-one"
  ) |>
    dplyr::mutate(
      implied_projected_games = dplyr::if_else(
        is.finite(.data$predicted_ppg) & abs(.data$predicted_ppg) > 0.0001,
        .data$predicted_total / .data$predicted_ppg,
        NA_real_
      ),
      implied_actual_games = dplyr::if_else(
        is.finite(.data$actual_ppg) & abs(.data$actual_ppg) > 0.0001,
        .data$actual_total / .data$actual_ppg,
        NA_real_
      )
    ) |>
    dplyr::filter(
      is.finite(.data$predicted_total),
      is.finite(.data$implied_projected_games),
      is.finite(.data$implied_actual_games)
    ) |>
    dplyr::group_by(.data$position, .data$test_season) |>
    dplyr::arrange(dplyr::desc(.data$predicted_total), .by_group = TRUE) |>
    dplyr::mutate(projected_total_rank = dplyr::row_number()) |>
    dplyr::ungroup()

  historical_bucket_fields <- rank_bucket_fields(
    historical_games$position,
    historical_games$projected_total_rank
  )
  historical_games <- dplyr::bind_cols(historical_games, historical_bucket_fields)

  games_bucket_calibration <- historical_games |>
    dplyr::group_by(.data$position, .data$rank_bucket, .data$bucket_min, .data$bucket_max) |>
    dplyr::summarise(
      test_seasons = paste(sort(unique(.data$test_season)), collapse = ","),
      rows = dplyr::n(),
      avg_implied_projected_games = mean(.data$implied_projected_games, na.rm = TRUE),
      avg_implied_actual_games = mean(.data$implied_actual_games, na.rm = TRUE),
      median_implied_projected_games = stats::median(.data$implied_projected_games, na.rm = TRUE),
      median_implied_actual_games = stats::median(.data$implied_actual_games, na.rm = TRUE),
      projected_minus_actual_games =
        .data$avg_implied_projected_games - .data$avg_implied_actual_games,
      pct_games_bias_vs_actual = dplyr::if_else(
        abs(.data$avg_implied_actual_games) > 0.0001,
        .data$projected_minus_actual_games / abs(.data$avg_implied_actual_games),
        NA_real_
      ),
      games_calibration_multiplier = dplyr::if_else(
        abs(.data$avg_implied_projected_games) > 0.0001,
        .data$avg_implied_actual_games / .data$avg_implied_projected_games,
        NA_real_
      ),
      games_curve_status = dplyr::case_when(
        !is.finite(.data$pct_games_bias_vs_actual) ~ "insufficient_actual_games_baseline",
        .data$pct_games_bias_vs_actual >= 0.10 ~ "historically_too_many_games",
        .data$pct_games_bias_vs_actual <= -0.10 ~ "historically_too_few_games",
        TRUE ~ "historically_in_line"
      ),
      .groups = "drop"
    ) |>
    dplyr::arrange(.data$position, .data$bucket_min)

  games_curve_shape <- games_bucket_calibration |>
    dplyr::group_by(.data$position) |>
    dplyr::arrange(.data$bucket_min, .by_group = TRUE) |>
    dplyr::summarise(
      top_bucket = dplyr::first(.data$rank_bucket),
      bottom_bucket = dplyr::last(.data$rank_bucket),
      top_projected_games = dplyr::first(.data$avg_implied_projected_games),
      bottom_projected_games = dplyr::last(.data$avg_implied_projected_games),
      top_actual_games = dplyr::first(.data$avg_implied_actual_games),
      bottom_actual_games = dplyr::last(.data$avg_implied_actual_games),
      projected_games_spread = .data$top_projected_games - .data$bottom_projected_games,
      actual_games_spread = .data$top_actual_games - .data$bottom_actual_games,
      games_spread_ratio_projected_to_actual = dplyr::if_else(
        abs(.data$actual_games_spread) > 0.0001,
        .data$projected_games_spread / .data$actual_games_spread,
        NA_real_
      ),
      games_curve_shape_status = dplyr::case_when(
        !is.finite(.data$games_spread_ratio_projected_to_actual) ~ "insufficient_actual_games_baseline",
        .data$games_spread_ratio_projected_to_actual < 0.85 ~ "games_curve_compressed",
        .data$games_spread_ratio_projected_to_actual > 1.15 ~ "games_curve_aggressive",
        TRUE ~ "games_curve_in_line"
      ),
      .groups = "drop"
    ) |>
    dplyr::arrange(.data$position)

  current_games_comparison <- data.frame()
  if (file.exists(current_projection_path)) {
    current_board <- read_csv_flexible(current_projection_path) |>
      dplyr::mutate(
        position = toupper(as.character(.data$position)),
        adjusted_projected_games = safe_numeric(.data$adjusted_projected_games),
        adjusted_p50_points = safe_numeric(.data$adjusted_p50_points)
      ) |>
      dplyr::filter(
        is.finite(.data$adjusted_projected_games),
        is.finite(.data$adjusted_p50_points)
      ) |>
      dplyr::group_by(.data$position) |>
      dplyr::arrange(dplyr::desc(.data$adjusted_p50_points), .by_group = TRUE) |>
      dplyr::mutate(projected_total_rank = dplyr::row_number()) |>
      dplyr::ungroup()

    current_bucket_fields <- rank_bucket_fields(
      current_board$position,
      current_board$projected_total_rank
    )
    current_board <- dplyr::bind_cols(current_board, current_bucket_fields)

    current_games_comparison <- current_board |>
      dplyr::group_by(.data$position, .data$rank_bucket, .data$bucket_min, .data$bucket_max) |>
      dplyr::summarise(
        prediction_season = dplyr::first(.data$prediction_season),
        rows = dplyr::n(),
        current_avg_projected_games = mean(.data$adjusted_projected_games, na.rm = TRUE),
        current_median_projected_games = stats::median(.data$adjusted_projected_games, na.rm = TRUE),
        current_avg_p50_points = mean(.data$adjusted_p50_points, na.rm = TRUE),
        .groups = "drop"
      ) |>
      dplyr::left_join(
        dplyr::select(
          games_bucket_calibration,
          "position", "rank_bucket",
          "historical_avg_actual_games" = "avg_implied_actual_games",
          "historical_avg_projected_games" = "avg_implied_projected_games",
          "historical_games_calibration_multiplier" = "games_calibration_multiplier"
        ),
        by = c("position", "rank_bucket"),
        relationship = "many-to-one"
      ) |>
      dplyr::mutate(
        current_minus_historical_actual_games =
          .data$current_avg_projected_games - .data$historical_avg_actual_games,
        current_pct_games_vs_historical_actual = dplyr::if_else(
          abs(.data$historical_avg_actual_games) > 0.0001,
          .data$current_minus_historical_actual_games / abs(.data$historical_avg_actual_games),
          NA_real_
        ),
        suggested_games_multiplier = dplyr::if_else(
          abs(.data$current_avg_projected_games) > 0.0001,
          .data$historical_avg_actual_games / .data$current_avg_projected_games,
          NA_real_
        ),
        current_games_status = dplyr::case_when(
          !is.finite(.data$current_pct_games_vs_historical_actual) ~ "insufficient_historical_games_baseline",
          .data$current_pct_games_vs_historical_actual >= 0.10 ~ "current_too_many_games_vs_history",
          .data$current_pct_games_vs_historical_actual <= -0.10 ~ "current_too_few_games_vs_history",
          TRUE ~ "current_games_in_line"
        )
      ) |>
      dplyr::arrange(.data$position, .data$bucket_min)
  }

  if (isTRUE(write_output)) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    sos_try_write_csv(
      historical_games,
      file.path(output_dir, "core_sos_projected_games_calibration_rows_2023_2025.csv")
    )
    sos_try_write_csv(
      games_bucket_calibration,
      file.path(output_dir, "core_sos_projected_games_bucket_calibration_2023_2025.csv")
    )
    sos_try_write_csv(
      games_curve_shape,
      file.path(output_dir, "core_sos_projected_games_curve_shape_2023_2025.csv")
    )
    sos_try_write_csv(
      current_games_comparison,
      file.path(output_dir, paste0("core_sos_projected_games_current_vs_history_", prediction_season, ".csv"))
    )
  }

  out <- list(
    historical_rows = historical_games,
    bucket_calibration = games_bucket_calibration,
    curve_shape = games_curve_shape,
    current_games_comparison = current_games_comparison
  )
  assign("core_sos_projected_games_calibration", out, envir = .GlobalEnv)
  invisible(out)
}

sos_games_floor_policy <- function(board) {
  load_model_core_packages()
  n <- nrow(board)
  if (is.null(board) || n == 0L) {
    return(data.frame(
      games_floor_article_like = logical(0),
      games_floor_risk_evidence = logical(0),
      games_floor_min_games = numeric(0),
      games_floor_reason = character(0),
      stringsAsFactors = FALSE
    ))
  }

  get_num <- function(name, default = NA_real_) {
    if (name %in% names(board)) {
      return(safe_numeric(board[[name]]))
    }
    rep(default, n)
  }
  get_chr <- function(name, default = "") {
    if (name %in% names(board)) {
      return(tolower(as.character(board[[name]])))
    }
    rep(default, n)
  }
  get_flag <- function(name, default = FALSE) {
    if (name %in% names(board)) {
      return(dplyr::coalesce(as.logical(board[[name]]), default))
    }
    rep(default, n)
  }

  position <- toupper(as.character(board$position))
  note <- get_chr("manual_context_note")
  channel <- get_chr("adjustment_channel")
  rank_reference <- dplyr::coalesce(
    get_num("article_rank"),
    get_num("manual_adjusted_projection_rank"),
    get_num("baseline_projection_rank"),
    get_num("rank")
  )
  article_like <- is.finite(rank_reference) & rank_reference <= sos_article_rank_limit(position)

  active_pool <- if ("active_projection_pool" %in% names(board)) {
    get_flag("active_projection_pool", TRUE)
  } else {
    rep(TRUE, n)
  }
  manual_games_delta <- get_num("manual_games_delta", 0)
  manual_injury_risk <- get_num("manual_injury_risk", 0)
  projection_role_uncertainty <- get_flag("projection_context_role_uncertainty", FALSE)
  projection_depth_uncertain <- get_flag("projection_context_depth_uncertain", FALSE)
  depth_team <- get_num("depth_team_2026", NA_real_)

  removed_note <- grepl(
    "remove|inactive|out for season|will not play|won't play|not in the nfl|no longer in the league|unsigned",
    note
  )
  risk_note <- grepl(
    paste(
      "injur", "recover", "limited", "questionable", "holdout", "suspend", "broken",
      "health", "medical", "foot", "knee", "hamstring", "committee", "competition", "backup", "handcuff",
      "third string", "3rd string", "fourth string", "4th string", "not named",
      "may not start", "could play", "if .* not ready", sep = "|"
    ),
    note
  )
  clear_full_season_note <- grepl(
    "locked starter|clear starter|starting qb|starter for|lead back|full season|17 games|starting kicker",
    note
  )
  risk_channel <- grepl("injury|games|role|depth|uncertainty|availability", channel)

  risk_evidence <- removed_note |
    risk_note |
    risk_channel |
    projection_role_uncertainty |
    projection_depth_uncertain |
    (!is.na(depth_team) & depth_team >= 3) |
    (is.finite(manual_games_delta) & manual_games_delta < -0.05) |
    (is.finite(manual_injury_risk) & manual_injury_risk > 0.05)

  min_games <- dplyr::case_when(
    position == "DST" ~ 17,
    !active_pool | removed_note ~ 0,
    risk_evidence & article_like & position == "QB" ~ 12,
    risk_evidence & article_like & position %in% c("RB", "WR", "TE") ~ 13,
    risk_evidence & article_like & position == "K" ~ 13,
    risk_evidence ~ 0,
    article_like | clear_full_season_note ~ 16,
    TRUE ~ 0
  )
  max_boost <- dplyr::case_when(
    position == "DST" ~ 17,
    !active_pool | removed_note ~ 0,
    risk_evidence & article_like & position == "QB" ~ 2.00,
    risk_evidence & article_like & position %in% c("RB", "WR", "TE") ~ 1.75,
    risk_evidence & article_like & position == "K" ~ 2.00,
    risk_evidence ~ 0,
    clear_full_season_note & position == "QB" ~ 2.00,
    clear_full_season_note & position %in% c("RB", "WR", "TE") ~ 1.75,
    clear_full_season_note & position == "K" ~ 2.00,
    clear_full_season_note ~ 2.00,
    article_like & position %in% c("QB", "RB", "WR", "TE") ~ 1.25,
    article_like & position == "K" ~ 1.50,
    TRUE ~ 0
  )
  reason <- dplyr::case_when(
    position == "DST" ~ "dst_team_unit_locked_17_games",
    !active_pool | removed_note ~ "inactive_or_removed_no_floor",
    risk_evidence & article_like ~ "risk_adjusted_article_pool_soft_floor",
    risk_evidence ~ "risk_signal_allows_games_calibration",
    clear_full_season_note ~ "explicit_full_season_min_16_games",
    min_games >= 16 ~ "healthy_article_pool_soft_min_16_games",
    TRUE ~ "no_games_floor"
  )

  data.frame(
    games_floor_article_like = article_like,
    games_floor_risk_evidence = risk_evidence,
    games_floor_min_games = min_games,
    games_floor_max_boost = max_boost,
    games_floor_reason = reason,
    stringsAsFactors = FALSE
  )
}

sos_apply_games_calibration_to_projection_board <- function(
    board,
    games_calibration,
    blend_weight = 0.50,
    min_rows = 12L,
    min_multiplier = 0.80,
    max_multiplier = 1.10,
    promote_adjusted_fields = FALSE
) {
  load_model_core_packages()
  blend_weight <- pmin(1, pmax(0, safe_numeric(blend_weight)[[1]]))
  min_rows <- as.integer(min_rows[[1]])
  min_multiplier <- safe_numeric(min_multiplier)[[1]]
  max_multiplier <- safe_numeric(max_multiplier)[[1]]

  rank_bucket_fields <- function(position, projected_rank) {
    position <- toupper(as.character(position))
    projected_rank <- safe_numeric(projected_rank)
    bucket_min <- dplyr::case_when(
      position == "QB" & projected_rank <= 6 ~ 1,
      position == "QB" & projected_rank <= 12 ~ 7,
      position == "QB" & projected_rank <= 18 ~ 13,
      position == "QB" & projected_rank <= 24 ~ 19,
      position == "QB" & projected_rank <= 36 ~ 25,
      position == "QB" ~ 37,
      position %in% c("RB", "WR") & projected_rank <= 12 ~ 1,
      position %in% c("RB", "WR") & projected_rank <= 24 ~ 13,
      position %in% c("RB", "WR") & projected_rank <= 36 ~ 25,
      position %in% c("RB", "WR") & projected_rank <= 48 ~ 37,
      position %in% c("RB", "WR") & projected_rank <= 60 ~ 49,
      position %in% c("RB", "WR") ~ 61,
      position == "TE" & projected_rank <= 6 ~ 1,
      position == "TE" & projected_rank <= 12 ~ 7,
      position == "TE" & projected_rank <= 18 ~ 13,
      position == "TE" & projected_rank <= 24 ~ 19,
      position == "TE" & projected_rank <= 36 ~ 25,
      position == "TE" ~ 37,
      position %in% c("K", "DST") & projected_rank <= 6 ~ 1,
      position %in% c("K", "DST") & projected_rank <= 12 ~ 7,
      position %in% c("K", "DST") & projected_rank <= 18 ~ 13,
      position %in% c("K", "DST") & projected_rank <= 24 ~ 19,
      position %in% c("K", "DST") & projected_rank <= 32 ~ 25,
      position %in% c("K", "DST") ~ 33,
      TRUE ~ NA_real_
    )
    bucket_max <- dplyr::case_when(
      position == "QB" & bucket_min == 1 ~ 6,
      position == "QB" & bucket_min == 7 ~ 12,
      position == "QB" & bucket_min == 13 ~ 18,
      position == "QB" & bucket_min == 19 ~ 24,
      position == "QB" & bucket_min == 25 ~ 36,
      position == "QB" & bucket_min == 37 ~ 999,
      position %in% c("RB", "WR") & bucket_min == 1 ~ 12,
      position %in% c("RB", "WR") & bucket_min == 13 ~ 24,
      position %in% c("RB", "WR") & bucket_min == 25 ~ 36,
      position %in% c("RB", "WR") & bucket_min == 37 ~ 48,
      position %in% c("RB", "WR") & bucket_min == 49 ~ 60,
      position %in% c("RB", "WR") & bucket_min == 61 ~ 999,
      position == "TE" & bucket_min == 1 ~ 6,
      position == "TE" & bucket_min == 7 ~ 12,
      position == "TE" & bucket_min == 13 ~ 18,
      position == "TE" & bucket_min == 19 ~ 24,
      position == "TE" & bucket_min == 25 ~ 36,
      position == "TE" & bucket_min == 37 ~ 999,
      position %in% c("K", "DST") & bucket_min == 1 ~ 6,
      position %in% c("K", "DST") & bucket_min == 7 ~ 12,
      position %in% c("K", "DST") & bucket_min == 13 ~ 18,
      position %in% c("K", "DST") & bucket_min == 19 ~ 24,
      position %in% c("K", "DST") & bucket_min == 25 ~ 32,
      position %in% c("K", "DST") & bucket_min == 33 ~ 999,
      TRUE ~ NA_real_
    )
    data.frame(
      rank_bucket = dplyr::case_when(
        !is.finite(bucket_min) ~ NA_character_,
        bucket_max >= 999 ~ paste0(as.integer(bucket_min), "+"),
        TRUE ~ paste0(as.integer(bucket_min), "-", as.integer(bucket_max))
      ),
      bucket_min = bucket_min,
      bucket_max = bucket_max,
      stringsAsFactors = FALSE
    )
  }

  required <- c(
    "position", "adjusted_projected_games", "adjusted_projected_ppg",
    "adjusted_p10_points", "adjusted_p25_points", "adjusted_p50_points",
    "adjusted_p75_points", "adjusted_p90_points"
  )
  missing <- setdiff(required, names(board))
  if (length(missing) > 0L) {
    stop("Projection board is missing games-calibration columns: ", paste(missing, collapse = ", "), call. = FALSE)
  }

  calibration_lookup <- games_calibration$bucket_calibration |>
    dplyr::select(
      "position", "rank_bucket",
      "historical_games_rows" = "rows",
      "historical_avg_actual_games" = "avg_implied_actual_games",
      "historical_avg_projected_games" = "avg_implied_projected_games",
      "historical_games_calibration_multiplier" = "games_calibration_multiplier",
      "historical_games_curve_status" = "games_curve_status"
    )

  out <- board |>
    dplyr::mutate(
      position = toupper(as.character(.data$position)),
      adjusted_projected_games = safe_numeric(.data$adjusted_projected_games),
      adjusted_projected_ppg = safe_numeric(.data$adjusted_projected_ppg),
      adjusted_p10_points = safe_numeric(.data$adjusted_p10_points),
      adjusted_p25_points = safe_numeric(.data$adjusted_p25_points),
      adjusted_p50_points = safe_numeric(.data$adjusted_p50_points),
      adjusted_p75_points = safe_numeric(.data$adjusted_p75_points),
      adjusted_p90_points = safe_numeric(.data$adjusted_p90_points)
    ) |>
    dplyr::group_by(.data$position) |>
    dplyr::arrange(dplyr::desc(.data$adjusted_p50_points), .by_group = TRUE) |>
    dplyr::mutate(games_calibration_input_total_rank = dplyr::row_number()) |>
    dplyr::ungroup()

  out <- dplyr::bind_cols(
    out,
    rank_bucket_fields(out$position, out$games_calibration_input_total_rank)
  ) |>
    dplyr::left_join(
      calibration_lookup,
      by = c("position", "rank_bucket"),
      relationship = "many-to-one"
    )

  out <- dplyr::bind_cols(out, sos_games_floor_policy(out)) |>
    dplyr::mutate(
      games_calibration_raw_multiplier = dplyr::case_when(
        .data$position == "DST" ~ 1,
        !is.finite(.data$historical_games_calibration_multiplier) ~ 1,
        .data$historical_games_rows < .env$min_rows ~ 1,
        TRUE ~ .data$historical_games_calibration_multiplier
      ),
      games_calibration_capped_multiplier = pmin(
        .env$max_multiplier,
        pmax(.env$min_multiplier, .data$games_calibration_raw_multiplier)
      ),
      games_calibration_blended_multiplier =
        1 + .env$blend_weight * (.data$games_calibration_capped_multiplier - 1),
      games_calibrated_projected_games_raw = dplyr::case_when(
        .data$position == "DST" ~ 17,
        TRUE ~ pmin(17, pmax(1, .data$adjusted_projected_games * .data$games_calibration_blended_multiplier))
      ),
      games_floor_target_games = dplyr::case_when(
        .data$position == "DST" ~ 17,
        TRUE ~ pmin(17, pmax(.data$games_floor_min_games, .data$games_calibrated_projected_games_raw))
      ),
      games_floor_boost_used = pmin(
        .data$games_floor_max_boost,
        pmax(0, .data$games_floor_target_games - .data$games_calibrated_projected_games_raw)
      ),
      games_calibrated_projected_games = dplyr::case_when(
        .data$position == "DST" ~ 17,
        TRUE ~ pmin(17, .data$games_calibrated_projected_games_raw + .data$games_floor_boost_used)
      ),
      games_calibration_floor_applied =
        .data$games_calibrated_projected_games > .data$games_calibrated_projected_games_raw + 0.0001,
      games_calibration_dst_full_season_applied =
        .data$position == "DST" &
          abs(.data$games_calibrated_projected_games - .data$adjusted_projected_games) > 0.0001,
      games_calibration_applied =
        abs(.data$games_calibration_blended_multiplier - 1) > 0.0001 |
          .data$games_calibration_floor_applied |
          .data$games_calibration_dst_full_season_applied,
      games_calibrated_p10_points = dplyr::if_else(
        .data$adjusted_projected_games > 0,
        .data$adjusted_p10_points * .data$games_calibrated_projected_games / .data$adjusted_projected_games,
        .data$adjusted_p10_points
      ),
      games_calibrated_p25_points = dplyr::if_else(
        .data$adjusted_projected_games > 0,
        .data$adjusted_p25_points * .data$games_calibrated_projected_games / .data$adjusted_projected_games,
        .data$adjusted_p25_points
      ),
      games_calibrated_p50_points = dplyr::if_else(
        .data$adjusted_projected_games > 0,
        .data$adjusted_p50_points * .data$games_calibrated_projected_games / .data$adjusted_projected_games,
        .data$adjusted_p50_points
      ),
      games_calibrated_p75_points = dplyr::if_else(
        .data$adjusted_projected_games > 0,
        .data$adjusted_p75_points * .data$games_calibrated_projected_games / .data$adjusted_projected_games,
        .data$adjusted_p75_points
      ),
      games_calibrated_p90_points = dplyr::if_else(
        .data$adjusted_projected_games > 0,
        .data$adjusted_p90_points * .data$games_calibrated_projected_games / .data$adjusted_projected_games,
        .data$adjusted_p90_points
      ),
      games_calibrated_projected_ppg = dplyr::if_else(
        .data$games_calibrated_projected_games > 0,
        .data$games_calibrated_p50_points / .data$games_calibrated_projected_games,
        .data$adjusted_projected_ppg
      ),
      games_calibrated_points_delta =
        .data$games_calibrated_p50_points - .data$adjusted_p50_points,
      games_calibrated_games_delta =
        .data$games_calibrated_projected_games - .data$adjusted_projected_games
    ) |>
    dplyr::group_by(.data$position) |>
    dplyr::arrange(dplyr::desc(.data$games_calibrated_p50_points), .by_group = TRUE) |>
    dplyr::mutate(games_calibrated_total_rank = dplyr::row_number()) |>
    dplyr::ungroup()

  summary <- out |>
    dplyr::group_by(.data$position, .data$rank_bucket, .data$historical_games_curve_status) |>
    dplyr::summarise(
      rows = dplyr::n(),
      calibrated_rows = sum(.data$games_calibration_applied, na.rm = TRUE),
      games_floor_rows = sum(.data$games_calibration_floor_applied, na.rm = TRUE),
      avg_games_floor_boost = mean(.data$games_floor_boost_used, na.rm = TRUE),
      max_games_floor_boost = max(.data$games_floor_boost_used, na.rm = TRUE),
      avg_games_before = mean(.data$adjusted_projected_games, na.rm = TRUE),
      avg_games_after = mean(.data$games_calibrated_projected_games, na.rm = TRUE),
      avg_games_delta = mean(.data$games_calibrated_games_delta, na.rm = TRUE),
      avg_p50_before = mean(.data$adjusted_p50_points, na.rm = TRUE),
      avg_p50_after = mean(.data$games_calibrated_p50_points, na.rm = TRUE),
      avg_p50_delta = mean(.data$games_calibrated_points_delta, na.rm = TRUE),
      .groups = "drop"
    ) |>
    dplyr::arrange(.data$position, .data$rank_bucket)

  audit <- out |>
    dplyr::group_by(.data$position) |>
    dplyr::summarise(
      rows = dplyr::n(),
      calibrated_rows = sum(.data$games_calibration_applied, na.rm = TRUE),
      games_floor_rows = sum(.data$games_calibration_floor_applied, na.rm = TRUE),
      dst_full_season_rows = sum(.data$games_calibration_dst_full_season_applied, na.rm = TRUE),
      risk_evidence_rows = sum(.data$games_floor_risk_evidence, na.rm = TRUE),
      avg_games_floor_boost = mean(.data$games_floor_boost_used, na.rm = TRUE),
      max_games_floor_boost = max(.data$games_floor_boost_used, na.rm = TRUE),
      missing_calibration = sum(is.na(.data$historical_games_calibration_multiplier), na.rm = TRUE),
      games_out_of_bounds = sum(
        !is.finite(.data$games_calibrated_projected_games) |
          .data$games_calibrated_projected_games < 1 |
          .data$games_calibrated_projected_games > 17,
        na.rm = TRUE
      ),
      range_order_violations = sum(
        .data$games_calibrated_p10_points > .data$games_calibrated_p25_points |
          .data$games_calibrated_p25_points > .data$games_calibrated_p50_points |
          .data$games_calibrated_p50_points > .data$games_calibrated_p75_points |
          .data$games_calibrated_p75_points > .data$games_calibrated_p90_points,
        na.rm = TRUE
      ),
      max_abs_games_delta = max(abs(.data$games_calibrated_games_delta), na.rm = TRUE),
      avg_abs_points_delta = mean(abs(.data$games_calibrated_points_delta), na.rm = TRUE),
      unlabeled_games_changes = sum(
        abs(.data$games_calibrated_games_delta) > 0.0001 &
          !.data$games_calibration_applied,
        na.rm = TRUE
      ),
      status = dplyr::case_when(
        .data$games_out_of_bounds > 0 ~ "FAIL",
        .data$range_order_violations > 0 ~ "FAIL",
        .data$unlabeled_games_changes > 0 ~ "FAIL",
        TRUE ~ "PASS"
      ),
      .groups = "drop"
    )

  if (isTRUE(promote_adjusted_fields)) {
    out <- out |>
      dplyr::mutate(
        pre_games_calibration_projected_games = .data$adjusted_projected_games,
        pre_games_calibration_projected_ppg = .data$adjusted_projected_ppg,
        pre_games_calibration_p10_points = .data$adjusted_p10_points,
        pre_games_calibration_p25_points = .data$adjusted_p25_points,
        pre_games_calibration_p50_points = .data$adjusted_p50_points,
        pre_games_calibration_p75_points = .data$adjusted_p75_points,
        pre_games_calibration_p90_points = .data$adjusted_p90_points,
        adjusted_projected_games = .data$games_calibrated_projected_games,
        adjusted_projected_ppg = .data$games_calibrated_projected_ppg,
        adjusted_p10_points = .data$games_calibrated_p10_points,
        adjusted_p25_points = .data$games_calibrated_p25_points,
        adjusted_p50_points = .data$games_calibrated_p50_points,
        adjusted_p75_points = .data$games_calibrated_p75_points,
        adjusted_p90_points = .data$games_calibrated_p90_points,
        adjusted_average_range_score = (
          .data$adjusted_p25_points + .data$adjusted_p50_points + .data$adjusted_p75_points
        ) / 3
      ) |>
      dplyr::group_by(.data$position) |>
      dplyr::arrange(dplyr::desc(.data$adjusted_average_range_score), .by_group = TRUE) |>
      dplyr::mutate(
        manual_adjusted_projection_rank = rank(
          -.data$adjusted_average_range_score,
          ties.method = "first",
          na.last = "keep"
        ),
        manual_adjusted_projection_rank_delta =
          .data$baseline_projection_rank - .data$manual_adjusted_projection_rank
      ) |>
      dplyr::ungroup()
  }

  out <- out |>
    dplyr::arrange(.data$position, .data$games_calibrated_total_rank)

  list(board = out, summary = summary, audit = audit)
}

build_core_sos_games_calibrated_projection_board <- function(
    prediction_season = 2026L,
    blend_weight = 0.50,
    min_rows = 12L,
    min_multiplier = 0.80,
    max_multiplier = 1.10,
    write_output = TRUE,
    output_dir = sos_production_output_dir()
) {
  load_model_core_packages()
  prediction_season <- as.integer(prediction_season[[1]])
  blend_weight <- pmin(1, pmax(0, safe_numeric(blend_weight)[[1]]))
  min_rows <- as.integer(min_rows[[1]])
  min_multiplier <- safe_numeric(min_multiplier)[[1]]
  max_multiplier <- safe_numeric(max_multiplier)[[1]]

  games_cal <- build_core_sos_projected_games_calibration(
    prediction_season = prediction_season,
    write_output = write_output,
    output_dir = output_dir
  )

  projection_path <- file.path(output_dir, paste0("core_sos_projection_board_", prediction_season, ".csv"))
  if (!file.exists(projection_path)) {
    stop("Projection board does not exist yet: ", projection_path, call. = FALSE)
  }

  board <- read_csv_flexible(projection_path) |>
    dplyr::mutate(
      position = toupper(as.character(.data$position)),
      adjusted_projected_games = safe_numeric(.data$adjusted_projected_games),
      adjusted_projected_ppg = safe_numeric(.data$adjusted_projected_ppg),
      adjusted_p10_points = safe_numeric(.data$adjusted_p10_points),
      adjusted_p25_points = safe_numeric(.data$adjusted_p25_points),
      adjusted_p50_points = safe_numeric(.data$adjusted_p50_points),
      adjusted_p75_points = safe_numeric(.data$adjusted_p75_points),
      adjusted_p90_points = safe_numeric(.data$adjusted_p90_points)
    ) |>
    dplyr::group_by(.data$position) |>
    dplyr::arrange(dplyr::desc(.data$adjusted_p50_points), .by_group = TRUE) |>
    dplyr::mutate(games_calibration_input_total_rank = dplyr::row_number()) |>
    dplyr::ungroup()

  rank_bucket_fields <- function(position, projected_rank) {
    position <- toupper(as.character(position))
    projected_rank <- safe_numeric(projected_rank)
    bucket_min <- dplyr::case_when(
      position == "QB" & projected_rank <= 6 ~ 1,
      position == "QB" & projected_rank <= 12 ~ 7,
      position == "QB" & projected_rank <= 18 ~ 13,
      position == "QB" & projected_rank <= 24 ~ 19,
      position == "QB" & projected_rank <= 36 ~ 25,
      position == "QB" ~ 37,
      position %in% c("RB", "WR") & projected_rank <= 12 ~ 1,
      position %in% c("RB", "WR") & projected_rank <= 24 ~ 13,
      position %in% c("RB", "WR") & projected_rank <= 36 ~ 25,
      position %in% c("RB", "WR") & projected_rank <= 48 ~ 37,
      position %in% c("RB", "WR") & projected_rank <= 60 ~ 49,
      position %in% c("RB", "WR") ~ 61,
      position == "TE" & projected_rank <= 6 ~ 1,
      position == "TE" & projected_rank <= 12 ~ 7,
      position == "TE" & projected_rank <= 18 ~ 13,
      position == "TE" & projected_rank <= 24 ~ 19,
      position == "TE" & projected_rank <= 36 ~ 25,
      position == "TE" ~ 37,
      position %in% c("K", "DST") & projected_rank <= 6 ~ 1,
      position %in% c("K", "DST") & projected_rank <= 12 ~ 7,
      position %in% c("K", "DST") & projected_rank <= 18 ~ 13,
      position %in% c("K", "DST") & projected_rank <= 24 ~ 19,
      position %in% c("K", "DST") & projected_rank <= 32 ~ 25,
      position %in% c("K", "DST") ~ 33,
      TRUE ~ NA_real_
    )
    bucket_max <- dplyr::case_when(
      position == "QB" & bucket_min == 1 ~ 6,
      position == "QB" & bucket_min == 7 ~ 12,
      position == "QB" & bucket_min == 13 ~ 18,
      position == "QB" & bucket_min == 19 ~ 24,
      position == "QB" & bucket_min == 25 ~ 36,
      position == "QB" & bucket_min == 37 ~ 999,
      position %in% c("RB", "WR") & bucket_min == 1 ~ 12,
      position %in% c("RB", "WR") & bucket_min == 13 ~ 24,
      position %in% c("RB", "WR") & bucket_min == 25 ~ 36,
      position %in% c("RB", "WR") & bucket_min == 37 ~ 48,
      position %in% c("RB", "WR") & bucket_min == 49 ~ 60,
      position %in% c("RB", "WR") & bucket_min == 61 ~ 999,
      position == "TE" & bucket_min == 1 ~ 6,
      position == "TE" & bucket_min == 7 ~ 12,
      position == "TE" & bucket_min == 13 ~ 18,
      position == "TE" & bucket_min == 19 ~ 24,
      position == "TE" & bucket_min == 25 ~ 36,
      position == "TE" & bucket_min == 37 ~ 999,
      position %in% c("K", "DST") & bucket_min == 1 ~ 6,
      position %in% c("K", "DST") & bucket_min == 7 ~ 12,
      position %in% c("K", "DST") & bucket_min == 13 ~ 18,
      position %in% c("K", "DST") & bucket_min == 19 ~ 24,
      position %in% c("K", "DST") & bucket_min == 25 ~ 32,
      position %in% c("K", "DST") & bucket_min == 33 ~ 999,
      TRUE ~ NA_real_
    )
    data.frame(
      rank_bucket = dplyr::case_when(
        !is.finite(bucket_min) ~ NA_character_,
        bucket_max >= 999 ~ paste0(as.integer(bucket_min), "+"),
        TRUE ~ paste0(as.integer(bucket_min), "-", as.integer(bucket_max))
      ),
      bucket_min = bucket_min,
      bucket_max = bucket_max,
      stringsAsFactors = FALSE
    )
  }

  board <- dplyr::bind_cols(
    board,
    rank_bucket_fields(board$position, board$games_calibration_input_total_rank)
  )

  calibration_lookup <- games_cal$bucket_calibration |>
    dplyr::select(
      "position", "rank_bucket",
      "historical_games_rows" = "rows",
      "historical_avg_actual_games" = "avg_implied_actual_games",
      "historical_avg_projected_games" = "avg_implied_projected_games",
      "historical_games_calibration_multiplier" = "games_calibration_multiplier",
      "historical_games_curve_status" = "games_curve_status"
    )

  out <- board |>
    dplyr::left_join(
      calibration_lookup,
      by = c("position", "rank_bucket"),
      relationship = "many-to-one"
    )

  out <- dplyr::bind_cols(out, sos_games_floor_policy(out)) |>
    dplyr::mutate(
      games_calibration_raw_multiplier = dplyr::case_when(
        .data$position == "DST" ~ 1,
        !is.finite(.data$historical_games_calibration_multiplier) ~ 1,
        .data$historical_games_rows < .env$min_rows ~ 1,
        TRUE ~ .data$historical_games_calibration_multiplier
      ),
      games_calibration_capped_multiplier = pmin(
        .env$max_multiplier,
        pmax(.env$min_multiplier, .data$games_calibration_raw_multiplier)
      ),
      games_calibration_blended_multiplier =
        1 + .env$blend_weight * (.data$games_calibration_capped_multiplier - 1),
      games_calibrated_projected_games_raw = dplyr::case_when(
        .data$position == "DST" ~ 17,
        TRUE ~ pmin(17, pmax(0, .data$adjusted_projected_games * .data$games_calibration_blended_multiplier))
      ),
      games_floor_target_games = dplyr::case_when(
        .data$position == "DST" ~ 17,
        TRUE ~ pmin(17, pmax(.data$games_floor_min_games, .data$games_calibrated_projected_games_raw))
      ),
      games_floor_boost_used = pmin(
        .data$games_floor_max_boost,
        pmax(0, .data$games_floor_target_games - .data$games_calibrated_projected_games_raw)
      ),
      games_calibrated_projected_games = dplyr::case_when(
        .data$position == "DST" ~ 17,
        TRUE ~ pmin(17, .data$games_calibrated_projected_games_raw + .data$games_floor_boost_used)
      ),
      games_calibration_floor_applied =
        .data$games_calibrated_projected_games > .data$games_calibrated_projected_games_raw + 0.0001,
      games_calibration_applied =
        abs(.data$games_calibration_blended_multiplier - 1) > 0.0001 |
          .data$games_calibration_floor_applied,
      games_calibrated_p10_points = dplyr::if_else(
        .data$adjusted_projected_games > 0,
        .data$adjusted_p10_points * .data$games_calibrated_projected_games / .data$adjusted_projected_games,
        .data$adjusted_p10_points
      ),
      games_calibrated_p25_points = dplyr::if_else(
        .data$adjusted_projected_games > 0,
        .data$adjusted_p25_points * .data$games_calibrated_projected_games / .data$adjusted_projected_games,
        .data$adjusted_p25_points
      ),
      games_calibrated_p50_points = dplyr::if_else(
        .data$adjusted_projected_games > 0,
        .data$adjusted_p50_points * .data$games_calibrated_projected_games / .data$adjusted_projected_games,
        .data$adjusted_p50_points
      ),
      games_calibrated_p75_points = dplyr::if_else(
        .data$adjusted_projected_games > 0,
        .data$adjusted_p75_points * .data$games_calibrated_projected_games / .data$adjusted_projected_games,
        .data$adjusted_p75_points
      ),
      games_calibrated_p90_points = dplyr::if_else(
        .data$adjusted_projected_games > 0,
        .data$adjusted_p90_points * .data$games_calibrated_projected_games / .data$adjusted_projected_games,
        .data$adjusted_p90_points
      ),
      games_calibrated_projected_ppg = dplyr::if_else(
        .data$games_calibrated_projected_games > 0,
        .data$games_calibrated_p50_points / .data$games_calibrated_projected_games,
        .data$adjusted_projected_ppg
      ),
      games_calibrated_points_delta =
        .data$games_calibrated_p50_points - .data$adjusted_p50_points,
      games_calibrated_games_delta =
        .data$games_calibrated_projected_games - .data$adjusted_projected_games
    ) |>
    dplyr::group_by(.data$position) |>
    dplyr::arrange(dplyr::desc(.data$games_calibrated_p50_points), .by_group = TRUE) |>
    dplyr::mutate(games_calibrated_total_rank = dplyr::row_number()) |>
    dplyr::ungroup() |>
    dplyr::arrange(.data$position, .data$games_calibrated_total_rank)

  summary <- out |>
    dplyr::group_by(.data$position, .data$rank_bucket, .data$historical_games_curve_status) |>
    dplyr::summarise(
      rows = dplyr::n(),
      calibrated_rows = sum(.data$games_calibration_applied, na.rm = TRUE),
      games_floor_rows = sum(.data$games_calibration_floor_applied, na.rm = TRUE),
      avg_games_floor_boost = mean(.data$games_floor_boost_used, na.rm = TRUE),
      max_games_floor_boost = max(.data$games_floor_boost_used, na.rm = TRUE),
      avg_games_before = mean(.data$adjusted_projected_games, na.rm = TRUE),
      avg_games_after = mean(.data$games_calibrated_projected_games, na.rm = TRUE),
      avg_games_delta = mean(.data$games_calibrated_games_delta, na.rm = TRUE),
      avg_p50_before = mean(.data$adjusted_p50_points, na.rm = TRUE),
      avg_p50_after = mean(.data$games_calibrated_p50_points, na.rm = TRUE),
      avg_p50_delta = mean(.data$games_calibrated_points_delta, na.rm = TRUE),
      .groups = "drop"
    ) |>
    dplyr::arrange(.data$position, .data$rank_bucket)

  audit <- out |>
    dplyr::group_by(.data$position) |>
    dplyr::summarise(
      rows = dplyr::n(),
      calibrated_rows = sum(.data$games_calibration_applied, na.rm = TRUE),
      games_floor_rows = sum(.data$games_calibration_floor_applied, na.rm = TRUE),
      risk_evidence_rows = sum(.data$games_floor_risk_evidence, na.rm = TRUE),
      avg_games_floor_boost = mean(.data$games_floor_boost_used, na.rm = TRUE),
      max_games_floor_boost = max(.data$games_floor_boost_used, na.rm = TRUE),
      missing_calibration = sum(is.na(.data$historical_games_calibration_multiplier), na.rm = TRUE),
      games_out_of_bounds = sum(
        !is.finite(.data$games_calibrated_projected_games) |
          .data$games_calibrated_projected_games < 0 |
          .data$games_calibrated_projected_games > 17,
        na.rm = TRUE
      ),
      range_order_violations = sum(
        .data$games_calibrated_p10_points > .data$games_calibrated_p25_points |
          .data$games_calibrated_p25_points > .data$games_calibrated_p50_points |
          .data$games_calibrated_p50_points > .data$games_calibrated_p75_points |
          .data$games_calibrated_p75_points > .data$games_calibrated_p90_points,
        na.rm = TRUE
      ),
      max_abs_games_delta = max(abs(.data$games_calibrated_games_delta), na.rm = TRUE),
      avg_abs_points_delta = mean(abs(.data$games_calibrated_points_delta), na.rm = TRUE),
      status = dplyr::case_when(
        .data$games_out_of_bounds > 0 ~ "FAIL",
        .data$range_order_violations > 0 ~ "FAIL",
        TRUE ~ "PASS"
      ),
      .groups = "drop"
    )

  if (isTRUE(write_output)) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    sos_try_write_csv(
      out,
      file.path(output_dir, paste0("core_sos_games_calibrated_projection_board_", prediction_season, ".csv"))
    )
    sos_try_write_csv(
      summary,
      file.path(output_dir, paste0("core_sos_games_calibrated_projection_summary_", prediction_season, ".csv"))
    )
    sos_try_write_csv(
      audit,
      file.path(output_dir, paste0("core_sos_games_calibrated_projection_audit_", prediction_season, ".csv"))
    )
  }

  result <- list(board = out, summary = summary, audit = audit, games_calibration = games_cal)
  assign("core_sos_games_calibrated_projection_board", result, envir = .GlobalEnv)
  invisible(result)
}

publish_core_sos_production_console <- function(result, top_n = 10L) {
  cat("\nSOS production audit\n")
  print(as.data.frame(result$audit), row.names = FALSE)
  if (!is.null(result$projection_layer)) {
    publish_core_sos_projection_console(result$projection_layer, top_n = top_n)
    if (!is.null(result$projection_layer$manual_rank_context)) {
      cat("\nSOS manual-rank match audit\n")
      print(as.data.frame(result$projection_layer$manual_rank_context$audit), row.names = FALSE)
    }
  }
  cat("\nPublished SOS artifacts\n")
  print(
    as.data.frame(result$manifest[c("position", "artifact", "output_path", "exists")]),
    row.names = FALSE
  )
  invisible(result)
}

write_core_sos_manual_rank_templates <- function(
    board,
    prediction_season = 2026L,
    output_dir = sos_production_output_dir(),
    overwrite = FALSE
) {
  load_model_core_packages()
  prediction_season <- as.integer(prediction_season[[1]])
  stat_cols <- grep("^projected_", names(board), value = TRUE)
  review_cols <- unique(c(
    "position", "prediction_season", "player_key", "player",
    "current_team", "next_team", "official_omfg",
    "manual_adjusted_model_rank", "manual_adjusted_projection_rank",
    "baseline_model_rank", "baseline_projection_rank",
    "market_position_rank", "market_context_rank",
    "adjusted_projected_games", "adjusted_projected_ppg",
    "adjusted_p10_points", "adjusted_p25_points", "adjusted_p50_points",
    "adjusted_p75_points", "adjusted_p90_points",
    "stat_implied_fantasy_points_after", "stat_alignment_status",
    "stat_alignment_points_gap", stat_cols
  ))
  template <- board |>
    dplyr::select(dplyr::any_of(review_cols))
  if ("manual_adjusted_model_rank" %in% names(template)) {
    names(template)[names(template) == "manual_adjusted_model_rank"] <- "model_omfg_rank"
  } else if ("baseline_model_rank" %in% names(template)) {
    names(template)[names(template) == "baseline_model_rank"] <- "model_omfg_rank"
  }
  if ("manual_adjusted_projection_rank" %in% names(template)) {
    names(template)[names(template) == "manual_adjusted_projection_rank"] <- "model_projection_rank"
  } else if ("baseline_projection_rank" %in% names(template)) {
    names(template)[names(template) == "baseline_projection_rank"] <- "model_projection_rank"
  }
  template <- template |>
    dplyr::select(
      -dplyr::any_of(c("baseline_model_rank", "baseline_projection_rank"))
    ) |>
    dplyr::mutate(
      manual_rank = NA_integer_,
      manual_confidence = NA_real_,
      manual_rank_note = "",
      manual_rank_enabled = FALSE
    ) |>
    dplyr::arrange(
      factor(.data$position, levels = c("QB", "RB", "WR", "TE", "K", "DST")),
      .data$model_projection_rank,
      .data$player
    )

  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
  write_refreshed_template <- function(x, path) {
    manual_rows_preserved <- 0L
    if (!isTRUE(overwrite) && file.exists(path)) {
      existing <- utils::read.csv(path, stringsAsFactors = FALSE, check.names = FALSE)
      if (!"player_key" %in% names(existing) && "player" %in% names(existing)) {
        existing$player_key <- make_player_key(existing$player)
      }
      if (all(c("position", "player_key") %in% names(existing))) {
        new_key <- paste(x$position, x$player_key, sep = "|")
        old_key <- paste(existing$position, existing$player_key, sep = "|")
        matched <- match(new_key, old_key)
        has_match <- !is.na(matched)
        if ("manual_rank" %in% names(existing)) {
          saved <- suppressWarnings(as.integer(existing$manual_rank[matched]))
          keep <- has_match & is.finite(saved)
          x$manual_rank[keep] <- saved[keep]
        }
        if ("manual_confidence" %in% names(existing)) {
          saved <- suppressWarnings(as.numeric(existing$manual_confidence[matched]))
          keep <- has_match & is.finite(saved)
          x$manual_confidence[keep] <- pmin(1, pmax(0, saved[keep]))
        }
        if ("manual_rank_note" %in% names(existing)) {
          saved <- as.character(existing$manual_rank_note[matched])
          keep <- has_match & !is.na(saved)
          x$manual_rank_note[keep] <- saved[keep]
        }
        if ("manual_rank_enabled" %in% names(existing)) {
          saved <- sos_context_enabled(existing$manual_rank_enabled[matched])
          keep <- has_match & !is.na(saved)
          x$manual_rank_enabled[keep] <- saved[keep]
        }
        manual_rows_preserved <- sum(
          is.finite(suppressWarnings(as.numeric(x$manual_rank))) |
            is.finite(suppressWarnings(as.numeric(x$manual_confidence))) |
            nzchar(trimws(as.character(x$manual_rank_note))) |
            dplyr::coalesce(as.logical(x$manual_rank_enabled), FALSE),
          na.rm = TRUE
        )
      }
    }
    sos_try_write_csv(x, path)
    list(
      data = x,
      manifest = data.frame(
        position = if (length(unique(x$position)) == 1L) unique(x$position) else "ALL",
        output_path = path,
        exists = file.exists(path),
        refreshed = TRUE,
        manual_rows_preserved = as.integer(manual_rows_preserved),
        stringsAsFactors = FALSE
      )
    )
  }

  master_path <- file.path(
    output_dir,
    paste0("core_sos_model_only_manual_rank_template_", prediction_season, ".csv")
  )
  master_write <- write_refreshed_template(template, master_path)
  template <- master_write$data
  manifest <- list(master_write$manifest)
  for (position in c("QB", "RB", "WR", "TE", "K", "DST")) {
    position_path <- file.path(
      output_dir,
      paste0(tolower(position), "_sos_model_only_manual_rank_template_", prediction_season, ".csv")
    )
    position_write <- write_refreshed_template(
      template[template$position == position, , drop = FALSE],
      position_path
    )
    manifest[[length(manifest) + 1L]] <- position_write$manifest
  }
  result <- list(template = template, manifest = dplyr::bind_rows(manifest))
  assign("core_sos_manual_rank_templates", result, envir = .GlobalEnv)
  invisible(result)
}

run_core_sos_projection_layer <- function(
    production_master,
    prediction_season = 2026L,
    manual_context_file = sos_manual_context_path(prediction_season),
    apply_manual_context = FALSE,
    apply_market_context = TRUE,
    market_context_file = sos_default_market_adp_path(prediction_season),
    apply_manual_ranks = TRUE,
    manual_rank_dir = sos_default_manual_rank_dir(prediction_season),
    manual_rank_weight = 0.30,
    manual_rank_default_confidence = 0.75,
    manual_rank_max_projection_pct = 0.08,
    simulation_count = 4000L,
    apply_games_calibration = TRUE,
    games_calibration_blend_weight = 0.50,
    games_calibration_min_rows = 12L,
    games_calibration_min_multiplier = 0.80,
    games_calibration_max_multiplier = 1.10,
    apply_projection_context_calibration = TRUE,
    apply_final_review_context = TRUE,
    apply_range_sanity = TRUE,
    write_output = TRUE,
    output_dir = sos_production_output_dir(),
    publish_console = TRUE,
    console_top_n = 10L
) {
  load_model_core_packages()
  prediction_season <- as.integer(prediction_season[[1]])
  context <- if (isTRUE(apply_manual_context)) {
    read_sos_manual_context(prediction_season, manual_context_file)
  } else {
    sos_empty_manual_context(prediction_season)
  }
  backtest <- build_core_sos_projection_backtest(unique(as.character(production_master$position)))
  board <- sos_build_unadjusted_projection_board(production_master, backtest, prediction_season)
  board <- sos_simulate_projection_finishes(
    board, "baseline",
    "baseline_p10_points", "baseline_p50_points", "baseline_p90_points",
    simulation_count
  )
  if (isTRUE(apply_market_context)) {
    board <- sos_apply_adp_market_context(
      board,
      prediction_season = prediction_season,
      market_path = market_context_file
    )
    board <- sos_simulate_projection_finishes(
      board, "baseline",
      "baseline_p10_points", "baseline_p50_points", "baseline_p90_points",
      simulation_count
    )
  }
  board <- sos_apply_manual_context(board, context)
  manual_rank_context <- NULL
  if (isTRUE(apply_manual_ranks)) {
    manual_rank_context <- sos_apply_manual_rank_context(
      board,
      prediction_season = prediction_season,
      manual_rank_dir = manual_rank_dir,
      manual_rank_weight = manual_rank_weight,
      default_confidence = manual_rank_default_confidence,
      max_projection_pct = manual_rank_max_projection_pct
    )
    if (any(manual_rank_context$audit$status != "PASS")) {
      failed_positions <- manual_rank_context$audit$position[
        manual_rank_context$audit$status != "PASS"
      ]
      stop(
        "SOS manual-rank audit failed for: ",
        paste(failed_positions, collapse = ", "),
        ". Inspect core_sos_manual_rank_match_audit.",
        call. = FALSE
      )
    }
    board <- manual_rank_context$board
    assign("core_sos_manual_rank_match_audit", manual_rank_context$audit, envir = .GlobalEnv)
  }
  k_starter_context <- sos_apply_k_starter_depth_chart(
    board,
    prediction_season = prediction_season
  )
  if (nrow(k_starter_context$audit) > 0L && any(k_starter_context$audit$status != "PASS")) {
    assign("core_sos_k_starter_depth_audit", k_starter_context$audit, envir = .GlobalEnv)
    assign("core_sos_k_starter_depth_missing", k_starter_context$missing_starters, envir = .GlobalEnv)
    stop(
      "SOS kicker starter-depth audit failed. Inspect core_sos_k_starter_depth_audit and ",
      "core_sos_k_starter_depth_missing.",
      call. = FALSE
    )
  }
  board <- k_starter_context$board
  assign("core_sos_k_starter_depth_audit", k_starter_context$audit, envir = .GlobalEnv)
  assign("core_sos_k_starter_depth_missing", k_starter_context$missing_starters, envir = .GlobalEnv)
  if (isTRUE(write_output) && nrow(k_starter_context$audit) > 0L) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    sos_try_write_csv(
      k_starter_context$audit,
      file.path(output_dir, paste0("core_sos_k_starter_depth_audit_", prediction_season, ".csv"))
    )
    sos_try_write_csv(
      k_starter_context$missing_starters,
      file.path(output_dir, paste0("core_sos_k_starter_depth_missing_", prediction_season, ".csv"))
    )
  }
  games_calibration <- NULL
  games_calibrated_projection <- NULL
  if (isTRUE(apply_games_calibration)) {
    games_calibration_input_path <- tempfile(fileext = ".csv")
    utils::write.csv(board, games_calibration_input_path, row.names = FALSE, na = "")
    on.exit(unlink(games_calibration_input_path), add = TRUE)
    games_calibration <- build_core_sos_projected_games_calibration(
      prediction_season = prediction_season,
      current_projection_path = games_calibration_input_path,
      write_output = write_output,
      output_dir = output_dir
    )
    games_calibrated_projection <- sos_apply_games_calibration_to_projection_board(
      board,
      games_calibration,
      blend_weight = games_calibration_blend_weight,
      min_rows = games_calibration_min_rows,
      min_multiplier = games_calibration_min_multiplier,
      max_multiplier = games_calibration_max_multiplier,
      promote_adjusted_fields = TRUE
    )
    board <- games_calibrated_projection$board
  }
  projection_context_audit <- NULL
  if (isTRUE(apply_projection_context_calibration)) {
    board <- sos_apply_projection_context_calibration(board)
    projection_context_audit <- build_core_sos_projection_context_audit(board, prediction_season)
  }
  qb_final_review_projection_audit <- NULL
  rb_final_review_projection_audit <- NULL
  wr_final_review_projection_audit <- NULL
  te_final_review_projection_audit <- NULL
  dst_final_review_projection_audit <- NULL
  nfl_context_brief_audit <- NULL
  if (isTRUE(apply_final_review_context)) {
    board <- sos_apply_qb_final_review_projection_context(board, prediction_season)
    qb_final_review_projection_audit <-
      build_core_sos_qb_final_review_projection_audit(board, prediction_season)
    if (any(qb_final_review_projection_audit$status != "PASS")) {
      stop("QB final-review projection context audit failed.", call. = FALSE)
    }
    board <- sos_apply_rb_final_review_projection_context(board, prediction_season)
    rb_final_review_projection_audit <-
      build_core_sos_rb_final_review_projection_audit(board, prediction_season)
    if (any(rb_final_review_projection_audit$status != "PASS")) {
      stop("RB final-review projection context audit failed.", call. = FALSE)
    }
    board <- sos_apply_wr_final_review_projection_context(board, prediction_season)
    wr_final_review_projection_audit <-
      build_core_sos_wr_final_review_projection_audit(board, prediction_season)
    if (any(wr_final_review_projection_audit$status != "PASS")) {
      stop("WR final-review projection context audit failed.", call. = FALSE)
    }
    board <- sos_apply_te_final_review_projection_context(board, prediction_season)
    te_final_review_projection_audit <-
      build_core_sos_te_final_review_projection_audit(board, prediction_season)
    if (any(te_final_review_projection_audit$status != "PASS")) {
      stop("TE final-review projection context audit failed.", call. = FALSE)
    }
    board <- sos_apply_dst_final_review_projection_context(board, prediction_season)
    dst_final_review_projection_audit <-
      build_core_sos_dst_final_review_projection_audit(board, prediction_season)
    if (any(dst_final_review_projection_audit$status != "PASS")) {
      stop("DST final-review projection context audit failed.", call. = FALSE)
    }
  }
  nfl_context_brief <- sos_apply_nfl_context_brief(board, prediction_season)
  board <- nfl_context_brief$board
  nfl_context_brief_audit <- nfl_context_brief$audit
  assign("core_sos_nfl_context_brief_audit", nfl_context_brief_audit, envir = .GlobalEnv)
  if (isTRUE(write_output) && nrow(nfl_context_brief_audit) > 0L) {
    sos_try_write_csv(
      nfl_context_brief_audit,
      file.path(output_dir, paste0("core_sos_nfl_context_brief_audit_", prediction_season, ".csv"))
    )
  }
  range_sanity_audit <- NULL
  if (isTRUE(apply_range_sanity)) {
    board <- sos_apply_projection_range_sanity(board)
    range_sanity_audit <- build_core_sos_range_sanity_audit(board, prediction_season)
  }
  board <- sos_apply_projection_pool_flags(board)
  board <- sos_simulate_projection_finishes(
    board, "adjusted",
    "adjusted_p10_points", "adjusted_p50_points", "adjusted_p90_points",
    simulation_count
  )
  stat_projection <- build_core_sos_stat_projection_layer(
    board,
    prediction_season = prediction_season,
    backtest = backtest,
    write_output = write_output,
    output_dir = output_dir
  )
  if (!is.null(stat_projection$board) && nrow(stat_projection$board) > 0L) {
    board <- stat_projection$board
    if (
      !is.null(stat_projection$final_review_stat_promotion_audit) &&
        any(stat_projection$final_review_stat_promotion_audit$status != "PASS")
    ) {
      stop("Final-review stat promotion audit failed.", call. = FALSE)
    }
    board <- sos_simulate_projection_finishes(
      board, "adjusted",
      "adjusted_p10_points", "adjusted_p50_points", "adjusted_p90_points",
      simulation_count
    )
  }
  if (!is.null(stat_projection$wide) && nrow(stat_projection$wide) > 0L) {
    stat_cols <- grep("^projected_", names(stat_projection$wide), value = TRUE)
    stat_meta_cols <- grep(
      "^(stat_target_p50_points|stat_implied_fantasy_points|stat_alignment|stat_reconciliation_abs_delta|stat_reconciliation_gap_ratio|stat_reconciliation_context_sensitive|stat_reconciliation_severe_gap|stat_reconciliation_applied|stat_reconciliation_multiplier|stat_profile_protected_cols|stat_reconciliation_allowed_cols|stat_reconciliation_blocked_cols|stat_missing_base_seeded|stat_residual_bridge|dst_final_review_stat)",
      names(stat_projection$wide),
      value = TRUE
    )
    board <- board |>
      dplyr::left_join(
        stat_projection$wide |>
          dplyr::select(
            "position", "prediction_season", "player_key",
            dplyr::all_of(unique(c(stat_cols, stat_meta_cols)))
          ),
        by = c("position", "prediction_season", "player_key"),
        relationship = "one-to-one"
      )
  }
  manual_rank_templates <- if (!isTRUE(apply_manual_context) && isTRUE(write_output)) {
    write_core_sos_manual_rank_templates(
      board,
      prediction_season = prediction_season,
      output_dir = output_dir,
      overwrite = FALSE
    )
  } else {
    NULL
  }
  market_context_ledger <- if ("market_context_pct" %in% names(board)) {
    board |>
      dplyr::select(
        dplyr::any_of(c(
          "position", "prediction_season", "player_key", "player", "current_team",
          "has_market_rank", "market_position_rank", "market_overall_rank",
          "market_avg_adp", "market_context_rank", "market_context_score",
          "market_context_rank_delta_vs_projection", "market_projection_rank_gap",
          "pre_market_projection_rank", "baseline_projection_rank",
          "pre_market_projected_games", "baseline_projected_games",
          "pre_market_projected_ppg", "baseline_projected_ppg",
          "pre_market_p10_points", "baseline_p10_points",
          "pre_market_p25_points", "baseline_p25_points",
          "pre_market_p50_points", "baseline_p50_points",
          "pre_market_p75_points", "baseline_p75_points",
          "pre_market_p90_points", "baseline_p90_points",
          "market_context_pct", "market_context_applied", "market_context_note"
        ))
      ) |>
      dplyr::arrange(.data$position, .data$baseline_projection_rank)
  } else {
    data.frame()
  }
  ledger <- sos_build_context_ledger(context, board, prediction_season)
  audit <- build_core_sos_projection_audit(board, context, prediction_season)
  assign("core_sos_projection_audit", audit, envir = .GlobalEnv)
  if (any(audit$status != "PASS")) {
    failed_audit <- audit[audit$status != "PASS", , drop = FALSE]
    stop(
      "SOS projection audit failed for: ",
      paste(failed_audit$position, collapse = ", "),
      ". Inspect core_sos_projection_audit for the failed checks.",
      call. = FALSE
    )
  }
  editorial_shell <- board |>
    dplyr::select(
      "position", "prediction_season", "player", "current_team",
      model_rank = "baseline_model_rank",
      manual_adjusted_model_rank = "manual_adjusted_model_rank",
      projection_rank = "manual_adjusted_projection_rank",
      rank_delta = "manual_adjusted_rank_delta",
      projection_rank_delta = "manual_adjusted_projection_rank_delta",
      OMFG = "official_omfg",
      average_range_score = "adjusted_average_range_score",
      P10 = "adjusted_p10_points",
      P25 = "adjusted_p25_points",
      P50 = "adjusted_p50_points",
      P75 = "adjusted_p75_points",
      P90 = "adjusted_p90_points",
      dplyr::starts_with("stat_alignment_"),
      dplyr::any_of(c(
        "stat_implied_fantasy_points_after",
        "stat_reconciliation_abs_delta_after"
      )),
      dplyr::starts_with("projected_"),
      "manual_context_note",
      dplyr::starts_with("adjusted_sim_prob_")
    ) |>
    dplyr::mutate(user_final_rank = NA_integer_, user_notes = "")

  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    sos_try_write_csv(
      board,
      file.path(output_dir, paste0("core_sos_projection_board_", prediction_season, ".csv"))
    )
    if (!isTRUE(apply_manual_context)) {
      sos_try_write_csv(
        board,
        file.path(output_dir, paste0("core_sos_model_only_projection_board_", prediction_season, ".csv"))
      )
    }
    sos_try_write_csv(
      market_context_ledger,
      file.path(output_dir, paste0("core_sos_market_context_ledger_", prediction_season, ".csv"))
    )
    sos_try_write_csv(
      ledger,
      file.path(output_dir, paste0("core_sos_manual_context_ledger_", prediction_season, ".csv"))
    )
    sos_try_write_csv(
      backtest$predictions,
      file.path(output_dir, "core_sos_projection_backtest_predictions_2023_2025.csv")
    )
    sos_try_write_csv(
      backtest$metrics,
      file.path(output_dir, "core_sos_projection_backtest_metrics_2023_2025.csv")
    )
    sos_try_write_csv(
      backtest$selection,
      file.path(output_dir, "core_sos_projection_model_selection_2023_2025.csv")
    )
    sos_try_write_csv(
      audit,
      file.path(output_dir, paste0("core_sos_projection_audit_", prediction_season, ".csv"))
    )
    sos_try_write_csv(
      editorial_shell,
      file.path(output_dir, paste0("core_sos_editorial_rank_shell_", prediction_season, ".csv"))
    )
    if (!is.null(games_calibrated_projection)) {
      sos_try_write_csv(
        games_calibrated_projection$board,
        file.path(output_dir, paste0("core_sos_games_calibrated_projection_board_", prediction_season, ".csv"))
      )
      sos_try_write_csv(
        games_calibrated_projection$summary,
        file.path(output_dir, paste0("core_sos_games_calibrated_projection_summary_", prediction_season, ".csv"))
      )
      sos_try_write_csv(
        games_calibrated_projection$audit,
        file.path(output_dir, paste0("core_sos_games_calibrated_projection_audit_", prediction_season, ".csv"))
      )
    }
    if (!is.null(range_sanity_audit)) {
      sos_try_write_csv(
        range_sanity_audit,
        file.path(output_dir, paste0("core_sos_range_sanity_audit_", prediction_season, ".csv"))
      )
    }
    if (!is.null(projection_context_audit)) {
      sos_try_write_csv(
        projection_context_audit,
        file.path(output_dir, paste0("core_sos_projection_context_audit_", prediction_season, ".csv"))
      )
    }
    if (!is.null(qb_final_review_projection_audit)) {
      sos_try_write_csv(
        qb_final_review_projection_audit,
        file.path(output_dir, paste0("core_sos_qb_final_review_projection_audit_", prediction_season, ".csv"))
      )
    }
    if (!is.null(rb_final_review_projection_audit)) {
      sos_try_write_csv(
        rb_final_review_projection_audit,
        file.path(output_dir, paste0("core_sos_rb_final_review_projection_audit_", prediction_season, ".csv"))
      )
    }
    if (!is.null(wr_final_review_projection_audit)) {
      sos_try_write_csv(
        wr_final_review_projection_audit,
        file.path(output_dir, paste0("core_sos_wr_final_review_projection_audit_", prediction_season, ".csv"))
      )
    }
    if (!is.null(te_final_review_projection_audit)) {
      sos_try_write_csv(
        te_final_review_projection_audit,
        file.path(output_dir, paste0("core_sos_te_final_review_projection_audit_", prediction_season, ".csv"))
      )
    }
    if (!is.null(dst_final_review_projection_audit)) {
      sos_try_write_csv(
        dst_final_review_projection_audit,
        file.path(output_dir, paste0("core_sos_dst_final_review_projection_audit_", prediction_season, ".csv"))
      )
    }
    if (!is.null(manual_rank_context)) {
      sos_try_write_csv(
        manual_rank_context$board,
        file.path(output_dir, paste0("core_sos_manual_rank_blend_board_", prediction_season, ".csv"))
      )
      sos_try_write_csv(
        manual_rank_context$audit,
        file.path(output_dir, paste0("core_sos_manual_rank_match_audit_", prediction_season, ".csv"))
      )
      sos_try_write_csv(
        manual_rank_context$source_manifest,
        file.path(output_dir, paste0("core_sos_manual_rank_source_manifest_", prediction_season, ".csv"))
      )
      sos_try_write_csv(
        manual_rank_context$unmatched_source,
        file.path(output_dir, paste0("core_sos_manual_rank_unmatched_source_", prediction_season, ".csv"))
      )
      sos_try_write_csv(
        manual_rank_context$unmatched_board,
        file.path(output_dir, paste0("core_sos_manual_rank_unmatched_board_", prediction_season, ".csv"))
      )
      sos_try_write_csv(
        manual_rank_context$source_only_seeded,
        file.path(output_dir, paste0("core_sos_manual_rank_source_only_seeded_", prediction_season, ".csv"))
      )
      sos_try_write_csv(
        manual_rank_context$omitted_model_players,
        file.path(output_dir, paste0("core_sos_manual_rank_omitted_model_players_", prediction_season, ".csv"))
      )
    }
  }

  result <- list(
    prediction_season = prediction_season,
    apply_manual_context = isTRUE(apply_manual_context),
    apply_manual_ranks = isTRUE(apply_manual_ranks),
    context = context,
    board = board,
    manual_rank_context = manual_rank_context,
    market_context_ledger = market_context_ledger,
    ledger = ledger,
    backtest = backtest,
    stat_projection = stat_projection,
    k_starter_context = k_starter_context,
    manual_rank_templates = manual_rank_templates,
    games_calibration = games_calibration,
    games_calibrated_projection = games_calibrated_projection,
    projection_context_audit = projection_context_audit,
    qb_final_review_projection_audit = qb_final_review_projection_audit,
    rb_final_review_projection_audit = rb_final_review_projection_audit,
    wr_final_review_projection_audit = wr_final_review_projection_audit,
    te_final_review_projection_audit = te_final_review_projection_audit,
    dst_final_review_projection_audit = dst_final_review_projection_audit,
    range_sanity_audit = range_sanity_audit,
    audit = audit,
    editorial_shell = editorial_shell
  )
  assign("core_sos_projection_layer", result, envir = .GlobalEnv)
  if (isTRUE(publish_console)) {
    publish_core_sos_projection_console(result, top_n = console_top_n)
  }
  result
}

run_core_sos_production <- function(
    prediction_season = 2026L,
    positions = c("QB", "RB", "WR", "TE", "K", "DST"),
    write_output = TRUE,
    output_dir = sos_production_output_dir(),
    reuse_existing = FALSE,
    build_projection_layer = TRUE,
    build_market_rank_review = TRUE,
    build_calibrated_rankings = TRUE,
    manual_context_file = sos_manual_context_path(prediction_season),
    apply_manual_context = FALSE,
    apply_market_context = TRUE,
    market_context_file = sos_default_market_adp_path(prediction_season),
    apply_manual_ranks = TRUE,
    manual_rank_dir = sos_default_manual_rank_dir(prediction_season),
    manual_rank_weight = 0.30,
    manual_rank_default_confidence = 0.75,
    manual_rank_max_projection_pct = 0.08,
    manual_rank_blend_profile = "model_50_manual_30_adp_20",
    availability_guardrail_max_manual_rank_drop = 10L,
    simulation_count = 4000L,
    apply_games_calibration = TRUE,
    games_calibration_blend_weight = 0.50,
    games_calibration_min_rows = 12L,
    games_calibration_min_multiplier = 0.80,
    games_calibration_max_multiplier = 1.10,
    apply_projection_context_calibration = TRUE,
    apply_final_review_context = TRUE,
    apply_range_sanity = TRUE,
    publish_console = TRUE,
    console_top_n = 10L
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
      existing <- utils::read.csv(
        existing_path,
        stringsAsFactors = FALSE,
        check.names = FALSE,
        fileEncoding = "UTF-8-BOM"
      )
      names(existing) <- sub("^\\ufeff", "", names(existing))
      return(existing)
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
      "preseason_omfg", "omfg_rank", "board_score",
      "player_key", "prior_team_2025", "depth_chart_team_2026",
      "depth_team_2026", "depth_ecr_2026", "roster_context_source",
      "is_2026_rookie", "is_new_to_sos_pool",
      probability_cols
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

  projection_layer <- if (isTRUE(build_projection_layer)) {
    run_core_sos_projection_layer(
      master,
      prediction_season = prediction_season,
      manual_context_file = manual_context_file,
      apply_manual_context = apply_manual_context,
      apply_market_context = apply_market_context,
      market_context_file = market_context_file,
      apply_manual_ranks = apply_manual_ranks,
      manual_rank_dir = manual_rank_dir,
      manual_rank_weight = manual_rank_weight,
      manual_rank_default_confidence = manual_rank_default_confidence,
      manual_rank_max_projection_pct = manual_rank_max_projection_pct,
      simulation_count = simulation_count,
      apply_games_calibration = apply_games_calibration,
      games_calibration_blend_weight = games_calibration_blend_weight,
      games_calibration_min_rows = games_calibration_min_rows,
      games_calibration_min_multiplier = games_calibration_min_multiplier,
      games_calibration_max_multiplier = games_calibration_max_multiplier,
      apply_projection_context_calibration = apply_projection_context_calibration,
      apply_final_review_context = apply_final_review_context,
      apply_range_sanity = apply_range_sanity,
      write_output = write_output,
      output_dir = output_dir,
      publish_console = FALSE,
      console_top_n = console_top_n
    )
  } else {
    NULL
  }

  market_rank_review <- if (isTRUE(build_projection_layer) && isTRUE(build_market_rank_review)) {
    build_core_sos_market_rank_review(
      projection_board_path = file.path(output_dir, paste0("core_sos_projection_board_", prediction_season, ".csv")),
      prediction_season = prediction_season,
      market_path = market_context_file,
      manual_rank_blend_profile = manual_rank_blend_profile,
      availability_guardrail_max_manual_rank_drop = availability_guardrail_max_manual_rank_drop,
      output_dir = output_dir,
      write_output = write_output
    )
  } else {
    NULL
  }

  calibrated_rankings <- if (!is.null(market_rank_review) && isTRUE(build_calibrated_rankings)) {
    build_core_sos_calibrated_rankings(
      market_review = market_rank_review,
      prediction_season = prediction_season,
      output_dir = output_dir,
      write_output = write_output
    )
  } else {
    NULL
  }

  editor_exports <- if (!is.null(calibrated_rankings)) {
    build_core_sos_editor_exports(
      calibrated_rankings = calibrated_rankings,
      prediction_season = prediction_season,
      output_dir = sos_editor_output_dir(prediction_season),
      write_output = write_output
    )
  } else {
    NULL
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
  if (isTRUE(build_projection_layer)) {
    manifest <- dplyr::bind_rows(
      manifest,
      data.frame(
          position = rep("CORE", 48L),
          artifact = c(
            "projection_board", "market_context_ledger", "manual_context_ledger", "projection_audit",
            "projection_backtest_predictions", "projection_backtest_metrics",
            "projection_model_selection", "editorial_rank_shell",
            "stat_projection_long", "stat_projection_wide",
            "stat_projection_metrics", "stat_projection_model_selection",
            "stat_projection_reconciliation_audit",
            "final_review_stat_promotion_audit",
            "stat_alignment_review", "stat_alignment_summary",
            "stat_projection_reconciled_backtest_predictions",
            "stat_projection_reconciled_backtest_metrics",
            "stat_projection_reconciliation_impact",
          "games_calibrated_projection_board",
          "games_calibrated_projection_summary",
          "games_calibrated_projection_audit",
           "projection_context_audit",
            "qb_final_review_projection_audit", "rb_final_review_projection_audit",
            "wr_final_review_projection_audit", "te_final_review_projection_audit",
            "dst_final_review_projection_audit", "k_starter_depth_audit",
           "range_sanity_audit",
           "manual_rank_blend_board", "manual_rank_match_audit",
           "manual_rank_source_manifest", "manual_rank_unmatched_source",
           "manual_rank_unmatched_board",
           "manual_rank_source_only_seeded", "manual_rank_omitted_model_players",
           "market_rank_review", "market_rank_review_summary",
          "final_value_rankings", "market_blend_rank_board",
          "manual_rank_blend_profile_comparison", "manual_rank_blend_profile_summary",
          "rank_signal_coherence_detail", "rank_signal_coherence_summary",
          "calibrated_rankings", "calibrated_rankings_summary",
          "article_rankings"
        ),
        output_path = c(
          file.path(output_dir, paste0("core_sos_projection_board_", prediction_season, ".csv")),
          file.path(output_dir, paste0("core_sos_market_context_ledger_", prediction_season, ".csv")),
          file.path(output_dir, paste0("core_sos_manual_context_ledger_", prediction_season, ".csv")),
          file.path(output_dir, paste0("core_sos_projection_audit_", prediction_season, ".csv")),
          file.path(output_dir, "core_sos_projection_backtest_predictions_2023_2025.csv"),
          file.path(output_dir, "core_sos_projection_backtest_metrics_2023_2025.csv"),
          file.path(output_dir, "core_sos_projection_model_selection_2023_2025.csv"),
          file.path(output_dir, paste0("core_sos_editorial_rank_shell_", prediction_season, ".csv")),
          file.path(output_dir, paste0("core_sos_stat_projection_long_", prediction_season, ".csv")),
          file.path(output_dir, paste0("core_sos_stat_projection_wide_", prediction_season, ".csv")),
          file.path(output_dir, "core_sos_stat_projection_metrics_2023_2025.csv"),
          file.path(output_dir, "core_sos_stat_projection_model_selection_2023_2025.csv"),
          file.path(output_dir, paste0("core_sos_stat_projection_reconciliation_audit_", prediction_season, ".csv")),
          file.path(output_dir, paste0("core_sos_final_review_stat_promotion_audit_", prediction_season, ".csv")),
          file.path(output_dir, paste0("core_sos_stat_alignment_review_", prediction_season, ".csv")),
          file.path(output_dir, paste0("core_sos_stat_alignment_summary_", prediction_season, ".csv")),
          file.path(output_dir, "core_sos_stat_projection_reconciled_backtest_predictions_2023_2025.csv"),
          file.path(output_dir, "core_sos_stat_projection_reconciled_backtest_metrics_2023_2025.csv"),
          file.path(output_dir, "core_sos_stat_projection_reconciliation_impact_2023_2025.csv"),
          file.path(output_dir, paste0("core_sos_games_calibrated_projection_board_", prediction_season, ".csv")),
          file.path(output_dir, paste0("core_sos_games_calibrated_projection_summary_", prediction_season, ".csv")),
          file.path(output_dir, paste0("core_sos_games_calibrated_projection_audit_", prediction_season, ".csv")),
           file.path(output_dir, paste0("core_sos_projection_context_audit_", prediction_season, ".csv")),
           file.path(output_dir, paste0("core_sos_qb_final_review_projection_audit_", prediction_season, ".csv")),
           file.path(output_dir, paste0("core_sos_rb_final_review_projection_audit_", prediction_season, ".csv")),
           file.path(output_dir, paste0("core_sos_wr_final_review_projection_audit_", prediction_season, ".csv")),
           file.path(output_dir, paste0("core_sos_te_final_review_projection_audit_", prediction_season, ".csv")),
           file.path(output_dir, paste0("core_sos_dst_final_review_projection_audit_", prediction_season, ".csv")),
           file.path(output_dir, paste0("core_sos_k_starter_depth_audit_", prediction_season, ".csv")),
           file.path(output_dir, paste0("core_sos_range_sanity_audit_", prediction_season, ".csv")),
           file.path(output_dir, paste0("core_sos_manual_rank_blend_board_", prediction_season, ".csv")),
           file.path(output_dir, paste0("core_sos_manual_rank_match_audit_", prediction_season, ".csv")),
           file.path(output_dir, paste0("core_sos_manual_rank_source_manifest_", prediction_season, ".csv")),
           file.path(output_dir, paste0("core_sos_manual_rank_unmatched_source_", prediction_season, ".csv")),
           file.path(output_dir, paste0("core_sos_manual_rank_unmatched_board_", prediction_season, ".csv")),
           file.path(output_dir, paste0("core_sos_manual_rank_source_only_seeded_", prediction_season, ".csv")),
           file.path(output_dir, paste0("core_sos_manual_rank_omitted_model_players_", prediction_season, ".csv")),
           file.path(output_dir, paste0("core_sos_market_rank_review_", prediction_season, ".csv")),
          file.path(output_dir, paste0("core_sos_market_rank_review_summary_", prediction_season, ".csv")),
          file.path(output_dir, paste0("core_sos_final_value_rankings_", prediction_season, ".csv")),
          file.path(output_dir, paste0("core_sos_market_blend_rank_board_", prediction_season, ".csv")),
          file.path(output_dir, paste0("core_sos_manual_rank_blend_profile_comparison_", prediction_season, ".csv")),
          file.path(output_dir, paste0("core_sos_manual_rank_blend_profile_summary_", prediction_season, ".csv")),
          file.path(output_dir, paste0("core_sos_rank_signal_coherence_detail_", prediction_season, ".csv")),
          file.path(output_dir, paste0("core_sos_rank_signal_coherence_summary_", prediction_season, ".csv")),
          file.path(output_dir, paste0("core_sos_calibrated_rankings_", prediction_season, ".csv")),
          file.path(output_dir, paste0("core_sos_calibrated_rankings_summary_", prediction_season, ".csv")),
          file.path(output_dir, paste0("core_sos_article_rankings_", prediction_season, ".csv"))
        ),
        stringsAsFactors = FALSE
      )
    )
  }

  if (write_output) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    sos_try_write_csv(
      master,
      file.path(output_dir, paste0("core_sos_production_", prediction_season, ".csv"))
    )
    sos_try_write_csv(
      audit,
      file.path(output_dir, paste0("core_sos_production_audit_", prediction_season, ".csv"))
    )
    manifest$exists <- file.exists(manifest$output_path)
    sos_try_write_csv(
      manifest,
      file.path(output_dir, paste0("core_sos_production_manifest_", prediction_season, ".csv"))
    )
  } else {
    manifest$exists <- NA
  }

  result <- list(
    prediction_season = prediction_season,
    apply_manual_context = isTRUE(apply_manual_context),
    apply_manual_ranks = isTRUE(apply_manual_ranks),
    positions = results,
    master = master,
    audit = audit,
    projection_layer = projection_layer,
    market_rank_review = market_rank_review,
    calibrated_rankings = calibrated_rankings,
    editor_exports = editor_exports,
    manifest = manifest
  )
  assign("core_sos_production", result, envir = .GlobalEnv)
  if (isTRUE(publish_console)) {
    publish_core_sos_production_console(result, top_n = console_top_n)
  }
  result
}

message("SOS probability helper: build_core_sos_tier_probabilities()")
message("SOS probability audit: build_core_sos_probability_lift_audit()")
message("SOS probability walk-forward: run_core_sos_probability_walk_forward()")
message("SOS QB probability calibration: build_qb_sos_probability_calibration_profile()")
message("SOS production runner: run_core_sos_production()")
message("SOS production defaults to model-only projections; set apply_manual_context = TRUE to restore saved manual notes.")
message("SOS production treats the 2026 position manual-rank files as the authoritative player pool by default.")
message("SOS final rank blend defaults to 50% model, 30% manual rank, and 20% ADP; use manual_rank_blend_profile = 'model_55_manual_35_adp_10' for the comparator.")
message("SOS projection runner: run_core_sos_projection_layer()")
message("SOS manual-rank template helper: write_core_sos_manual_rank_templates()")
message("SOS initial projection review: build_core_sos_initial_projection_review()")
message("SOS review-to-context helper: build_sos_manual_context_from_review()")
message("SOS seeded manual context helpers: write_sos_manual_context_seed_files(), build_sos_manual_context_from_seed_files()")
message("SOS stat projection layer: build_core_sos_stat_projection_layer()")
message("SOS editor exports: build_core_sos_editor_exports()")
message("SOS historical editor exports: build_core_sos_historical_editor_exports()")
message("SOS projection rank calibration: build_core_sos_projection_rank_calibration()")
message("SOS projected games calibration: build_core_sos_projected_games_calibration()")
message("SOS games-calibrated projection board: build_core_sos_games_calibrated_projection_board()")
