# --------------------------------------------------
# Hand History Ingest
# Source: Raw poker client .txt files (WPN format)
# --------------------------------------------------

ingest_hand_history <- function(file_path) {
  
  # --- safety check ---
  if (!file.exists(file_path)) {
    stop(paste("File not found:", file_path))
  }
  
  # --- read file ---
  lines <- readLines(file_path, warn = FALSE, encoding = "UTF-8")
  
  # --- identify hand boundaries ---
  is_hand_start <- grepl("^Hand #", lines)
  hand_id <- cumsum(is_hand_start)
  
  # --- build data frame ---
  df <- data.frame(
    hand_id = hand_id,
    line = lines,
    stringsAsFactors = FALSE
  )
  
  # keep only valid hands
  df <- df[df$hand_id > 0, , drop = FALSE]
  
  # --- collapse to one row per hand ---
  hands <- aggregate(
    line ~ hand_id,
    data = df,
    FUN = length
  )
  
  colnames(hands) <- c("hand_id", "line_count")
  
  return(hands)
}
