return {
  handler = "side_by_side_handler",
  opts = {
    -- streaming_handler = local_llm_streaming_handler,
    left = {
      focusable = false,
    },
    diagnostic = { vim.diagnostic.severity.WARN, vim.diagnostic.severity.ERROR },
  },
}
