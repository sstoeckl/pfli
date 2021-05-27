# 1. UI ----
ui <- dashboardPage(
  dashboardHeader(title = "Research in Quantitative Finance", titleWidth = 400),
  dashboardSidebar(
    sidebarUserPanel('Michael Hanke',
                     image = 'https://webdocs.uni.li/public/06704467.JPG'
                     #subtitle = a(icon("website"), "Personal Website", href="https://www.uni.li/michael.hanke")
    ),
    sidebarUserPanel('Sebastian Stöckl',
                     image = 'https://webdocs.uni.li/public/01963067.JPG'
                     #subtitle = a(icon("website"), "Personal Website", href="https://www.sebastianstoeckl.com")
    ),
    sidebarMenu(
      hr(),
      menuItem('Model', tabName = 'model', icon = icon('laptop')),
      menuItem('Estimation', tabName = 'estimation', icon = icon('laptop')),
      menuItem('Optimizer', tabName = "optimizer", icon = icon('line-chart'), selected =TRUE),
      #menuItem('Data Explorer', tabName = "explorer", icon = icon('line-chart')),
      menuItem('About us', tabName = 'about', icon = icon('user')),
      menuItem('Disclaimer', tabName = 'footer', icon = icon('file-contract'))
    )
  ),
  dashboardBody(
    tags$head(includeHTML(paste0(hpath,"google-analytics.html"))),
    #useShinyjs(), # just for disabling a button in setup
    tabItems(
      tabItem(tabName = 'model',
              fluidRow(style='padding-right:20px; padding-right:20px; padding-top:5px; padding-bottom:5px',#h1('Election Portfolios'),#h2("Methodology"),
                       h3('Setup'),
                       p("Model Setup will be described here soon."),
                       #br(),
                       #includeHTML(paste0(hpath,"description.html"))
                       #htmlOutput("inc")
                       #withMathJax(includeMarkdown("description.md"))
              )
      ),
      tabItem(tabName = 'estimation',
              fluidRow(style='padding-right:20px; padding-right:20px; padding-top:5px; padding-bottom:5px',#h1('Election Portfolios'),#h2("Methodology"),
                       h3('Estimation'),
                       p("Estimation Methodology will be described here soon."),
                       #br(),
                       #includeHTML(paste0(hpath,"description.html"))
                       #htmlOutput("inc")
                       #withMathJax(includeMarkdown("description.md"))
              )
      ),
      tabItem(tabName = "optimizer",
              fluidRow(style='padding-right:20px; padding-right:20px; padding-top:5px; padding-bottom:5px',h1('Pension Finance in Liechtenstein'),h2("Optimization"),
                       p("Optimal pension Decisions given the Liechtenstein Legislative System.", style = "color:red;font-weight:bold"),
                       column(width=5,
                              fluidRow(
                                conditionalPanel(condition = "input.optimizer == 'setup'", 
                                                 box(title = 'Note', width = 12,
                                                     solidHeader = T, status = 'primary',
                                                     helpText("Please specify your input parameters. Move your Mouse over the input fields to get some explanations.",
                                                              "")
                                                 ),
                                                 box(title="Input Personal Situation", width=12,solidHeader = T, status = 'warning',
                                                     # Input: Simple integer interval ----
                                                     # c1 = 0.07, s11 = 0, s12 = 30000, s2 = 30000, s3 = -2e+05, 
                                                     # w0 = 250000, rho2 = 0.04, rho3 = 0.03, psi = 0.015, beta = 0.5, 
                                                     # ra = 2, delta = 0.01, c2 = 0.08, nu2 = 0.25, 
                                                     # nu3 = 0.25,
                                                     sliderInput("c_age", "Age:",min = 18, max = 60,value = 35),
                                                     bsTooltip("c_age", "This variable specifies the current age of the user in full years (the algorithm assumes that calculation day = birthday).","right", options = list(container = "body")),
                                                     # Input: Simple integer interval ----
                                                     sliderInput("ret_age", "Planned retirement:",min = 60, max = 70,value = 65),
                                                     bsTooltip("ret_age", "The first and most important output variable is the age of retirement. However we do not optimize retirement age at that point and rather let the user choose his/her desired retirement age.","right", options = list(container = "body")),
                                                     radioButtons("gender", "Gender",choices = list("Male" = 0,"Female" = 1),selected = 0),
                                                     bsTooltip("gender", "The user's (tax) gender:","right", options = list(container = "body")),
                                                     numericInput("li", "Income",value = 100000),
                                                     bsTooltip("li", "This variable specifies the gross labor income in the past year (that ends on calculation day/birthday). If the user's labor income changed /is expected to change significantly within the next year, use the new number discounted by 'lg' to create an artificial 'last year income'.","right", options = list(container = "body")),
                                                     sliderInput("lg", "Expected Average Income Growth:", min = 0, max = 0.2,value = 0.01, step = 0.01),
                                                     bsTooltip("lg", "This variables specifies how much more the users expects to earn (on average) every year, after accounting for inflation. So given the users expects his labor income to grow by 2% on average, and the average inflation is expected to be 1%, then lg=0.01.","right", options = list(container = "body")),
                                                     sliderInput("c1", "First Pillar Savings Rate:",min = 0, max = 0.2,value = 0.07, step = 0.01),
                                                     bsTooltip("c1", "This variable determines the fraction of his gross labor income the users saves in the first pillar.","right", options = list(container = "body")),
                                                     sliderInput("s11", "Number of Contribution Years in first Pillar:",min=0,max=60,value=10),
                                                     bsTooltip("s11", "This variable fixes how much the user has already paid into the first pillar. It is a vector consisting of two components: (1) the number of contribution years at 'c_age'.","right", options = list(container = "body")),
                                                     numericInput("s12", "Average Yearly Income when contributing to first pillar:",value = 20000),
                                                     bsTooltip("s12", "This variable fixes how much the user has already paid into the first pillar. It is a vector consisting of two components: (1) above and (2) the historical average yearly income until 'c_age'.","right", options = list(container = "body")),
                                                     sliderInput("c2", "Second Pillar Savings Rate:",min = 0, max = 0.2,value = 0.12, step = 0.01),
                                                     bsTooltip("c2", "This variable determines the fraction of his gross labor income the users saves in the second pillar. Often doubled by the employer (up to 12%).","right", options = list(container = "body")),
                                                     numericInput("s2", "Savings in second Pillar:",value = 20000),
                                                     bsTooltip("s2", "This number fixes the amount of the user’s savings in the second pillar at 'c_age'.","right", options = list(container = "body")),
                                                     numericInput("s3", "Investments in third Pillar:",value = 100000),
                                                     bsTooltip("s3", "The amount of 'liquid wealth', the user has disposable at 'c_age' - assumed to be invested in the third pillar. As we currently do not assume any tax advantage (aka Pillar 3a in Switzerland) - the entire sum can be treated as any investments/free savings that are not dedicated to anything else and therefore saved for retirement (aka Pillar 3b in Switzerland).","right", options = list(container = "body")),
                                                     sliderInput("nu2", "Lumpsum payout of second pillar:",min = 0, max = 1,value = 0.2, step = 0.05),
                                                     bsTooltip("nu2", "How much of the user's second pillar savings to convert to a life-long pension (annuity) at retirement and conversely, how much to pay out as a lumpsum to him/herself. Will be optimized in the future.","right", options = list(container = "body")),
                                                     sliderInput("nu3", "Lumpsum payout of third pillar:",min = 0, max = 1,value = 0.2, step = 0.05),
                                                     bsTooltip("nu3", "How much of the user's third pillar savings to convert to a life-long pension (annuity) at retirement and conversely, how much to pay out as a lumpsum to him/herself.  Will be optimized in the future.","right", options = list(container = "body")),
                                                     numericInput("w0", "Non-disposable wealth:",value = 1000000),
                                                     bsTooltip("w0", "The amount of 'non-liquid wealth', the user has available (e.g. invested in real estate). The assumption is, that this wealth is still available at retirement and stays the same over time (no interest). One does however pay wealth taxes for it.","right", options = list(container = "body")),
                                                     sliderInput("beta", "Bequest utility weight:",min = 0, max = 1,value = 0.5, step = 0.01),
                                                     bsTooltip("beta", "How important is it for the user to leave something to his/her heirs (bequest)?","right", options = list(container = "body")),
                                                     sliderInput("ra", "Risk aversion:",min = 0, max = 50,value = 5, step = 0.5),
                                                     bsTooltip("ra", "The parameter of risk aversion of the user.","right", options = list(container = "body")),
                                                     sliderInput("delta", "Time preference:",min = 0, max = 1,value = 0.02, step = 0.01),
                                                     bsTooltip("delta", "This variable gives the time preference of the user to determine whether it is more important to consume now or later.","right", options = list(container = "body")),
                                                 ),
                                                 box(title = 'Settings given by your Pension Funds', width = 12,solidHeader = F, collapsible = TRUE, collapsed = TRUE,status="danger",
                                                     sliderInput("rho2", "Conversion factor in the second pillar:",min = 0.01, max = 0.1,value = 0.04, step = 0.005),
                                                     bsTooltip("rho2", "The conversion factor in second pillar given regular retirement age. Can be taken from the second pillar documents provided to the user.","right", options = list(container = "body")),
                                                     sliderInput("rho3", "Conversion factor in the third pillar:",min = 0.01, max = 0.1,value = 0.04, step = 0.005),
                                                     bsTooltip("rho3", "The conversion factor for the piece of the wealth in the third pillar that the user decides to put into a pension insurance (given by 'nu3') at retirement.","right", options = list(container = "body")),
                                                     sliderInput("psi", "Spread for shorting:",min = 0.01, max = 0.1,value = 0.015, step = 0.001),
                                                     bsTooltip("psi", "The spread to pay on interest when borrowing rather than saving.","right", options = list(container = "body"))
                                                 )
                                                 )#,
                                # conditionalPanel(condition = "input.optimizer == 'output'", 
                                #                  box(title = 'Note', width = 12,
                                #                      solidHeader = T, status = 'primary',
                                #                      helpText("Here you can find your interpolated optimal Pension Decisions. Please handle with care, as this is not directly optimized but interpolated from optimal decisions for similar settings.",
                                #                               "")
                                #                  ))
                                )),
                       column(width = 7,
                              tabBox(id="optimizer",title = tagList(shiny::icon("line-chart"), "Stocks"), width = 12,
                                     tabPanel(id="setup",value="setup",'Output',
                                              fluidRow(column(width = 12,
                                                              textOutput('pct'),br(),
                                                              tableOutput('opti') %>% withSpinner(type = 3,color.background = "white")
                                                              
                                              )
                                              )
                                     )
                              )
                       )
              )
      ),
      ## 1.2. Data Explorer ----
      tabItem(tabName = "explorer",
              fluidRow(style='padding-right:20px; padding-right:20px; padding-top:5px; padding-bottom:5px',h1('Pension Finance in Liechtenstein'),h2("Data Analysis"),
                       p("Analysieren Sie bitte hier unsere Daten.", style = "color:red;font-weight:bold"),
                       column(width=3,
                              fluidRow(
                                conditionalPanel(condition = "input.explorer == 'analyse1'", 
                                                 box(title = 'Note', width = 12,
                                                     solidHeader = T, status = 'primary',
                                                     helpText("Hier können Sie Werte festlegen.",
                                                              "")
                                                 )),
                                conditionalPanel(condition = "input.explorer == 'analyse2'", 
                                                 box(title = 'Note', width = 12,
                                                     solidHeader = T, status = 'primary',
                                                     helpText("Hier finden Sie ihre optimierte Vorsorgeempfehlung.",
                                                              "")
                                                 )))),
                       column(width = 9,
                              tabBox(id="explorer",title = tagList(shiny::icon("line-chart"), "Stocks"), width = 12,
                                     tabPanel(id="analyse1",value="analyse1",'Analyse 1',
                                              fluidRow(
                                              )
                                     ),
                                     tabPanel(id="analyse2",value="analyse2",'Analyse 2',
                                              fluidRow(
                                              )
                                     )
                              )
                       )
              )
      ),
      # tabItem(tabName = 'research',
      #         fluidRow(style='padding-right:20px; padding-right:20px; padding-top:5px; padding-bottom:5px',h1('Election Portfolios'),h2("Research on"),
      #                  "TBS"
      #                  # includeHTML("research.html")
      #         )
      # ),
      tabItem(tabName = 'about',
              fluidRow(style='padding-right:20px; padding-right:20px; padding-top:5px; padding-bottom:5px',h1('Pension Finance in Liechtenstein'),h2("About us"),
                       box(title = "Michael Hanke",
                           status = "primary",
                           solidHeader = F,
                           collapsible = F,
                           width = 12,
                           fluidRow(column(width = 10, a('Prof. Dr. Michael Hanke', href='https://www.uni.li/michael.hanke'),
                                           " received his doctoral degree and habilitation from WU (Vienna), and is a Certified Financial Risk Manager (FRM). His research interests are in quantitative finance, exchange rates, stochastic optimization, scenario generation, and pension finance. He has published in leading finance, economics and operations research journals. He is chairman of the board of a pension fund and a board member of two fund management companies. " ),
                                    column(width = 2, align = "right",
                                           img(src="http://pensionsineurope.eu/wp-content/uploads/2016/10/Michael.Hanke_.43sw_v3-225x300.jpg", width=100)))),
                       box(title = "Sebastian Stöckl",
                           status = "primary",
                           solidHeader = F,
                           collapsible = F,
                           width = 12,
                           fluidRow(column(width = 10, a('Dr. Sebastian Stöckl', href='https://www.sebastianstoeckl.com'),
                                           " is an Assistant Professor at the Chair in Finance at the University of Liechtenstein.",
                                           "He received his Ph.D. in Economics from the University of Innsbruck and is also the holder of two graduate degrees in Business Administration and Technical Mathematics, both also from the University of Innsbruck.",
                                           "His research interest covers all areas of uncertainty, e.g. (i) parameter uncertainty, (ii) financial uncertainty, (iii) macroeconomic uncertainty ",
                                           a('(also check the corresponding shiny app', href='https://apps.resqfin.com/mfu'),
                                           ") and (iv) political uncertainty and he has published several papers on these topics in Finance and Economics Journals."
                           ),
                           column(width = 2, align = "right",
                                  img(src="http://pensionsineurope.eu/wp-content/uploads/2016/10/Sebastian.Stoeckl.43sw_v2-225x300.jpg", width=100))))
              )
      ),
      tabItem(tabName = 'footer',
              fluidRow(style='padding-right:20px; padding-right:20px; padding-top:5px; padding-bottom:5px',h1('Pension Finance in Liechtenstein'),h2("Disclaimer"),
                       "This website is provided for informational purposes only. The information presented is not intended to provide specific advice or recommendations for any individual or on any specific security, investment product, or trading strategy. It is only intended to make scientific results accessible to a wider audience.",
                       br(),br(),
                       "Nothing on this website constitutes investment advice, performance data or any recommendation that any security, portfolio of securities, investment product, transaction or investment strategy is suitable for any specific person. You should not use the website to make financial decisions and we highly recommended you seek professional advice from someone who is authorised to provide investment advice. Investments in securities involve the risk of loss. Past performance is no guarantee of future results.",
                       br(),br(),br(),br()
                       #h3('Methodology'),
                       #p("Methodology will be described here soon."),
                       #br(),
                       #includeHTML(paste0(hpath,"footer.html")),
                       #br()
                       #withMathJax(includeMarkdown(paste0(hpath,"footer.md")))
              )
      )
    ),br(),br(),br(),br(),br(),br(),
    fluidRow(column(width=3),column(width=6#,
                      #               div(id="disqus_thread",
                      #                   HTML(
                      #                     "<script>
                      # (function() { // DON'T EDIT BELOW THIS LINE
                      # var d = document, s = d.createElement('script');
                      # s.src = 'https://resqfin.disqus.com/embed.js';
                      # s.setAttribute('data-timestamp', +new Date());
                      # (d.head || d.body).appendChild(s);
                      # })();
                      # </script>
                      # <noscript>Please enable JavaScript to view the <a href='https://disqus.com/?ref_noscript'>comments powered by Disqus.</a></noscript>"
                      #                   )
                      #               )
    ),column(width=3))#,
    #div(HTML('<script id="dsq-count-scr" src="resqfin.disqus.com/count.js" async></script>'))
  )
)