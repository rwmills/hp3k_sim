#!/usr/bin/perl
#
# Pascal Parent
# January 2023
#
use POSIX;
use Getopt::Long qw(:config bundling);
use IO::Socket::INET;
use File::Spec;
use lib '.';

$lptype = "default";
$path = ".";
$color = 1;
$font = "Courier12";
$skip = 0;
$wait = 3;
$start_line = 4;
$border_style = 0;
$y_shift = 0;
$bar_height = 0;

$usage =
  "Usage: $0 [OPTION]... [FILE]\n" .
  "With no FILE, or when FILE is -, read standard input.\n" .
  "--lptype       | -l line_printer_type\n" .
  "--color        | -c bar_color, default: $color\n" .
  "    0: borders only, 1: green, 2:blue, 3:orange, 4:gray\n" .
  "--font         | -f font, default: $font\n" .
  "--bar-height   | -h lines_per_bar, default: no bars\n" .
  "--ip           | -i host\n" .
  "--port         | -p port\n" .
  "--tail         | -t tail_file\n" .
  "--system-id    | -s system_ID\n" .
  "--name         | -n printer_name\n" .
  "--path         | -P output_path, default: current directory\n" .
  "--border-style | -S border_style, default: $border_style\n" .
  "    0: normal, 1: first bar is 5 lines, 2: no border\n" .
  "--baselineskip | -k baseline_skip\n" .
  "--start-line   | -L print_start_line_on_page, default: $start_line\n" .
  "--wait         | -w wait_time_to_close_file (in seconds), default: $wait\n" .
  "--y-shift      | -y vertical_bars_and_border_shift, +/- 192 units per line\n" .
  "";

GetOptions(
  'lptype|l=s' => \$lptype,
  'color|c=i' => \$color,
  'font|f=s' => \$font,
  'bar-height|h=i' => \$bar_height,
  'ip|i=s' => \$ip,
  'port|p=i' => \$port,
  'tail|t' => \$pipe,
  'system-id|s=s' => \$sysid,
  'name|n=s' => \$prtname,
  'path|P=s' => \$path,
  'border-style|S=i' => \$border_style,
  'skip|k=i' => \$skip,
  'start_line|L=i' => \$start_line,
  'wait|w=i' => \$wait,
  'y-shift|y=i' => \$y_shift
  ) || die $usage;

if (@ARGV > 1) {
  die $usage;
  } # end-if

($perlvol, $perldir, $perlfile) = File::Spec->splitpath(__FILE__);

require $perldir . "elp-$lptype.pl";

$infile = $ARGV[0];
$pagelength = 66;
$tmp = "/tmp";
$lqsz = 300;

if ($ip && $infile) {
  print "Cannot specify both host and input file\n";
  exit;
  } # end-if

$bar = "";

if ($bar_height) {
  $bar = " -H" . ($bar_height + 10 * $border_style + 1000 * ($y_shift + 500));
  } # end-if

if ($ip) {
  $print_in = IO::Socket::INET->new(
    Proto => "tcp",
    PeerAddr => $ip,
    PeerPort => $port,
    Blocking => 1
    ) # end-new
  or die "cannot connect to host: $!";
  binmode($print_in);
  } # end-if

else {

  if ($pipe) {
    open($print_in, "tail -c0 -f $infile|") || die "can't tail on $infile: $!";
    } # end-if

  elsif ($infile) {
    open($print_in, "<$infile") || die "can't open $infile: $!";
    } # end-elsif

  else {
    $print_in = *STDIN;
    } # end-else

  } # end-else

$prtid = $sysid . ($sysid && $prtname ? "_" : "") . $prtname;
$prtid = ($prtid ? $prtid : "PRINTER");
$logid = $sysid . ($sysid && $prtname ? " " : "") . $prtname;
$outfile_tmp = $tmp . "/" . $prtid . "_$$" . ".tmp";
$outfile_pdf = $tmp . "/" . $prtid . "_$$" . ".pdf";
$form_pos = "\n" x ($start_line - 1);

init();

$readpt = -1;
$printpt = 0;
$buffer = "";
logp("printer started");

while ($ip || $pipe ? 1 : !eof($print_in) || $buffer) {
  $processing = 0;
  $end_of_job = -1;
  $rcount = 1;
  $pcount = 1;
  $vpos = 0;
  $rline = read_line();
  $lines[++$readpt % $lqsz] = $rline;

  if ($printpt == $readpt) {
    logp($ip ? "receiving" : "reading");
    } # end-if

  $processing = 1;
  open($print_out, ">$outfile_tmp") || die "can't open $outfile_tmp: $!";
  $rstate = 0;
  $pstate = 0;
  $job_lines = 0;
  $file_name = "";
  $title = "";
  print $print_out $form_pos;

  while ($rline || $printpt <= $end_of_job) {

    if ($end_of_job < 0) {
      check_read();

      if (substr($rline, -1) ne "\r") {
        ++$rcount;
        } # end-if

      if (index($rline, "\f") >= 0) {
        $rcount = 1;
        } # end-if

      $rline = read_line();

      if ($rline) {
        $lines[++$readpt % $lqsz] = $rline;
        } # end-if

      } # end-if

    if ($readpt - $printpt >= $lqsz - 1 || $printpt <= $end_of_job) {
      $pline = $lines[$printpt % $lqsz];
      check_print();

      if ($pline) {

        if (substr($pline, -1) ne "\r") {
          ++$pcount;
          ++$job_lines;
          } # end-if

        if (substr($pline, -1) eq "\f") {
          $pcount = 1;
          print $print_out substr($pline, 0, -1);
          print $print_out "\n" x ($pagelength - $vpos);
          $vpos = 0;
          } # end-if

        else {
          print $print_out $pline;

          if (substr($pline, -1) ne "\r") {
            ++$vpos;
            } # end-if

          if ($vpos == $pagelength) {
            $vpos = 0;
            } # end-if

          } # end-else

        } # end-if

      ++$printpt;

      } # end-if

    } # end-while

  if (index($pline, "\r") > 0) {
    ++$job_lines;
    } # end-if

  close($print_out);

  if ($job_lines) {
    create_pdf();
    logp("done");
    } # end-if

  system("rm $outfile_tmp");

  } # end-while

close($print_in);

# ------------------------------------------------------------------------------

sub read_line {
  $new_line = "";
  $buffer_eol = 0;

  while (!$buffer_eol && $end_of_job < 0) {
    $buffer =~ /[\r\n\f]/;
    $buffer_eol = $& ? length($`) + 1 : 0;

    if (!$buffer_eol) {
      $new_line .= $buffer;
      $buffer = "";
      read_buffer();
      } # end-if

    else {
      $new_line .= substr($buffer, 0, $buffer_eol);
      $buffer = substr($buffer, $buffer_eol);
      } # end-else

    } # end-while

  return $new_line;

  } # end-sub

sub read_buffer {
  $bytes_in = "";

  if ($ip || $pipe) {

    eval {
      $num_bytes_read = 0;
      local $SIG{ALRM} = sub { die 'Timed Out'; };
      alarm $wait;
      $num_bytes_read = sysread($print_in, $bytes_in, 1024);

      if (!$num_bytes_read) {
        printf "Input stream closed\n";
        exit;
        } # end-if

      alarm 0;
      }; # end-eval

    alarm 0;

    } # end-if

  else {
    $num_bytes_read = read($print_in, $bytes_in, 1024);
    } # end-else

  if (!$num_bytes_read) {

    if ($processing) {
      $end_of_job = $readpt;
      } # end-if

    } # end-if

  else {
    $buffer .= $bytes_in;

    if (!$ip && !$pipe) {

      if (eof($print_in)) {

        if (substr($buffer, -1) ne "\n" && substr($buffer, -1) ne "\f") {
          $buffer .= "\n";
          } # end-if

        } # end-if

      } # end-if

    } # end-else

  } # end-sub

sub create_pdf {
  $fseqn = 1;

  if (!$file_name) {
    $now_string = strftime "%Y-%m-%d-%H.%M.%S", localtime;
    $file_name = $prtid . "_" . $now_string;

    if (!$title) {
      $title = ($logid ? $logid : $prtid) . " " . $now_string;
      } # end-if

    } # end-if

    if (!$title) {
      $title = $file_name;
      } # end-if

    while (-e $path . "/" . $file_name . ($fseqn > 1 ? "_" . $fseqn : "") . ".pdf") {
      ++$fseqn;
      } # end-while

    $pdf_file = $file_name . ($fseqn > 1 ? "_" . $fseqn : "") . ".pdf";
    logp("processing " . $job_lines . " lines");
    logp("file " . $pdf_file);
    $pdf_file =~ s/\$/\\\$/ig;
    $title =~ s/\$/\\\$/ig;

    system "enscript -q -c" . $bar . " -B -L " . $pagelength .
      " --highlight-bar-gray=" . $color .
      " -i 1.3p -f " . $font . " -s " . $skip .
      " --non-printable-format=space" .
      " -t \"" . $title . "\" -o - " . $outfile_tmp .
      " --margins 18:-10:-4:0 -M USFanfold | ps2pdf - " . $outfile_pdf;

    system("mv $outfile_pdf $path/$pdf_file");

  } # end-sub

sub logp {
  my($logline) = @_;
  $now_string = strftime "%b %e %H:%M:%S", localtime;
  print $now_string . " " . $logid . ($logid ? " " : "") . $logline . "\n";
  } # end-sub

sub rtrim {
  $s = shift;
  $s =~ s/\s+$//;
  return $s;
  } # end-sub

