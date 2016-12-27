module StringStripHeredoc
  refine String do
    def strip_heredoc
      min = scan(/^[ \t]*(?=\S)/).min
      indent = min ? min.size : 0
      gsub(/^[ \t]{#{indent}}/, '')
    end
  end
end
