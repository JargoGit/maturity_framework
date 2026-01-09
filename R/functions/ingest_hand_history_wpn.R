ingest_hand_history_wpn <- function(file_path) {
  lines <- readLines(file_path, warn = FALSE, encoding = "UTF-8")
  
  hand_start_idx <- grep("^Hand #", lines)
  hand_start_idx <- c(hand_start_idx, length(lines) + 1)
  
  hands <- vector("list", length(hand_start_idx) - 1)
  
  for (i in seq_len(length(hands))) {
    start <- hand_start_idx[i]
    end   <- hand_start_idx[i + 1] - 1
    hand_lines <- lines[start:end]
    
    hand_id <- sub("^Hand #(\\S+).*", "\\1", hand_lines[1])
    line_count <- length(hand_lines)
    
    collect_lines <- grep(" collected ", hand_lines, value = TRUE)
    
    collected <- sum(
      as.numeric(
        gsub(".* collected \\$([0-9\\.]+).*", "\\1", collect_lines)
      ),
      na.rm = TRUE
    )
    
    hands[[i]] <- data.frame(
      hand_id = hand_id,
      line_count = line_count,
      collected_amount = collected,
      stringsAsFactors = FALSE
    )
  }
  
  do.call(rbind, hands)
}
